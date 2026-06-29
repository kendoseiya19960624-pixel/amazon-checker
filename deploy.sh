#!/bin/bash
# ============================================================
# Amazon商品ページ評価チェッカー  GitHub Pages ワンコマンド公開
# ------------------------------------------------------------
# 使い方:  ターミナルでこのフォルダに移動して
#            bash deploy.sh
#          を実行するだけ。途中でGitHubのユーザー名とトークンを聞きます。
#
# 事前準備（初回のみ・約1分）:
#   1. https://github.com/settings/tokens/new を開く
#   2. Note: amazon-checker  /  Expiration: 任意
#   3. 「repo」に必ずチェック（Pages作成に必要）→ Generate token
#   4. 表示された ghp_XXXX... をコピー（このあと貼り付けます）
# ============================================================
set -e
cd "$(dirname "$0")"

echo "=============================================="
echo " Amazon評価チェッカー  GitHub Pages 公開ツール"
echo "=============================================="
echo

read -rp "GitHubのユーザー名: " GH_USER
read -rp "リポジトリ名 [amazon-checker]: " REPO
REPO=${REPO:-amazon-checker}
echo -n "アクセストークン(ghp_...): "
read -rs GH_TOKEN
echo
echo

if [ -z "$GH_USER" ] || [ -z "$GH_TOKEN" ]; then
  echo "❌ ユーザー名とトークンは必須です。"; exit 1
fi

API="https://api.github.com"
AUTH="Authorization: token $GH_TOKEN"
ACCEPT="Accept: application/vnd.github+json"

echo "▶ リポジトリ $GH_USER/$REPO を作成中..."
CREATE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/user/repos" \
  -H "$AUTH" -H "$ACCEPT" \
  -d "{\"name\":\"$REPO\",\"description\":\"Amazon商品ページ評価チェッカー\",\"private\":false}")
if [ "$CREATE" = "201" ]; then
  echo "  ✅ 作成しました"
elif [ "$CREATE" = "422" ]; then
  echo "  ℹ 既に存在するリポジトリに上書きします"
else
  echo "  ⚠ 作成レスポンス: HTTP $CREATE（続行します）"
fi

echo "▶ ファイルをアップロード中..."
git init -q 2>/dev/null || true
git add -A
git -c user.email="$GH_USER@users.noreply.github.com" -c user.name="$GH_USER" \
    commit -q -m "Amazon評価チェッカー 公開" 2>/dev/null || echo "  (変更なし)"
git branch -M main
git remote remove origin 2>/dev/null || true
git remote add origin "https://$GH_USER:$GH_TOKEN@github.com/$GH_USER/$REPO.git"
git push -u origin main --force
echo "  ✅ アップロード完了"

echo "▶ GitHub Pages を有効化中..."
PAGES=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API/repos/$GH_USER/$REPO/pages" \
  -H "$AUTH" -H "$ACCEPT" \
  -d '{"source":{"branch":"main","path":"/"}}')
if [ "$PAGES" = "201" ] || [ "$PAGES" = "409" ]; then
  echo "  ✅ 有効化しました"
else
  echo "  ⚠ Pagesレスポンス: HTTP $PAGES（既に有効な場合あり）"
fi

echo
echo "=============================================="
echo " 🎉 公開完了！（反映まで1〜2分）"
echo
echo "   常設URL:"
echo "   https://$GH_USER.github.io/$REPO/"
echo
echo " このURLを社内で共有してください。"
echo " 更新したいときは index.html を差し替えて、もう一度 bash deploy.sh"
echo "=============================================="
