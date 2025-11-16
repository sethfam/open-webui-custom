# How to Make Agents Appear in Open WebUI

The agent JSON files we created are **export/import formats** - they need to be imported into the Open WebUI database to appear in the UI.

## 🎯 Quick Start

### Method 1: Direct Database Import (Recommended)
```bash
# Run the Python import script
python3 import_agents.py
```

### Method 2: API Import (When Open WebUI is Running)
```bash
# Get your admin API token from Open WebUI settings first
export ADMIN_TOKEN="your_admin_token_here"
./import_agents_api.sh
```

### Method 3: Manual Import via UI
1. Go to Open WebUI → Settings → Models
2. Click "Import Models"
3. Select your agent JSON files
4. Click "Import"

## 📋 Detailed Instructions

### Prerequisites
- Open WebUI must be running
- You need admin access
- Python 3.x installed (for Method 1)

### Method 1: Direct Database Import

This method directly imports agents into the database:

```bash
# Navigate to Open WebUI directory
cd /path/to/open-webui

# Run the import script
python3 import_agents.py
```

**What it does:**
- Loads all agent JSON files from `agents/` directory
- Imports them directly into the Open WebUI database
- Updates existing agents or creates new ones
- Shows detailed progress and results

### Method 2: API Import

This method uses the Open WebUI API:

```bash
# 1. Get your admin API token
#    Go to Open WebUI → Settings → API Keys → Generate Token

# 2. Set the token
export ADMIN_TOKEN="your_token_here"

# 3. Run the import script
./import_agents_api.sh
```

**What it does:**
- Uses the Open WebUI REST API
- Imports agents via HTTP requests
- Works when Open WebUI is running
- Provides detailed success/failure feedback

### Method 3: Manual UI Import

1. **Open Open WebUI** in your browser
2. **Go to Settings** → **Models**
3. **Click "Import Models"**
4. **Select your agent files** from the `agents/` directory:
   - `coordinator-agent-config.json`
   - `financial-advisor-agent-config.json`
   - `medical-diagnosis-agent-config.json`
5. **Click "Import"**

## 🔍 Verifying Import Success

After importing, verify your agents appear:

1. **Refresh your browser** (important!)
2. **Go to the chat interface**
3. **Click the model selector** (dropdown)
4. **Look for your agents:**
   - Project Coordinator
   - Financial Advisor
   - Medical Diagnosis Specialist

## 🛠️ Troubleshooting

### Agents Don't Appear
- **Refresh browser**: Hard refresh (Ctrl+F5 or Cmd+Shift+R)
- **Check admin access**: Make sure you have admin privileges
- **Verify import**: Check the import script output for errors
- **Check database**: Agents might be imported but not visible due to permissions

### Import Errors
- **File format**: Ensure JSON files are valid
- **Permissions**: Make sure you have admin access
- **Database**: Check if Open WebUI database is accessible
- **API token**: Verify admin token is correct (Method 2)

### Permission Issues
- **Admin required**: Only admins can import models
- **User permissions**: Check user role in Open WebUI
- **Access control**: Verify agent access control settings

## 📁 File Structure

Your agents directory should look like this:
```
agents/
├── coordinator-agent-config.json
├── financial-advisor-agent-config.json
├── medical-diagnosis-agent-config.json
├── coordinator-agent-config.json.backup
├── financial-advisor-agent-config.json.backup
├── medical-diagnosis-agent-config.json.backup
├── coordinator-agent-config-20251012-214148.json
├── financial-advisor-agent-config-20251012-214148.json
├── medical-diagnosis-agent-config-20251012-214522.json
└── README.md
```

## 🔄 Updating Agents

To update an existing agent:

1. **Edit the JSON file** in the `agents/` directory
2. **Run the import script again** - it will update existing agents
3. **Refresh your browser** to see changes

## 🗑️ Removing Agents

To remove an agent from the UI:

1. **Go to Settings** → **Models**
2. **Find the agent** in the list
3. **Click the delete button** (trash icon)
4. **Confirm deletion**

## 📊 Agent Status

After successful import, your agents will have:

- ✅ **Visible in model selector**
- ✅ **Accessible to users** (based on permissions)
- ✅ **Full functionality** (vision, file upload, etc.)
- ✅ **Custom prompts** and suggestions
- ✅ **Proper metadata** and descriptions

## 🎉 Success Indicators

You'll know the import worked when:

- Agents appear in the model dropdown
- You can select them for chat
- They show the correct names and descriptions
- Their capabilities work as expected
- Custom prompts appear in suggestions

## 📞 Support

If you encounter issues:

1. **Check the logs** from the import script
2. **Verify file formats** are valid JSON
3. **Ensure admin access** to Open WebUI
4. **Try different import methods** if one fails
5. **Check Open WebUI documentation** for additional help
