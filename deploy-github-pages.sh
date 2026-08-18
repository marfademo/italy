#!/bin/bash
# 罗马+佛罗伦萨 6 天行程图 · GitHub Pages 一键部署
set -e

GITHUB_USER="YOUR_USERNAME"
REPO_NAME="rome-florence-trip"
SOURCE_FILE="/Users/11154023/BlueCode/rome-florence-6days-share.html"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
step(){ echo -e "\n${BLUE}=== $1 ===${NC}"; }
ok(){   echo -e "${GREEN}✓${NC} $1"; }
warn(){ echo -e "${YELLOW}⚠${NC} $1"; }
fail(){ echo -e "${RED}✗${NC} $1"; exit 1; }

step "0/8 检查环境"
[ -z "$GITHUB_USER" ] || [ "$GITHUB_USER" = "YOUR_USERNAME" ] && \
  fail "请先编辑本脚本，把 GITHUB_USER 改成你的 GitHub 用户名"
[ ! -f "$SOURCE_FILE" ] && fail "找不到源文件 $SOURCE_FILE"
command -v git >/dev/null || fail "未安装 git"
command -v ssh >/dev/null || fail "未安装 ssh"
ok "环境就绪 · 用户: $GITHUB_USER"

step "1/8 SSH key 配置"
SSH_KEY="$HOME/.ssh/id_ed25519"
[ ! -f "$SSH_KEY" ] && SSH_KEY="$HOME/.ssh/id_rsa"
if [ ! -f "$SSH_KEY" ]; then
  warn "未发现 SSH key，开始生成 ..."
  ssh-keygen -t ed25519 -C "$GITHUB_USER@github" -f "$HOME/.ssh/id_ed25519" -N ""
  SSH_KEY="$HOME/.ssh/id_ed25519"
  ok "已生成 SSH key: $SSH_KEY"
fi
SSH_TEST=$(ssh -T -o StrictHostKeyChecking=accept-new -o ConnectTimeout=10 git@github.com 2>&1 || true)
if echo "$SSH_TEST" | grep -q "successfully authenticated"; then
  ok "SSH 已配通 GitHub"; SSH_READY=true
else
  SSH_READY=false
fi
PUB_KEY_FILE="${SSH_KEY}.pub"
if [ -f "$PUB_KEY_FILE" ]; then
  echo -e "${YELLOW}你的 SSH 公钥：${NC}"
  echo "----------------------------------------------------"
  cat "$PUB_KEY_FILE"
  echo "----------------------------------------------------"
fi
if [ "$SSH_READY" = false ]; then
  echo -e "${YELLOW}SSH 还未配置。请：${NC}"
  echo "  1. 复制框里整行公钥"
  echo "  2. 访问 https://github.com/settings/keys/new"
  echo "  3. Title: MacBook"
  echo "  4. Key 类型: Authentication Key"
  echo "  5. 粘贴公钥 -> Add SSH key"
  echo "  6. 重新运行本脚本"
  exit 0
fi

step "2/8 创建仓库"
EXISTS=$(git ls-remote "git@github.com:$GITHUB_USER/$REPO_NAME.git" 2>&1 | head -1 || echo "")
if [ -n "$EXISTS" ]; then
  ok "仓库已存在"
elif command -v gh >/dev/null 2>&1; then
  gh repo create "$REPO_NAME" --public --description "rome-florence 6 days" 2>&1 || warn "gh 创建失败"
else
  echo -e "${YELLOW}请手动创建仓库：${NC}"
  echo "  1. 访问 https://github.com/new"
  echo "  2. Repository name: $REPO_NAME"
  echo "  3. Public · 不要勾 Add README"
  echo "  4. Create repository"
  read -p "创建完成后按回车继续 ..."
fi

step "3/8 准备文件"
WORKDIR=$(mktemp -d)
cd "$WORKDIR"
git init -q
git checkout -b gh-pages 2>/dev/null || git switch gh-pages
cp "$SOURCE_FILE" index.html
cat > README.md << EOF
# 罗马 + 佛罗伦萨 6 天 City Walk 路线图
🇮🇹 罗马 3 天 + 佛罗伦萨 3 天
🔗 https://$GITHUB_USER.github.io/$REPO_NAME/
EOF
touch .nojekyll
ok "已准备 index.html + README + .nojekyll"

step "4/8 提交"
git config user.name "$GITHUB_USER"
git config user.email "${GITHUB_USER}@users.noreply.github.com"
git add .
git commit -q -m "deploy: rome-florence 6 days"
ok "已提交"

step "5/8 推送到 GitHub"
REMOTE_URL="git@github.com:$GITHUB_USER/$REPO_NAME.git"
git remote add origin "$REMOTE_URL" 2>/dev/null || git remote set-url origin "$REMOTE_URL"
git push -u origin gh-pages -f
ok "已推送"

step "6/8 GitHub Pages 启用提示"
PAGES_URL="https://$GITHUB_USER.github.io/$REPO_NAME/"
echo -e "${YELLOW}请访问 https://github.com/$GITHUB_USER/$REPO_NAME/settings/pages 设置：${NC}"
echo "  Source: Deploy from a branch"
echo "  Branch: gh-pages / (root) -> Save"

step "7/8 等待生效"
echo "⏳ 等待 45 秒 ..."
sleep 45
HTTP=$(curl -s -o /dev/null -w "%{http_code}" "$PAGES_URL" || echo "000")
[ "$HTTP" = "200" ] && ok "网站可访问: $PAGES_URL" || warn "HTTP $HTTP - 继续等待"

step "8/8 完成 🎉"
cat << EOF

🌐 访问地址：
   $PAGES_URL

📱 二维码：
   https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=$PAGES_URL

💬 微信群分享文案：
---
🇮🇹 罗马+佛罗伦萨 6 天 City Walk 路线图
⛪ 梵蒂冈深度 → 🏛️ 古迹串游 → 🚄 佛罗伦萨 → 🌅 阿诺河日落 → 🗿 美术馆三连击

✨ 真实 OSM 地图 · 6 天 Tab 一键切换
📍 每天单独景点详情 · 步行/打车分色标注

👉 直接打开：$PAGES_URL
---

📁 临时目录: $WORKDIR
EOF
