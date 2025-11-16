#!/bin/bash

# Script to create a new GitHub repository and push this forked code
# Usage: ./create_and_push_repo.sh <your-github-username> <new-repo-name> [github-token]

set -e

if [ $# -lt 2 ]; then
    echo "Usage: $0 <your-github-username> <new-repo-name> [github-token]"
    echo "Example: $0 sethfamilian open-webui-custom"
    echo ""
    echo "If you provide a GitHub token, the script will create the repo automatically."
    echo "Otherwise, you'll need to create it manually on GitHub first."
    exit 1
fi

GITHUB_USERNAME=$1
NEW_REPO_NAME=$2
GITHUB_TOKEN=${3:-""}
NEW_REPO_URL="https://github.com/${GITHUB_USERNAME}/${NEW_REPO_NAME}.git"

echo "🚀 Creating new GitHub repository: ${NEW_REPO_NAME}"
echo "=============================================="
echo ""

# Step 1: Create repository on GitHub (if token provided)
if [ -n "$GITHUB_TOKEN" ]; then
    echo "📦 Creating repository on GitHub..."
    RESPONSE=$(curl -s -w "\nHTTP_CODE:%{http_code}" -X POST \
        -H "Authorization: token ${GITHUB_TOKEN}" \
        -H "Accept: application/vnd.github.v3+json" \
        https://api.github.com/user/repos \
        -d "{\"name\":\"${NEW_REPO_NAME}\",\"description\":\"Custom fork of Open WebUI with agent configurations\",\"private\":false}")
    
    HTTP_CODE=$(echo "$RESPONSE" | grep "HTTP_CODE:" | cut -d: -f2)
    RESPONSE_BODY=$(echo "$RESPONSE" | sed '/HTTP_CODE:/d')
    
    if [ "$HTTP_CODE" = "201" ]; then
        echo "✅ Repository created successfully on GitHub!"
    elif [ "$HTTP_CODE" = "422" ]; then
        echo "⚠️  Repository might already exist. Continuing..."
    else
        echo "❌ Failed to create repository (HTTP $HTTP_CODE)"
        echo "Response: $RESPONSE_BODY"
        echo ""
        echo "Please create the repository manually at: https://github.com/new"
        echo "Repository name: ${NEW_REPO_NAME}"
        echo "Then run this script again without the token parameter."
        exit 1
    fi
else
    echo "📋 Please create the repository on GitHub first:"
    echo "   1. Go to: https://github.com/new"
    echo "   2. Repository name: ${NEW_REPO_NAME}"
    echo "   3. Description: Custom fork of Open WebUI with agent configurations"
    echo "   4. Choose Public or Private"
    echo "   5. DO NOT initialize with README, .gitignore, or license"
    echo "   6. Click 'Create repository'"
    echo ""
    read -p "Press Enter once you've created the repository..."
fi

# Step 2: Rename origin to upstream (if not already done)
if git remote | grep -q "^upstream$"; then
    echo "✅ 'upstream' remote already exists"
else
    if git remote | grep -q "^origin$"; then
        echo "🔄 Renaming 'origin' to 'upstream' to preserve reference to original repo"
        git remote rename origin upstream
    else
        echo "⚠️  No 'origin' remote found. Adding upstream..."
        git remote add upstream https://github.com/open-webui/open-webui.git
    fi
fi

# Step 3: Add new repository as origin
if git remote | grep -q "^origin$"; then
    echo "⚠️  'origin' remote already exists. Removing it..."
    git remote remove origin
fi

echo "📡 Adding new repository as 'origin': ${NEW_REPO_URL}"
git remote add origin "${NEW_REPO_URL}"

# Step 4: Verify remotes
echo ""
echo "📋 Current remotes:"
git remote -v
echo ""

# Step 5: Push to new repository
echo "🚀 Pushing to new repository..."
echo "   Branch: main"
echo "   Repository: ${NEW_REPO_URL}"
echo ""

# Check if we're on main branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "⚠️  Current branch is '${CURRENT_BRANCH}', not 'main'"
    read -p "Push to '${CURRENT_BRANCH}' branch? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 1
    fi
    BRANCH_NAME="$CURRENT_BRANCH"
else
    BRANCH_NAME="main"
fi

git push -u origin "${BRANCH_NAME}"

echo ""
echo "✅ Successfully pushed to new repository!"
echo ""
echo "🌐 Your repository is now available at:"
echo "   https://github.com/${GITHUB_USERNAME}/${NEW_REPO_NAME}"
echo ""
echo "📝 Next steps:"
echo "   - View your repository: https://github.com/${GITHUB_USERNAME}/${NEW_REPO_NAME}"
echo "   - To pull updates from upstream: git fetch upstream && git merge upstream/main"
echo "   - To push future changes: git push origin ${BRANCH_NAME}"
echo ""

