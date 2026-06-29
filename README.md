# Amazon商品ページ 評価チェッカー

Amazonの商品ページを「60点チェックリスト（全31項目）」で評価する社内ツールです。
`index.html` の1ファイルだけで動作します（サーバー不要）。

## 社内に常設URLで公開する手順（無料）

### 方法A：GitHub Pages（おすすめ・常設URL）
ブラウザだけで完結します。

1. https://github.com/new で新しいリポジトリを作成
   - Repository name: `amazon-checker`（任意）
   - **Public** を選択（社外秘でなければPublicでOK。社外秘なら下の「方法B」推奨）
   - 「Create repository」
2. 作成後の画面で **「uploading an existing file」** をクリック
3. この `index.html`（と必要なら `README.md`）をドラッグ＆ドロップ →「Commit changes」
4. リポジトリの **Settings → Pages** を開く
5. 「Build and deployment」→ Source を **Deploy from a branch**、Branch を **main / (root)** にして Save
6. 1〜2分後、`https://<あなたのID>.github.io/amazon-checker/` が常設URLになります
   - このURLを社内で共有すれば、全員ブラウザで開けます

### 方法B：Netlify Drop（最速・アカウントなしでも試せる）
1. https://app.netlify.com/drop を開く
2. この `amazon-checker-site` フォルダをページにドラッグ＆ドロップ
3. すぐに `https://〇〇〇.netlify.app` のURLが発行されます
   - 無料アカウント登録で常設URL化＆名前変更が可能

### 方法C：社内ファイルサーバー / 共有ドライブ
`index.html` を社内の共有フォルダ（Google Drive / SharePoint / 社内Web）に置くだけでも、
各メンバーがダウンロードして開けば利用できます。

## 注意
- 評価の入力内容は **各自のブラウザ内（localStorage）に保存** されます。URLを公開しても他人の入力は見えません（個人作業用）。
- 結果を共有したい場合は、ツール内の「📋 サマリーをコピー」または「📄 印刷 / PDF保存」を使ってください。
- Amazonページの内容自動取得はブラウザのCORS制限により不可。値の貼り付けによる自動判定＋目視確認の構成です。
