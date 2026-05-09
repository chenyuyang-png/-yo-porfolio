#!/bin/bash
# ============================================================
# Portfolio Dashboard → GitHub 一鍵部署腳本
# ============================================================
# 執行方式：
#   1. 確保已安裝 git（macOS 內建，或 brew install git）
#   2. 推薦安裝 GitHub CLI：brew install gh
#   3. 在此資料夾打開 Terminal
#   4. 執行：bash setup-github.sh
# ============================================================

set -e

# 顏色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  📊 Portfolio Dashboard → GitHub 部署${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# 切換到腳本所在目錄
cd "$(dirname "$0")"
echo -e "${GREEN}📁 工作目錄：${NC}$(pwd)"
echo ""

# ----- 1. 檢查 git -----
if ! command -v git &> /dev/null; then
  echo -e "${RED}❌ 沒有 git，請先安裝：brew install git${NC}"
  exit 1
fi
echo -e "${GREEN}✅ git 已安裝（$(git --version)）${NC}"

# ----- 2. 檢查並設定 git user -----
if ! git config --global user.email > /dev/null 2>&1; then
  read -p "請輸入您的 git email（會被記在 commit）: " EMAIL
  git config --global user.email "$EMAIL"
fi
if ! git config --global user.name > /dev/null 2>&1; then
  read -p "請輸入您的 git 名字: " NAME
  git config --global user.name "$NAME"
fi

# ----- 3. 初始化 git repo -----
# 檢查 .git 是否存在且有 commit，如果是壞的就清掉重建
NEED_INIT=false
if [ ! -d ".git" ]; then
  NEED_INIT=true
elif ! git rev-parse HEAD &> /dev/null; then
  echo -e "${YELLOW}⚠️  發現損壞或空白的 .git 資料夾，重新初始化...${NC}"
  rm -rf .git
  NEED_INIT=true
fi

if [ "$NEED_INIT" = "true" ]; then
  echo ""
  echo -e "${YELLOW}🔧 初始化 git repo...${NC}"
  git init -b main
  git add .
  git commit -m "Initial commit: Portfolio Risk Dashboard v2 (interactive)"
  echo -e "${GREEN}✅ 本地 repo 初始化完成${NC}"
else
  echo -e "${YELLOW}ℹ️  .git 已存在且有效，檢查未 commit 變更...${NC}"
  if ! git diff-index --quiet HEAD --; then
    git add .
    git commit -m "Update dashboard $(date +%Y-%m-%d)"
    echo -e "${GREEN}✅ 已 commit 最新變更${NC}"
  fi
fi

# ----- 4. 詢問 repo 名稱 -----
echo ""
DEFAULT_REPO_NAME="portfolio-dashboard"
read -p "GitHub repo 名稱 [預設: $DEFAULT_REPO_NAME]: " REPO_NAME
REPO_NAME=${REPO_NAME:-$DEFAULT_REPO_NAME}

# ----- 5. 詢問 public/private -----
echo ""
echo -e "${YELLOW}⚠️  注意：repo 內含您的持股清單，建議設為 private${NC}"
read -p "Public 或 Private? [private]: " VISIBILITY
VISIBILITY=${VISIBILITY:-private}

# ----- 6. 用 GitHub CLI 建立 repo -----
if command -v gh &> /dev/null; then
  # GitHub CLI 已安裝
  if ! gh auth status &> /dev/null; then
    echo ""
    echo -e "${YELLOW}🔐 GitHub CLI 尚未登入，啟動登入流程...${NC}"
    gh auth login
  fi

  echo ""
  echo -e "${YELLOW}🚀 建立 GitHub repo: $REPO_NAME ($VISIBILITY)${NC}"

  if [ "$VISIBILITY" = "public" ]; then
    gh repo create "$REPO_NAME" --public --source=. --push --description "個人投資組合風控儀表板"
  else
    gh repo create "$REPO_NAME" --private --source=. --push --description "個人投資組合風控儀表板"
  fi

  REPO_URL=$(gh repo view --json url -q .url)
  echo ""
  echo -e "${GREEN}✅ Repo 已建立並 push 完成${NC}"
  echo -e "${GREEN}   👉 ${REPO_URL}${NC}"

  # 詢問是否啟用 GitHub Pages
  echo ""
  read -p "是否啟用 GitHub Pages 讓您能透過 URL 存取儀表板？ [Y/n]: " ENABLE_PAGES
  ENABLE_PAGES=${ENABLE_PAGES:-Y}

  if [[ "$ENABLE_PAGES" =~ ^[Yy]$ ]]; then
    if [ "$VISIBILITY" = "private" ]; then
      echo -e "${YELLOW}⚠️  注意：private repo 啟用 GitHub Pages 需要 GitHub Pro 帳號（$4/月）${NC}"
    fi
    gh api -X POST "repos/{owner}/${REPO_NAME}/pages" -f "source[branch]=main" -f "source[path]=/" 2>/dev/null && \
      echo -e "${GREEN}✅ GitHub Pages 已啟用${NC}" && \
      echo -e "${GREEN}   等 1–2 分鐘後可訪問: https://$(gh api user -q .login).github.io/${REPO_NAME}/${NC}" || \
      echo -e "${YELLOW}⚠️  自動啟用失敗，請到 Settings → Pages 手動啟用${NC}"
  fi

else
  # 沒有 GitHub CLI，提供手動指令
  echo ""
  echo -e "${YELLOW}⚠️  沒有 GitHub CLI（gh），請手動操作：${NC}"
  echo ""
  echo -e "${BLUE}步驟 1：在 GitHub 網站建立空 repo${NC}"
  echo "    1. 打開 https://github.com/new"
  echo "    2. Repo 名稱：$REPO_NAME"
  echo "    3. 選擇 Private（推薦）"
  echo "    4. 不要勾選 Add README / .gitignore（我們已經有了）"
  echo "    5. 點 Create repository"
  echo ""
  echo -e "${BLUE}步驟 2：複製建立後的 repo URL，然後執行${NC}"
  echo ""
  echo "    git remote add origin https://github.com/<your-username>/$REPO_NAME.git"
  echo "    git branch -M main"
  echo "    git push -u origin main"
  echo ""
  echo -e "${YELLOW}💡 建議安裝 GitHub CLI 簡化流程：brew install gh${NC}"
fi

echo ""
echo -e "${BLUE}================================================${NC}"
echo -e "${GREEN}🎉 完成！${NC}"
echo -e "${BLUE}================================================${NC}"
