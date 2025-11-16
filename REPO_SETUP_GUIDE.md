# Repository Setup Guide

This guide will help you create a new GitHub repository for your customized Open WebUI fork.

## 🚀 Quick Setup

### Option 1: Automated Setup (with GitHub Token)

If you have a GitHub Personal Access Token:

```bash
./create_and_push_repo.sh <your-github-username> <new-repo-name> <github-token>
```

Example:
```bash
./create_and_push_repo.sh sethfamilian open-webui-custom ghp_your_token_here
```

**To get a GitHub token:**
1. Go to https://github.com/settings/tokens
2. Click "Generate new token" → "Generate new token (classic)"
3. Give it a name (e.g., "Open WebUI Repo Creation")
4. Select scope: `repo` (full control of private repositories)
5. Click "Generate token"
6. Copy the token (you won't see it again!)

### Option 2: Manual Setup

1. **Create the repository on GitHub:**
   - Go to https://github.com/new
   - Repository name: `open-webui-custom` (or your preferred name)
   - Description: "Custom fork of Open WebUI with agent configurations"
   - Choose Public or Private
   - **DO NOT** initialize with README, .gitignore, or license
   - Click "Create repository"

2. **Run the setup script:**
   ```bash
   ./create_and_push_repo.sh <your-github-username> <new-repo-name>
   ```
   
   Example:
   ```bash
   ./create_and_push_repo.sh sethfamilian open-webui-custom
   ```

3. **Follow the prompts** - the script will:
   - Rename the original `origin` to `upstream` (to preserve reference to open-webui/open-webui)
   - Add your new repository as `origin`
   - Push all your commits to the new repository

## 📋 What Gets Pushed

All your custom changes will be pushed, including:
- ✅ Custom agent configurations (4 agents)
- ✅ Agent import scripts and documentation
- ✅ Updated docker-compose.yaml (port 3002)
- ✅ Distribution and packaging scripts
- ✅ All documentation files

## 🔄 Repository Structure After Setup

After setup, your remotes will be:
- `origin` → Your new repository (e.g., `sethfamilian/open-webui-custom`)
- `upstream` → Original Open WebUI repository (`open-webui/open-webui`)

## 📝 Future Updates

### To pull updates from upstream Open WebUI:
```bash
git fetch upstream
git merge upstream/main
# Resolve any conflicts if needed
git push origin main
```

### To push your changes:
```bash
git add .
git commit -m "Your commit message"
git push origin main
```

## ✅ Verification

After pushing, verify your repository:
1. Visit: `https://github.com/<your-username>/<repo-name>`
2. Check that all files are present
3. Verify the commit history shows your custom commits

## 🆘 Troubleshooting

### "Repository already exists" error
- The repository name is already taken
- Choose a different name or delete the existing repository

### "Permission denied" error
- Check your GitHub token has `repo` scope
- Verify your username is correct
- Make sure you have write access to the repository

### "Remote origin already exists" error
- The script will handle this automatically
- If issues persist, run: `git remote remove origin` first

## 📚 Additional Resources

- [GitHub Documentation](https://docs.github.com/en/get-started)
- [Git Remote Documentation](https://git-scm.com/book/en/v2/Git-Basics-Working-with-Remotes)

