#!/bin/bash
# =========================================================
# 罗马 + 佛罗伦萨 6 天行程图 · GitHub Pages 部署脚本
#
# 步骤：
#   1) 在 GitHub 创建新仓库（空，公开）
#      建议仓库名：rome-florence-trip
#      访问 https://github.com/new 创建
#   2) 替换下面的 REPO_URL 为你的仓库 URL
#   3) 在终端运行：bash deploy-ghpages.sh
# =========================================================

set -e

# ===== 配置 =====
REPO_URL="https://github.com/marfademo/-rome-florence-trip.git"  # ← 改成你的仓库 URL
BRANCH="gh-pages"
INDEX_FILE="rome-florence-6days-share.html"  # 主入口文件名

# ===== 1. 准备临时目录 =====
WORKDIR=$(mktemp -d)
echo "📁 临时工作目录: $WORKDIR"

# ===== 2. 拷贝只读版 HTML =====
cp "/Users/11154023/BlueCode/$INDEX_FILE" "$WORKDIR/index.html"
echo "✅ 已复制 $INDEX_FILE → index.html"

# ===== 3. 初始化 git 仓库 =====
cd "$WORKDIR"
git init -q
git checkout -b "$BRANCH" 2>/dev/null || git switch "$BRANCH"
git config user.name "Your Name"
git config user.email "your@email.com"

# ===== 4. 添加 README + .nojekyll =====
cat > README.md << 'EOF'
# 罗马 + 佛罗伦萨 6 天 City Walk 路线图

🇮🇹 罗马 3 天 + 佛罗伦萨 3 天 · 真实地图 + Tab 切换 + 编辑支持

🔗 在线访问：https://YOUR_USERNAME.github.io/rome-florence-trip/

## 关于

个人定制版意大利双城 6 天行程图，含：
- 真实 OSM 地图（罗马 + 佛罗伦萨）
- 6 天 Tab 切换
- 行程条目三类型化（饭点 / 交通 / 活动）
- 头部 icon 弹窗切换 + 整条拖拽

## 来源

基于 OpenStreetMap 数据 + 手工标注路线节点
EOF

touch .nojekyll  # 关闭 GitHub Pages 的 Jekyll 处理
echo "✅ 已添加 README + .nojekyll"

# ===== 5. 提交 =====
git add .
git commit -q -m "deploy: 罗马+佛罗伦萨 6 天行程图"
echo "✅ 已提交"

# ===== 6. 推送到 GitHub =====
echo "📡 推送到 GitHub ..."
git remote add origin "$REPO_URL" 2>/dev/null || git remote set-url origin "$REPO_URL"
git push -u origin "$BRANCH" -f

# ===== 7. 完成提示 =====
GH_URL=$(echo "$REPO_URL" | sed -E 's#git@github.com:#https://github.com/#; s#\.git$##')
PAGES_URL="${GH_URL/https:\/\/github.com/https:\/\/$(echo "$REPO_URL" | sed -E 's#.*:([^/]+)/.*#\1#').github.io}/tree/$BRANCH"

cat << EOF

🎉 部署完成！

📋 接下来：
   1. 访问 GitHub 仓库 Settings → Pages
   2. Branch 选择 'gh-pages' / Root
   3. 等待 1-2 分钟
   4. 访问：https://YOUR_USERNAME.github.io/rome-florence-trip/

💬 微信群分享文案（复制即用）：
---
🇮🇹 罗马+佛罗伦萨 6 天 City Walk 路线图
真实 OSM 地图 + 每天 Tab 切换 + 景点详情
👇 直接打开
https://YOUR_USERNAME.github.io/rome-florence-trip/
EOF

echo "📁 临时目录: $WORKDIR（可手动清理）"