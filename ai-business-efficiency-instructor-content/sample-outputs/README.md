# 保存済み比較・誤り発見用出力

このフォルダーには、自分でAIを実行した後に、別の失敗例や設計例と比較するための固定教材があります。**AIの実操作を代替するファイルではありません。** 承認済みAIを利用できない場合は、環境を準備できるまで対応する演習を停止します。

## 重要な注意

- 実際の製品が生成した最新出力や、現在の画面を再現する資料ではありません。
- すべて完全な架空データから作った教育用の例です。
- 良い例だけでなく、誤り・根拠不足・停止すべき例も含みます。
- 正解として写すのではなく、元資料との照合、問題発見、修正、停止を練習します。
- 自分のAI出力と人間照合を先に終え、演習が指定したタイミングでだけ開きます。
- 通信障害がAI実行後に起きた場合は、それまでの結果を補助的に比較できますが、未実行の必須操作を完了したことにはできません。
- 製品の機能・画面・契約条件は、利用前に各社の最新公式情報で確認します。

## 利用手順

1. 対応する演習本文から、開くタイミングと対象ファイルを確認します。
2. 承認済みAIを自分で操作し、初回出力、元資料照合、必要な修正を先に行います。
3. 対応する`sample-data/`の元資料を確認します。
4. 保存済み出力を開き、自分のAI出力とは異なる問題や観点を探します。
5. 元資料にない決定、担当、期限、根拠が自分の出力にもないか再照合します。
6. 自分のAIへ必要な修正指示を返し、再出力も人が確認します。
7. 自分で確認した最終成果物だけを安全な場所へ保存し、保存済み出力そのものを完成品として外部送信・公開しません。

| ファイル | 用途 |
|---|---|
| [beginner_minutes_saved_output.md](beginner_minutes_saved_output.md) | 初回の議事録・タスク演習で、決定扱いと担当・期限の作り足しを見抜く問題例 |
| [video_meeting_ai_minutes_problem.md](video_meeting_ai_minutes_problem.md) | テレビ会議の未確認文字起こしから作られた、数字・否定・話者・担当・期限の誤りを含む議事録問題例 |
| [inquiry_monthly_ai_output_problem.md](inquiry_monthly_ai_output_problem.md) | 問い合わせ分類の誤り、作り足し、集計不整合を見抜く月次報告の問題例 |
| [manual_ai_output_problem.md](manual_ai_output_problem.md) | 引継ぎメモの矛盾を推測で埋め、例外を落とした業務マニュアルの問題例 |
| [prompt_acceptance_v1_outputs.md](prompt_acceptance_v1_outputs.md) | 8ケースの受入テストで、改善箇所を特定するための保存済みv1出力 |
| [business_interview_saved_responses.md](business_interview_saved_responses.md) | 自分のAI提案を照合した後に比較する、過大な改善提案の問題例 |
| [notebooklm_saved_answers.md](notebooklm_saved_answers.md) | RAG回答の原文照合、版競合、未回答判断 |
| [automation_saved_test_output.md](automation_saved_test_output.md) | 自動化の通常・停止・重複ケースの観察 |
| [dify_saved_design_output.md](dify_saved_design_output.md) | 承認済みAIで設計案を作った後に比較する、AIチャットボットの固定設計例 |
