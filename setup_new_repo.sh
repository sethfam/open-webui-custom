#!/bin/bash

# Script to set up a new GitHub repository for this forked/isolated version
# Usage: ./setup_new_repo.sh <your-github-username> <new-repo-name>

set -e

if [ $# -lt 2 ]; then
    echo "Usage: $0 <your-github-username> <new-repo-name>"
    echo "Example: $0 sethfamilian open-webui-custom"
    exit 1
fi

GITHUB_USERNAME=$1
NEW_REPO_NAME=$2
NEW_REPO_URL="https://github.com/${GITHUB_USERNAME}/${NEW_REPO_NAME}.git"

echo "🚀 Setting up new GitHub repository: ${NEW_REPO_NAME}"
echo "=============================================="

# Check if repo already exists locally as a remote
if git remote | grep -q "^new-origin$"; then
    echo "⚠️  Remote 'new-origin' already exists. Removing it..."
    git remote remove new-origin
fi

# Add new remote
echo "📡 Adding new remote: ${NEW_REPO_URL}"
git remote add new-origin "${NEW_REPO_URL}"

# Rename origin to upstream (to keep reference to original)
if git remote | grep -q "^upstream$"; then
    echo "⚠️  Remote 'upstream' already exists. Skipping rename..."
else
    echo "🔄 Renaming 'origin' to 'upstream' to preserve reference to original repo"
    git remote rename origin upstream
fi

# Set new-origin as origin
echo "🔄 Setting new repository as 'origin'"
git remote rename new-origin origin

echo ""
echo "✅ Repository setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Create the repository on GitHub:"
echo "   - Go to https://github.com/new"
echo "   - Repository name: ${NEW_REPO_NAME}"
echo "   - Description: Custom fork of Open WebUI with agent configurations"
echo "   - Choose Public or Private"
echo "   - DO NOT initialize with README, .gitignore, or license"
echo "   - Click 'Create repository'"
echo ""
echo "2. Push your changes:"
echo "   git push -u origin main"
echo ""
echo "3. (Optional) To pull updates from upstream:"
echo "   git fetch upstream"
echo "   git merge upstream/main"
echo ""

