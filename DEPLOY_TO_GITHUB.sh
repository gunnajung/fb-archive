#!/bin/bash
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/homebrew/bin:$PATH"
TOKEN="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"
USER="gunnajung"
REPO="fb-archive"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Gunna Jung Archive → GitHub Pages"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo ""
echo "1️⃣  GitHub Repository 생성 중..."
RESULT=$(curl -s -X POST \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -H "Content-Type: application/json" \
  https://api.github.com/user/repos \
  -d "{\"name\":\"$REPO\",\"description\":\"Gunna Jung Facebook Digital Archive 2009-2026\",\"private\":false,\"auto_init\":false}")

if echo "$RESULT" | grep -q '"full_name"'; then
  echo "   ✅ Repository 생성: github.com/$USER/$REPO"
elif echo "$RESULT" | grep -q 'already exists'; then
  echo "   ℹ️  Repository 이미 존재함 — 계속 진행합니다"
else
  echo "   ⚠️  $RESULT"
fi

echo ""
echo "2️⃣  Git 초기화 중..."
rm -rf .git
git init -b main
git config user.email "gunnajung@gmail.com"
git config user.name "Gunna Jung"

echo ""
echo "3️⃣  파일 추가 중 (4000+ 파일, 약 1~2분 소요)..."
git add -A
git commit -m "Gunna Jung Facebook Archive 2009-2026" --quiet

echo ""
echo "4️⃣  GitHub에 업로드 중 (276MB, 약 2~5분 소요)..."
git remote add origin "https://$USER:$TOKEN@github.com/$USER/$REPO.git"
git push -u origin main

echo ""
echo "5️⃣  GitHub Pages 활성화 중..."
curl -s -X POST \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -H "Content-Type: application/json" \
  "https://api.github.com/repos/$USER/$REPO/pages" \
  -d '{"source":{"branch":"main","path":"/"}}' > /dev/null

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅ 배포 완료!"
echo ""
echo "  🌐 아카이브 URL (3~5분 후 활성화):"
echo "  👉 https://$USER.github.io/$REPO/"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
