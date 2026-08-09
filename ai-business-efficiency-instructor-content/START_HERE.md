# 学習を始める

このページが、学習順序、必要ファイル、完了条件の基準です。PCの基本操作ができれば、Gitやプログラミングの知識は必要ありません。学習時間は固定せず、成果物と完了条件で次へ進むかを決めます。

## 1. 始める前の前提

- ファイルを開く、コピーする、名前を付けて保存するといったPCの基本操作ができる
- ブラウザでリンクを開ける
- 個人学習では自分の利用環境を、組織利用では承認済み環境と正式窓口を確認できる
- 架空データと実在データを混ぜないと約束できる

有料契約、新規アカウント、Office製品、特定のAI製品は必須ではありません。

## 2. 最初に選ぶ学習経路

| 自分の状況 | 使うもの | 登録・入力前の判断 |
|---|---|---|
| 個人学習 | 本人が公式サイト、利用条件、料金、データ設定を確認した既存環境 | 内容を理解できない契約・権限要求なら登録しない |
| 組織利用 | 組織が承認したURL、業務用アカウント、保存先、相談先 | 承認状態や用途が不明なら登録・入力・連携を止める |
| AIなし | `sample-outputs/`の保存済み出力、紙、Markdown | 新規登録をせず、問題発見と修正へ進む |

どの経路も、`sample-data/`の完全な架空データだけを使います。個人学習でも、自分の仕事のデータへ置き換えません。

## 3. 最初に守る5つのルール

1. 実在する個人情報、機密情報、社内文書、パスワード、APIキーを入力しない
2. ファイル添付、Web検索、外部連携、共有は演習で明示された場合だけ使う
3. AIが作った内容を元資料と照合し、確認できない内容を作り足さない
4. 外部送信、公開、書込み、削除、支払、権限変更を演習中に実行しない
5. 分からない場合は入力前に止め、個人学習ではAIなし経路へ、組織利用では正式窓口へ進む

「名前を消した」「有名なAIを使っている」だけでは安全と判断できません。利用目的、データ分類、契約・設定、必要最小限性、保存・共有、人間レビューをまとめて確認します。

## 4. 学習用フォルダーを準備する

公開リポジトリの中へ演習結果を保存しません。自分のPCまたは組織指定の非公開保存先に、次のようなフォルダーを作ります。

```text
ai-learning-work/
├── 01_quickstart/
├── 02_core-lessons/
├── 03_exercises/
├── 04_capstone/
└── learning_progress.md
```

個人名、顧客名、会社名、案件名をフォルダ名やファイル名へ入れません。[学習進捗シート](LEARNING_PROGRESS.md)を`learning_progress.md`としてコピーできます。GitHubへのコミット、Issueへの投稿、共有リンクの作成は行いません。

## 5. 各章・演習の進め方

1. 前提、使用ファイル、成果物、開始条件、停止条件を確認する
2. 個人学習、組織利用、AIなしから一つの経路を選ぶ
3. 説明と手順付き練習を読む
4. 自分の成果物を先に作り、ローカルの学習用フォルダーへ保存する
5. AI出力を元資料・規程・公式情報と人が照合する
6. 詰まった箇所だけ、自己点検のヒント1から順に見る
7. 一致が必要な事実、成立する別解、危険な状態を比較する
8. 違いの理由を一つ記録し、成果物を一か所以上修正する
9. 修正版を元資料へ再照合し、完了条件を満たしたら次へ進む

`self-check/`の例は唯一の正解ではありません。自分の成果物を作って保存する前に、成果物例を丸写ししないでください。

## 6. 学習マップ

### 6.1 導入

| 順番 | 行うこと | 主な成果物 | 完了判断 |
|---:|---|---|---|
| 0 | [共通準備](setup/common_preparation.md)で安全と保存先を確認する | 学習経路と保存先の記録 | 入力禁止情報と停止条件を説明できる |
| 1 | [クイックスタート](setup/participant_quickstart.md)を行う | 確認済み議事録、タスク一覧、照合記録 | 元メモと全件照合し、一か所以上修正した |

### 6.2 必修編：第01〜07章

| 順番 | 読む | 作るもの | 自己点検 |
|---:|---|---|---|
| 2 | [第01章 生成AIの基礎](01_generative_ai_basics.md) | AIの得意・不得意と人の役割の説明 | [第01章の自己点検](self-check/chapters/01_generative_ai_basics_self_check.md) |
| 3 | [第02章 セキュリティとプライバシー](02_security_and_privacy.md) | 入力可否・停止・相談の判断記録 | [第02章の自己点検](self-check/chapters/02_security_and_privacy_self_check.md) |
| 4 | [第03章 業務プロセス分析](03_business_process_analysis.md) | Before / Afterと役割分担 | [第03章の自己点検](self-check/chapters/03_business_process_analysis_self_check.md) |
| 5 | [第04章 プロンプト設計](04_prompt_engineering.md) | 完成条件を含む再利用可能な指示 | [第04章の自己点検](self-check/chapters/04_prompt_engineering_self_check.md) |
| 6 | [第05章 ハルシネーションとファクトチェック](05_hallucination_and_fact_checking.md) | 主張・根拠・確認日の記録 | [第05章の自己点検](self-check/chapters/05_hallucination_and_fact_checking_self_check.md) |
| 7 | [第06章 著作権とAIガバナンス](06_copyright_and_ai_governance.md) | 公開前レビューと相談事項 | [第06章の自己点検](self-check/chapters/06_copyright_and_ai_governance_self_check.md) |
| 8 | [第07章 AIツールの全体像と選び方](07_ai_tools_overview.md) | 用途・データ・統制を含む比較記録 | [第07章の自己点検](self-check/chapters/07_ai_tools_overview_self_check.md) |

