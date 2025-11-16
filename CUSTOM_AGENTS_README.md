# Custom Open WebUI Agents

This repository is a customized fork of [Open WebUI](https://github.com/open-webui/open-webui) with additional AI agent configurations and enhancements.

## 🎯 Custom Agents

This repository includes the following custom AI agents:

### 1. **Project Coordinator**
- Expert in project management and task coordination
- Specializes in breaking down complex projects, creating timelines, and managing stakeholder communication
- Capabilities: Web search, code interpreter

### 2. **Financial Advisor**
- Certified Financial Advisor specializing in portfolio analysis
- Expertise in investment research and strategic rebalancing
- Capabilities: Web search, code interpreter, file upload

### 3. **Medical Diagnosis Specialist**
- Board-certified Medical Imaging Specialist
- Expertise in radiology, pathology, and diagnostic interpretation
- Vision capabilities for analyzing medical images
- Capabilities: Vision, file upload, web search

### 4. **Email HTML Coder**
- Expert email HTML developer specializing in PoliteMail
- Outlook integration and email analytics expertise
- Specialized in responsive email templates and email client compatibility
- Capabilities: Code interpreter, file upload, web search

## 📁 Repository Structure

```
agents/                          # Agent configuration files
├── coordinator-agent-config.json
├── financial-advisor-agent-config.json
├── email-html-coder-agent-config.json
└── README.md

restore_agents.json              # Complete agent backup for restoration
import_agents.py                 # Python script for direct database import
import_agents_api.sh             # Shell script for API-based import
import_agents_3002.sh            # Import script for port 3002
AGENT_IMPORT_GUIDE.md            # Comprehensive import guide
```

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed
- Open WebUI running (default port: 3002)

### Importing Agents

#### Method 1: API Import (Recommended)
```bash
# Get your JWT token from Open WebUI
export JWT_TOKEN="your_jwt_token_here"

# Import all agents
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $JWT_TOKEN" \
  -d @restore_agents.json \
  http://localhost:3002/api/v1/models/import
```

#### Method 2: Manual UI Import
1. Open Open WebUI → Settings → Models
2. Click "Import Models"
3. Select `restore_agents.json`
4. Click "Import"
5. Refresh your browser

#### Method 3: Python Script
```bash
python3 import_agents.py
```

## 🔧 Configuration

### Port Configuration
This fork uses port **3002** by default (instead of 3000) to avoid conflicts.

To change the port, edit `docker-compose.yaml`:
```yaml
ports:
  - ${OPEN_WEBUI_PORT-3002}:8080
```

### Docker Compose
```bash
# Start Open WebUI
docker-compose up -d

# View logs
docker-compose logs -f

# Stop Open WebUI
docker-compose down
```

## 📚 Documentation

- `AGENT_IMPORT_GUIDE.md` - Detailed guide for importing agents
- `IMPORT_INSTRUCTIONS.md` - Quick import instructions
- `agents/README.md` - Agent-specific documentation
- `DISTRIBUTION.md` - Distribution and packaging information

## 🔄 Updating from Upstream

To pull updates from the original Open WebUI repository:

```bash
# Fetch upstream changes
git fetch upstream

# Merge upstream changes
git merge upstream/main

# Resolve any conflicts, then commit
git commit -m "Merge upstream changes"
```

## 📝 Customizations

### Agent Configurations
All agent configurations are stored in the `agents/` directory. Each agent includes:
- System prompts and role definitions
- Capability settings (vision, web search, code interpreter, etc.)
- Model parameters (temperature, top_p, max_tokens)
- Suggestion prompts for quick access

### PoliteMail Email Coder
The Email HTML Coder agent is specifically configured for:
- PoliteMail platform integration
- Outlook email client compatibility
- Email analytics and tracking
- Responsive email template design

## 🤝 Contributing

This is a custom fork. For contributions to the main Open WebUI project, please visit:
https://github.com/open-webui/open-webui

## 📄 License

This repository maintains the same license as the upstream Open WebUI project.

## 🙏 Acknowledgments

- [Open WebUI](https://github.com/open-webui/open-webui) - The base project
- All contributors to the Open WebUI project

---

**Note**: This is a customized fork. For the latest features and updates, consider also following the upstream repository.

