# 演習用サンプルデータ

このフォルダーには、一人学習で安全に使えるよう、教材として一から作った完全な架空データを収録しています。実在する企業、人物、顧客、メールアドレス、契約、社内規程とは関係ありません。

## 使用ルール

- 個人学習でも組織内学習でも、このフォルダーの架空データだけをAIツールへ入力します。
- 自分や他の人の実データ、匿名化したつもりのデータ、実在する画面のコピーへ差し替えません。
- AI出力は必ず元資料と人が照合します。
- 初回演習では、[クイックスタート](../setup/participant_quickstart.md)にある「最初に送る全文」を一度にコピーします。このフォルダーの元メモだけを先にAIへ送る必要はありません。
- 実データを扱うPoCは、この教材では行いません。組織の正式な承認手続と検証環境を別途用意します。
- 特定製品を利用できない場合は、本人または組織が認めた別のAIを使います。承認済みAIを一つも利用できなければ、環境を準備できるまで演習を停止します。[保存済み比較出力](../sample-outputs/README.md)は、自分でAIを実行して照合した後にだけ使います。

## ファイル一覧

| ファイル | 用途 |
|---|---|
| [beginner_meeting_notes.md](beginner_meeting_notes.md) | 初回演習の議事録・タスク一覧と照合する正式な架空会議メモ |
| [video_meeting_transcript.md](video_meeting_transcript.md) | Zoom・Teams共通演習で使う、誤認識を含む未確認の架空自動文字起こし |
| [video_meeting_verification_notes.md](video_meeting_verification_notes.md) | 架空文字起こしを人が照合するための確認カード。実務の許可済み録画・当事者確認を模擬する |
| [monthly_inquiry_cases.csv](monthly_inquiry_cases.csv) | 問い合わせ月次報告演習で分類・集計する30行の架空明細 |
| [monthly_inquiry_classification_rules.md](monthly_inquiry_classification_rules.md) | 問い合わせ分類、優先度、重複、情報不足の正式な判定ルール |
| [manual_handover_notes.md](manual_handover_notes.md) | 業務マニュアル演習で不足・矛盾を見つける未整理の架空引継ぎメモ |
| [manual_confirmation_cards.md](manual_confirmation_cards.md) | 質問後に開き、確定手順と例外を確認する架空の回答カード |
| [prompt_acceptance_policy.md](prompt_acceptance_policy.md) | プロンプト受入テストで期待動作を判定する架空の問い合わせ対応規程 |
| [prompt_acceptance_cases.md](prompt_acceptance_cases.md) | 通常、境界、情報不足、矛盾、対象外、疑似個人情報、指示混入、重複を含む8ケース |
| [business_interview_initial_request.md](business_interview_initial_request.md) | 業務ヒアリング演習で、事実と未確認事項を分ける曖昧な架空依頼文 |
| [business_interview_role_profile.md](business_interview_role_profile.md) | 自分で質問を書いた後に該当カードだけを開く、一人学習用の段階開示プロフィール |
| [rag_training_rules_current.md](rag_training_rules_current.md) | RAG演習用の現行版規程 |
| [rag_training_rules_old.md](rag_training_rules_old.md) | 新旧版の競合を見抜くための失効済み規程 |
| [rag_question_cards.md](rag_question_cards.md) | 資料内・資料外・版競合・攻撃的入力の質問カード |
| [automation_inquiry_cases.md](automation_inquiry_cases.md) | 自動化の通常・例外・停止ケース |
| [automation_flow_cards.md](automation_flow_cards.md) | AIが出した自動化案を人が並べ直し、安全条件を記録する設計カード |