第01〜07章は順番に進めます。第07章の完了後に、利用可能な製品と安全条件を確認してから実務演習へ進みます。

### 6.3 実務ハンズオン

[実務ハンズオン演習ガイド](exercises/README.md)も併用します。総合課題へ進む前に、**成果物作成から一つ以上、設計・リスクから一つ以上**を完了します。

| 区分 | 演習 | 主な成果物 | 自己点検 |
|---|---|---|---|
| 成果物作成 | [メール・議事録・報告書](exercises/email_minutes_report_exercises.md) | 返信文、議事録、報告書、要約 | [自己点検](self-check/exercises/email_minutes_report_self_check.md) |
| 成果物作成 | [Zoom・Teams共通のテレビ会議議事録](exercises/video_meeting_minutes_exercises.md) | 検証済み議事録、根拠位置付きタスク一覧 | [自己点検](self-check/exercises/video_meeting_minutes_self_check.md) |
| 成果物作成 | [問い合わせ明細からExcel月次報告](exercises/inquiry_excel_monthly_report_exercises.md) | 分類済み明細、集計表、月次報告 | [自己点検](self-check/exercises/inquiry_excel_monthly_report_self_check.md) |
| 成果物作成 | [引継ぎメモから業務マニュアル](exercises/business_manual_creation_exercises.md) | テスト済み手順書、例外処理、改訂履歴 | [自己点検](self-check/exercises/business_manual_creation_self_check.md) |
| 設計・リスク | [プロンプト受入テスト](exercises/prompt_acceptance_testing_exercises.md) | 改善前後の指示、テスト記録、停止条件 | [自己点検](self-check/exercises/prompt_acceptance_testing_self_check.md) |
| 設計・リスク | [業務プロセスマッピング](exercises/business_process_mapping_exercises.md) | Before / After、AI・人・通常自動化の役割 | [自己点検](self-check/exercises/business_process_mapping_self_check.md) |
| 設計・リスク | [AI利用リスク判断](exercises/risk_judgment_exercises.md) | 入力可否、停止、相談の判断記録 | [自己点検](self-check/exercises/risk_judgment_self_check.md) |
| 設計・リスク | [業務ヒアリングからAI活用試行提案](exercises/business_interview_improvement_proposal_exercises.md) | 事実・仮定・未確認の記録、Before / After、1ページ提案 | [自己点検](self-check/exercises/business_interview_improvement_proposal_self_check.md) |

すべて行う必要はありません。選んだ演習では、元資料照合、一か所以上の修正、完了条件の確認まで省略しません。

### 6.4 任意発展編

| 順番 | 読む | 作るもの | 自己点検 |
|---:|---|---|---|
| 9 | [第08章 RAGとナレッジ管理](08_rag_and_knowledge_management.md) | 根拠・版・権限を含むRAG設計 | [第08章の自己点検](self-check/chapters/08_rag_and_knowledge_management_self_check.md) |
| 10 | [第09章 AI自動化とAIエージェント](09_ai_automation_and_agents.md) | 承認・ログ・停止・復旧を含むフロー | [第09章の自己点検](self-check/chapters/09_ai_automation_and_agents_self_check.md) |

第08・09章は、実サービスへ接続しなくても、収録済みの架空資料と保存済み出力で完了できます。APIキーの設定や外部システムへの書込みは基本経路で行いません。

### 6.5 総合課題

| 順番 | 読む | 作るもの | 自己点検 |
|---:|---|---|---|
| 11 | [第10章 総合業務改善プロジェクト](10_business_application_capstone.md) | 実データを使う前の、架空ケースによる小規模試行案 | [第10章の自己点検](self-check/chapters/10_business_application_capstone_self_check.md) |

## 7. 学習の完了水準

| 完了水準 | 必要なもの | 説明できる範囲 |
|---|---|---|
| 基礎・実務活用 | 導入、第01〜07章、成果物作成1つ以上、設計・リスク1つ以上、第10章 | 基本的なAI活用、業務分解、人間確認、安全な試行案 |
| 全編 | 上記に加え、第08・09章 | RAG、ナレッジ管理、承認付き自動化、AIエージェントの基本設計 |

どちらも、ファイルを開いただけでは完了ではありません。各成果物を元資料と自己点検で確認し、少なくとも一か所を修正した記録を残します。

## 8. 終了するとき

[終了時チェックリスト](workbooks/course_closeout_checklist.md)で、保存先、共有リンク、アップロード、サインアウト、試用契約、外部連携、未解決事項を確認します。履歴や証跡は自己判断で削除せず、個人学習ではサービスの正式手順、組織利用では組織の規程に従います。

## 9. 困ったとき

| 状況 | 次に行うこと |
|---|---|
| AIへログインできない | 個人登録を増やさず、その章・演習のAIなし経路へ切り替える |
| AI出力が例と違う | 元資料との一致を先に確認し、表現の違いは自己点検の「成立する別解」で確認する |
| 実在情報を入力しそう | 送信前に止め、`sample-data/`へ戻る |
| 間違って入力・共有した | 画面共有や処理を止め、秘密値を別メモへ写さず、[セキュリティ方針](SECURITY.md)と正式窓口に従う |
| 操作や表示が分からない | [トラブル対応](TROUBLESHOOTING.md)を確認する |
| 法律・著作権・個人情報・医療・金融・人事の個別判断 | AIだけで結論を出さず、必要な担当者・有資格の専門家へ相談する |

[学習進捗シート](LEARNING_PROGRESS.md) ｜ [用語集](glossary.md) ｜ [トラブル対応](TROUBLESHOOTING.md)
