#!/usr/bin/env bash
#
# deploy.sh – BNB Edge Node Production Deployment to GitHub Pages
#
# Usage: ./deploy.sh [--dry-run]
#   --dry-run   Preview changes without pushing to GitHub
#
# Make sure Git is installed and you're authenticated with GitHub.
# Set your custom domain in the CUSTOM_DOMAIN variable below.

set -euo pipefail
IFS=$'\n\t'

# -------------------------------------------------------------------
# 1. CONFIGURATION – EDIT THESE VARIABLES
# -------------------------------------------------------------------
SITE_DIR="."                      # where files will be written (current dir)
REPO_URL="git@github.com:dev-loka/bnb-edge-node.git" # your GitHub repo
BRANCH="main"                     # deployment branch (use "main" for user sites)
CUSTOM_DOMAIN=""                  # set to your domain, or leave empty for default github.io
COMMIT_MSG="Deploy BNB Edge Node – $(date +'%Y-%m-%d %H:%M')"

# Color codes for pretty output
COLOR_RESET='\033[0m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[1;33m'
COLOR_RED='\033[0;31m'
COLOR_CYAN='\033[0;36m'

# -------------------------------------------------------------------
# 2. SAFETY CHECKS
# -------------------------------------------------------------------
if [ "$SITE_DIR" = "/" ]; then
    echo -e "${COLOR_RED}❌ Refusing to operate on root directory. Aborting.${COLOR_RESET}"
    exit 1
fi

# -------------------------------------------------------------------
# 3. PARSE COMMAND LINE ARGUMENTS
# -------------------------------------------------------------------
DRY_RUN=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            echo -e "${COLOR_RED}Unknown option: $1${COLOR_RESET}"
            echo "Usage: $0 [--dry-run]"
            exit 1
            ;;
    esac
done

cd "$SITE_DIR"

# -------------------------------------------------------------------
# 4. SITE PREPARATION
# -------------------------------------------------------------------
echo -e "${COLOR_CYAN}📁 Preparing files in $SITE_DIR ...${COLOR_RESET}"

# Optional: create CNAME for custom domain
if [ -n "$CUSTOM_DOMAIN" ]; then
  echo "$CUSTOM_DOMAIN" > CNAME
  echo -e "   ${COLOR_GREEN}✅ CNAME ($CUSTOM_DOMAIN)${COLOR_RESET}"
fi

# Prevent Jekyll processing
touch .nojekyll
echo -e "   ${COLOR_GREEN}✅ .nojekyll${COLOR_RESET}"

# -------------------------------------------------------------------
# 5. VALIDATE CRITICAL FILES
# -------------------------------------------------------------------
if [ ! -f index.html ]; then
    echo -e "${COLOR_RED}❌ ERROR: index.html is missing! Aborting.${COLOR_RESET}"
    exit 1
fi

if ! grep -q "<title>" index.html; then
    echo -e "${COLOR_RED}❌ ERROR: index.html appears to be missing a <title> tag. Aborting.${COLOR_RESET}"
    exit 1
fi
echo -e "   ${COLOR_GREEN}✅ index.html validation passed${COLOR_RESET}"

# -------------------------------------------------------------------
# 6. GIT SETUP AND PUSH
# -------------------------------------------------------------------
echo ""
echo -e "${COLOR_CYAN}🔧 Setting up Git repository...${COLOR_RESET}"

if [ ! -d .git ]; then
    git init
    echo -e "   ${COLOR_GREEN}✅ Git repository initialized${COLOR_RESET}"
else
    echo -e "   ${COLOR_YELLOW}⏩ Git repository already exists${COLOR_RESET}"
fi

# Set remote origin if missing
if ! git remote get-url origin >/dev/null 2>&1; then
    if [ -z "$REPO_URL" ]; then
        echo ""
        echo -e "${COLOR_YELLOW}❌ No remote 'origin' configured.${COLOR_RESET}"
        echo "Please enter your GitHub repository URL (e.g., git@github.com:user/repo.git):"
        read -r REPO_URL
    fi
    git remote add origin "$REPO_URL"
    echo -e "   ${COLOR_GREEN}✅ Remote origin added: $REPO_URL${COLOR_RESET}"
else
    echo -e "   ${COLOR_YELLOW}⏩ Remote origin already exists${COLOR_RESET}"
fi

# Commit changes
git add .
if git diff --cached --quiet; then
    echo -e "   ${COLOR_YELLOW}⏩ No changes to commit${COLOR_RESET}"
else
    git commit -m "$COMMIT_MSG"
    echo -e "   ${COLOR_GREEN}✅ Committed: $COMMIT_MSG${COLOR_RESET}"
fi

# Push (or dry-run)
if [ "$DRY_RUN" = false ]; then
    echo -e "${COLOR_CYAN}🚀 Pushing to origin/$BRANCH ...${COLOR_RESET}"
    # Make sure we're pushing to the right branch (e.g. main)
    # The Action will take over the deployment automatically.
    git branch -M "$BRANCH"
    git push -u origin "$BRANCH"
else
    echo -e "${COLOR_YELLOW}🧪 Dry run – push skipped.${COLOR_RESET}"
fi

# -------------------------------------------------------------------
# 7. DISPLAY LIVE URL
# -------------------------------------------------------------------
REPO_PATH=$(git remote get-url origin | sed -e 's/.*github.com[:/]//' -e 's/\.git$//')
USERNAME=$(echo "$REPO_PATH" | cut -d'/' -f1)
REPO_NAME=$(echo "$REPO_PATH" | cut -d'/' -f2)

echo ""
echo -e "${COLOR_GREEN}🎉 Local build complete! GitHub Actions will now deploy it.${COLOR_RESET}"

if [ -n "$CUSTOM_DOMAIN" ]; then
    echo -e "${COLOR_CYAN}🌍 It will shortly be live at: https://$CUSTOM_DOMAIN${COLOR_RESET}"
else
    if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
        echo -e "${COLOR_CYAN}🌍 It will shortly be live at: https://$USERNAME.github.io/${COLOR_RESET}"
    else
        echo -e "${COLOR_CYAN}🌍 It will shortly be live at: https://$USERNAME.github.io/$REPO_NAME/${COLOR_RESET}"
    fi
fi

echo ""
echo -e "${COLOR_YELLOW}🔁 Next steps:${COLOR_RESET}"
echo "   - Monitor the GitHub Actions tab for deployment status."
echo "   - If using a custom domain, ensure it is configured in repo settings."
if [ "$DRY_RUN" = true ]; then
    echo ""
    echo -e "${COLOR_YELLOW}🧪 This was a dry run. To actually deploy, run without --dry-run.${COLOR_RESET}"
fi
