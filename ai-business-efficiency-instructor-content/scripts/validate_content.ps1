[CmdletBinding()]
param(
    [string]$Root
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($Root)) {
    $scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
    $Root = Split-Path -Parent $scriptDirectory
}

$resolvedRoot = (Resolve-Path -LiteralPath $Root).ProviderPath
$rootPath = [System.IO.Path]::GetFullPath($resolvedRoot)
$rootPrefix = $rootPath.TrimEnd([char[]]@('\', '/')) + [System.IO.Path]::DirectorySeparatorChar
$errors = New-Object 'System.Collections.Generic.List[string]'
$utf8Strict = New-Object System.Text.UTF8Encoding($false, $true)

function Add-ValidationError {
    param([string]$Message)
    $script:errors.Add($Message)
}

function Get-RepoRelativePath {
    param([string]$Path)

    $fullPath = [System.IO.Path]::GetFullPath($Path)
    if ($fullPath.StartsWith($script:rootPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $fullPath.Substring($script:rootPrefix.Length).Replace('\', '/')
    }
    if ($fullPath.Equals($script:rootPath, [System.StringComparison]::OrdinalIgnoreCase)) {
        return '.'
    }
    return $fullPath.Replace('\', '/')
}

function Get-Utf8Text {
    param([string]$Path)

    try {
        $bytes = [System.IO.File]::ReadAllBytes($Path)
        return $script:utf8Strict.GetString($bytes)
    }
    catch {
        Add-ValidationError ((Get-RepoRelativePath $Path) + ' : invalid UTF-8 text.')
        return $null
    }
}

function Test-PathInsideRoot {
    param([string]$Path)

    $fullPath = [System.IO.Path]::GetFullPath($Path)
    return $fullPath.StartsWith($script:rootPrefix, [System.StringComparison]::OrdinalIgnoreCase) -or
        $fullPath.Equals($script:rootPath, [System.StringComparison]::OrdinalIgnoreCase)
}

function Test-ExactPathCase {
    param([string]$Path)

    $fullPath = [System.IO.Path]::GetFullPath($Path)
    if (-not (Test-PathInsideRoot $fullPath)) {
        return $false
    }

    $relative = Get-RepoRelativePath $fullPath
    if ($relative -eq '.') {
        return $true
    }

    $current = Get-Item -LiteralPath $script:rootPath
    foreach ($part in ($relative -split '/')) {
        $match = @(Get-ChildItem -LiteralPath $current.FullName -Force | Where-Object { $_.Name -ceq $part })
        if ($match.Count -ne 1) {
            return $false
        }
        $current = $match[0]
    }
    return $true
}

function Get-MarkdownTableCells {
    param([string]$Line)

    $value = $Line.Trim()
    if ($value.StartsWith('|')) {
        $value = $value.Substring(1)
    }
    if ($value.EndsWith('|') -and -not $value.EndsWith('\|')) {
        $value = $value.Substring(0, $value.Length - 1)
    }
    return @([regex]::Split($value, '(?<!\\)\|'))
}

function Test-MarkdownStructure {
    param(
        [System.IO.FileInfo]$File,
        [string]$Text
    )

    $relative = Get-RepoRelativePath $File.FullName
    $lines = @($Text -split "`r?`n", 0)
    $inFence = $false
    $fenceMarker = ''
    $headingLevels = New-Object 'System.Collections.Generic.List[int]'
    $outsideFence = New-Object 'System.Collections.Generic.List[bool]'

    foreach ($line in $lines) {
        $fenceMatch = [regex]::Match($line, '^[ \t]*(?<marker>`{3,}|~{3,})')
        if ($fenceMatch.Success) {
            $marker = $fenceMatch.Groups['marker'].Value.Substring(0, 1)
            if (-not $inFence) {
                $inFence = $true
                $fenceMarker = $marker
            }
            elseif ($marker -eq $fenceMarker) {
                $inFence = $false
                $fenceMarker = ''
            }
            $outsideFence.Add($false)
            continue
        }

        $outsideFence.Add(-not $inFence)
        if (-not $inFence) {
            $headingMatch = [regex]::Match($line, '^(?<marks>#{1,6})[ \t]+\S')
            if ($headingMatch.Success) {
                $headingLevels.Add($headingMatch.Groups['marks'].Value.Length)
            }
        }
    }

    if ($inFence) {
        Add-ValidationError ($relative + ' : unclosed code fence.')
    }

    if ($headingLevels.Count -eq 0) {
        Add-ValidationError ($relative + ' : no Markdown heading.')
    }
    else {
        $h1Count = @($headingLevels | Where-Object { $_ -eq 1 }).Count
        if ($h1Count -ne 1) {
            Add-ValidationError ($relative + ' : expected exactly one level-1 heading; found ' + $h1Count + '.')
        }
        if ($headingLevels[0] -ne 1) {
            Add-ValidationError ($relative + ' : first heading is not level 1.')
        }
        for ($index = 1; $index -lt $headingLevels.Count; $index++) {
            if ($headingLevels[$index] -gt ($headingLevels[$index - 1] + 1)) {
                Add-ValidationError ($relative + ' : heading level jumps from H' + $headingLevels[$index - 1] + ' to H' + $headingLevels[$index] + '.')
            }
        }
    }

    $detailsOpen = [regex]::Matches($Text, '(?im)^[ \t]*<details(?:\s[^>]*)?>[ \t]*$').Count
    $detailsClose = [regex]::Matches($Text, '(?im)^[ \t]*</details>[ \t]*$').Count
    if ($detailsOpen -ne $detailsClose) {
        Add-ValidationError ($relative + ' : details tag count differs; open=' + $detailsOpen + ', close=' + $detailsClose + '.')
    }

    for ($lineIndex = 1; $lineIndex -lt $lines.Count; $lineIndex++) {
        if (-not $outsideFence[$lineIndex] -or -not $outsideFence[$lineIndex - 1]) {
            continue
        }
        if ($lines[$lineIndex] -notmatch '\|') {
            continue
        }

        $separatorCells = @(Get-MarkdownTableCells $lines[$lineIndex])
        if ($separatorCells.Count -eq 0) {
            continue
        }
        $isSeparator = $true
        foreach ($cell in $separatorCells) {
            if ($cell.Trim() -notmatch '^:?-{3,}:?$') {
                $isSeparator = $false
                break
            }
        }
        if (-not $isSeparator -or $lines[$lineIndex - 1] -notmatch '\|') {
            continue
        }

        $expectedColumns = @(Get-MarkdownTableCells $lines[$lineIndex - 1]).Count
        if ($separatorCells.Count -ne $expectedColumns) {
            Add-ValidationError ($relative + ':' + ($lineIndex + 1) + ' : table separator has ' + $separatorCells.Count + ' columns; expected ' + $expectedColumns + '.')
        }

        $rowIndex = $lineIndex + 1
        while ($rowIndex -lt $lines.Count -and $outsideFence[$rowIndex] -and $lines[$rowIndex].Trim().StartsWith('|')) {
            $rowColumns = @(Get-MarkdownTableCells $lines[$rowIndex]).Count
            if ($rowColumns -ne $expectedColumns) {
                Add-ValidationError ($relative + ':' + ($rowIndex + 1) + ' : table row has ' + $rowColumns + ' columns; expected ' + $expectedColumns + '.')
            }
            $rowIndex++
        }
    }
}

function Test-MarkdownLinks {
    param(
        [System.IO.FileInfo]$File,
        [string]$Text
    )

    $relative = Get-RepoRelativePath $File.FullName
    $matches = [regex]::Matches($Text, '!?(?:\[[^\]]*\])\((?<target><[^>]+>|[^)\s]+)(?:\s+"[^"]*")?\)')
    foreach ($match in $matches) {
        $target = $match.Groups['target'].Value.Trim('<', '>')
        if ([string]::IsNullOrWhiteSpace($target) -or $target -match '^(?:https?://|mailto:|data:|#)') {
            continue
        }

        $targetWithoutAnchor = ($target -split '#', 2)[0]
        $targetWithoutQuery = ($targetWithoutAnchor -split '\?', 2)[0]
        if ([string]::IsNullOrWhiteSpace($targetWithoutQuery)) {
            continue
        }

        try {
            $decodedTarget = [System.Uri]::UnescapeDataString($targetWithoutQuery)
            $candidate = [System.IO.Path]::GetFullPath((Join-Path $File.DirectoryName $decodedTarget))
        }
        catch {
            Add-ValidationError ($relative + ' : invalid local link: ' + $target)
            continue
        }

        if (-not (Test-PathInsideRoot $candidate)) {
            Add-ValidationError ($relative + ' : local link escapes repository root: ' + $target)
            continue
        }
        if (-not (Test-Path -LiteralPath $candidate)) {
            Add-ValidationError ($relative + ' : missing local link target: ' + $target)
            continue
        }
        if (-not (Test-ExactPathCase $candidate)) {
            Add-ValidationError ($relative + ' : local link path has incorrect letter case: ' + $target)
        }
    }
}

$markdownFiles = @(Get-ChildItem -LiteralPath $rootPath -Recurse -File -Filter '*.md' |
    Where-Object { $_.FullName -notmatch '[\\/]\.git[\\/]' } |
    Sort-Object FullName)

$forbiddenContentPatterns = @(
    '(?i)\u8b1b\u5e2b',
    '(?i)\u53d7\u8b1b\u8005\u7248',
    '(?i)instructor_preflight|instructor_observation_sheet|training_slide_outline',
    '(?i)(?:answers|participant|fallback-output|distribution)/',
    '(?i)00_course_overview|10_training_design_workshop|11_instructor_delivery_practicum',
    '(?i)tokens truncated|chars truncated|lines truncated|warning:\s*truncated output|script completed|script running with cell id|total output lines'
)

foreach ($file in $markdownFiles) {
    $text = Get-Utf8Text $file.FullName
    if ($null -eq $text) {
        continue
    }
    $relative = Get-RepoRelativePath $file.FullName

    foreach ($pattern in $forbiddenContentPatterns) {
        if ($text -match $pattern) {
            Add-ValidationError ($relative + ' : forbidden legacy, role-specific, or generated-output text matches: ' + $pattern)
        }
    }

    if ($text -match '(?i)[A-Z]:\\Users\\[^\\\s]+') {
        Add-ValidationError ($relative + ' : user-specific absolute Windows path found.')
    }

    Test-MarkdownStructure -File $file -Text $text
    Test-MarkdownLinks -File $file -Text $text
}

$requiredFiles = @(
    'README.md',
    'START_HERE.md',
    'LEARNING_PROGRESS.md',
    'TROUBLESHOOTING.md',
    'glossary.md',
    'CONTRIBUTING.md',
    'LICENSE',
    'LICENSE_GUIDE.md',
    'NOTICE.md',
    'SECURITY.md',
    'SUPPORT.md',
    'CODE_OF_CONDUCT.md',
    'CHANGELOG.md',
    'MAINTENANCE_CHECKLIST.md',
    '.github/ISSUE_TEMPLATE/config.yml',
    '.github/ISSUE_TEMPLATE/content-improvement.yml',
    '.github/pull_request_template.md',
    '.github/workflows/validate-content.yml',
    '01_generative_ai_basics.md',
    '02_security_and_privacy.md',
    '03_business_process_analysis.md',
    '04_prompt_engineering.md',
    '05_hallucination_and_fact_checking.md',
    '06_copyright_and_ai_governance.md',
    '07_ai_tools_overview.md',
    '08_rag_and_knowledge_management.md',
    '09_ai_automation_and_agents.md',
    '10_business_application_capstone.md'
)

foreach ($required in $requiredFiles) {
    if (-not (Test-Path -LiteralPath (Join-Path $rootPath $required))) {
        Add-ValidationError ('missing required file: ' + $required)
    }
}

$forbiddenPaths = @(
    '00_course_overview.md',
    '10_training_design_workshop.md',
    '11_instructor_delivery_practicum.md',
    'answers',
    'participant',
    'fallback-output',
    'distribution',
    'setup/instructor_preflight.md',
    'templates/instructor_observation_sheet.md',
    'templates/training_slide_outline.md'
)

foreach ($forbidden in $forbiddenPaths) {
    $forbiddenFullPath = Join-Path $rootPath $forbidden
    if (Test-Path -LiteralPath $forbiddenFullPath) {
        $forbiddenItem = Get-Item -LiteralPath $forbiddenFullPath
        if (-not $forbiddenItem.PSIsContainer -or @(Get-ChildItem -LiteralPath $forbiddenFullPath -Force -Recurse -File).Count -gt 0) {
            Add-ValidationError ('forbidden legacy path still exists: ' + $forbidden)
        }
    }
}

$chapterChecks = [ordered]@{
    '01_generative_ai_basics.md' = 'self-check/chapters/01_generative_ai_basics_self_check.md'
    '02_security_and_privacy.md' = 'self-check/chapters/02_security_and_privacy_self_check.md'
    '03_business_process_analysis.md' = 'self-check/chapters/03_business_process_analysis_self_check.md'
    '04_prompt_engineering.md' = 'self-check/chapters/04_prompt_engineering_self_check.md'
    '05_hallucination_and_fact_checking.md' = 'self-check/chapters/05_hallucination_and_fact_checking_self_check.md'
    '06_copyright_and_ai_governance.md' = 'self-check/chapters/06_copyright_and_ai_governance_self_check.md'
    '07_ai_tools_overview.md' = 'self-check/chapters/07_ai_tools_overview_self_check.md'
    '08_rag_and_knowledge_management.md' = 'self-check/chapters/08_rag_and_knowledge_management_self_check.md'
    '09_ai_automation_and_agents.md' = 'self-check/chapters/09_ai_automation_and_agents_self_check.md'
    '10_business_application_capstone.md' = 'self-check/chapters/10_business_application_capstone_self_check.md'
}

$requiredChapterPatterns = [ordered]@{
    'personal route' = '\u500b\u4eba\u5b66\u7fd2'
    'organization route' = '\u7d44\u7e54\u5229\u7528'
    'no-AI route' = 'AI\u306a\u3057'
    'self-check' = '\u81ea\u5df1\u70b9\u691c'
    'stop condition' = '\u505c\u6b62\u6761\u4ef6'
}

foreach ($chapter in $chapterChecks.Keys) {
    $chapterPath = Join-Path $rootPath $chapter
    $checkRelative = $chapterChecks[$chapter]
    $checkPath = Join-Path $rootPath $checkRelative
    if (-not (Test-Path -LiteralPath $chapterPath)) {
        continue
    }
    if (-not (Test-Path -LiteralPath $checkPath)) {
        Add-ValidationError ($chapter + ' : missing self-check file: ' + $checkRelative)
        continue
    }

    $chapterText = Get-Utf8Text $chapterPath
    if ($null -eq $chapterText) {
        continue
    }
    foreach ($label in $requiredChapterPatterns.Keys) {
        if ($chapterText -notmatch $requiredChapterPatterns[$label]) {
            Add-ValidationError ($chapter + ' : missing required learning element: ' + $label)
        }
    }
    $checkLeaf = Split-Path -Leaf $checkRelative
    if ($chapterText -notmatch [regex]::Escape($checkLeaf)) {
        Add-ValidationError ($chapter + ' : does not link to its self-check file.')
    }
}

$exerciseChecks = [ordered]@{
    'email_minutes_report_exercises.md' = 'email_minutes_report_self_check.md'
    'video_meeting_minutes_exercises.md' = 'video_meeting_minutes_self_check.md'
    'inquiry_excel_monthly_report_exercises.md' = 'inquiry_excel_monthly_report_self_check.md'
    'business_manual_creation_exercises.md' = 'business_manual_creation_self_check.md'
    'prompt_acceptance_testing_exercises.md' = 'prompt_acceptance_testing_self_check.md'
    'business_process_mapping_exercises.md' = 'business_process_mapping_self_check.md'
    'risk_judgment_exercises.md' = 'risk_judgment_self_check.md'
    'business_interview_improvement_proposal_exercises.md' = 'business_interview_improvement_proposal_self_check.md'
}

foreach ($exercise in $exerciseChecks.Keys) {
    $exercisePath = Join-Path (Join-Path $rootPath 'exercises') $exercise
    $checkLeaf = $exerciseChecks[$exercise]
    $checkPath = Join-Path (Join-Path $rootPath 'self-check/exercises') $checkLeaf
    if (-not (Test-Path -LiteralPath $exercisePath)) {
        Add-ValidationError ('missing exercise file: exercises/' + $exercise)
        continue
    }
    if (-not (Test-Path -LiteralPath $checkPath)) {
        Add-ValidationError ('missing exercise self-check: self-check/exercises/' + $checkLeaf)
        continue
    }
    $exerciseText = Get-Utf8Text $exercisePath
    if ($null -ne $exerciseText) {
        foreach ($label in $requiredChapterPatterns.Keys) {
            if ($label -eq 'stop condition') {
                continue
            }
            if ($exerciseText -notmatch $requiredChapterPatterns[$label]) {
                Add-ValidationError ('exercises/' + $exercise + ' : missing required learning element: ' + $label)
            }
        }
        if ($exerciseText -notmatch [regex]::Escape($checkLeaf)) {
            Add-ValidationError ('exercises/' + $exercise + ' : does not link to its self-check file.')
        }
    }
}

$startPath = Join-Path $rootPath 'START_HERE.md'
if (Test-Path -LiteralPath $startPath) {
    $startText = Get-Utf8Text $startPath
    if ($null -ne $startText) {
        foreach ($chapter in $chapterChecks.Keys) {
            if ($startText -notmatch [regex]::Escape($chapter)) {
                Add-ValidationError ('START_HERE.md : missing chapter link: ' + $chapter)
            }
        }
        foreach ($exercise in $exerciseChecks.Keys) {
            if ($startText -notmatch [regex]::Escape($exercise)) {
                Add-ValidationError ('START_HERE.md : missing exercise link: ' + $exercise)
            }
        }
    }
}

$readmePath = Join-Path $rootPath 'README.md'
if (Test-Path -LiteralPath $readmePath) {
    $readmeText = Get-Utf8Text $readmePath
    if ($null -ne $readmeText) {
        if ($readmeText -notmatch [regex]::Escape('(START_HERE.md)')) {
            Add-ValidationError 'README.md : missing start-guide link.'
        }
        if ($readmeText -match '\((?:0[1-9]|10)_[^)]+\.md\)') {
            Add-ValidationError 'README.md : detailed chapter links must remain in START_HERE.md only.'
        }
    }
}

$issueConfigPath = Join-Path $rootPath '.github/ISSUE_TEMPLATE/config.yml'
if (Test-Path -LiteralPath $issueConfigPath) {
    $issueConfig = Get-Utf8Text $issueConfigPath
    if ($null -ne $issueConfig -and $issueConfig -notmatch '(?m)^blank_issues_enabled:\s*false\s*$') {
        Add-ValidationError '.github/ISSUE_TEMPLATE/config.yml : blank issues are not disabled.'
    }
}

$issueFormPath = Join-Path $rootPath '.github/ISSUE_TEMPLATE/content-improvement.yml'
if (Test-Path -LiteralPath $issueFormPath) {
    $issueForm = Get-Utf8Text $issueFormPath
    if ($null -ne $issueForm) {
        if ($issueForm -match '(?m)^labels:\s*') {
            Add-ValidationError '.github/ISSUE_TEMPLATE/content-improvement.yml : label dependency should be removed or provisioned explicitly.'
        }
        $requiredCount = [regex]::Matches($issueForm, '(?m)^\s+required:\s*true\s*$').Count
        if ($requiredCount -lt 8) {
            Add-ValidationError ('.github/ISSUE_TEMPLATE/content-improvement.yml : expected at least 8 required fields/checks; found ' + $requiredCount + '.')
        }
    }
}

$workflowPath = Join-Path $rootPath '.github/workflows/validate-content.yml'
if (Test-Path -LiteralPath $workflowPath) {
    $workflowText = Get-Utf8Text $workflowPath
    if ($null -ne $workflowText) {
        if ($workflowText -notmatch [regex]::Escape('powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate_content.ps1')) {
            Add-ValidationError '.github/workflows/validate-content.yml : missing Windows PowerShell 5.1 validation step.'
        }
        if ($workflowText -notmatch '(?m)^\s*shell:\s*pwsh\s*$') {
            Add-ValidationError '.github/workflows/validate-content.yml : missing PowerShell 7 validation step.'
        }
    }
}

$yamlFiles = @(Get-ChildItem -LiteralPath (Join-Path $rootPath '.github') -Recurse -File |
    Where-Object { $_.Extension -in @('.yml', '.yaml') })
foreach ($yamlFile in $yamlFiles) {
    $yamlText = Get-Utf8Text $yamlFile.FullName
    if ($null -ne $yamlText -and $yamlText -match '(?m)^\t') {
        Add-ValidationError ((Get-RepoRelativePath $yamlFile.FullName) + ' : YAML indentation contains a tab.')
    }
}

$csvPath = Join-Path $rootPath 'sample-data/monthly_inquiry_cases.csv'
if (Test-Path -LiteralPath $csvPath) {
    try {
        $rows = @(Import-Csv -LiteralPath $csvPath -Encoding UTF8)
        if ($rows.Count -ne 30) {
            Add-ValidationError ('sample-data/monthly_inquiry_cases.csv : expected 30 data rows; found ' + $rows.Count + '.')
        }
        if ($rows.Count -gt 0 -and @($rows[0].PSObject.Properties).Count -ne 6) {
            Add-ValidationError 'sample-data/monthly_inquiry_cases.csv : expected 6 columns.'
        }
    }
    catch {
        Add-ValidationError ('sample-data/monthly_inquiry_cases.csv : CSV parse failed: ' + $_.Exception.Message)
    }
}

$tsvFiles = @(Get-ChildItem -LiteralPath $rootPath -Recurse -File -Filter '*.tsv')
foreach ($tsvFile in $tsvFiles) {
    $tsvText = Get-Utf8Text $tsvFile.FullName
    if ($null -eq $tsvText) {
        continue
    }
    $tsvLines = @($tsvText -split "`r?`n" | Where-Object { $_.Length -gt 0 })
    if ($tsvLines.Count -eq 0) {
        Add-ValidationError ((Get-RepoRelativePath $tsvFile.FullName) + ' : empty TSV file.')
        continue
    }
    $expectedColumns = @($tsvLines[0] -split "`t", -1).Count
    for ($tsvIndex = 1; $tsvIndex -lt $tsvLines.Count; $tsvIndex++) {
        $columns = @($tsvLines[$tsvIndex] -split "`t", -1).Count
        if ($columns -ne $expectedColumns) {
            Add-ValidationError ((Get-RepoRelativePath $tsvFile.FullName) + ':' + ($tsvIndex + 1) + ' : TSV row has ' + $columns + ' columns; expected ' + $expectedColumns + '.')
        }
    }
}

if ($errors.Count -gt 0) {
    Write-Host ('Content validation failed with ' + $errors.Count + ' issue(s).') -ForegroundColor Red
    foreach ($validationError in $errors) {
        Write-Host ('- ' + $validationError) -ForegroundColor Red
    }
    exit 1
}

Write-Host ('Content validation passed. Markdown files: ' + $markdownFiles.Count) -ForegroundColor Green
