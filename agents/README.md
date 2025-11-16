# Agent Profiles Directory

This directory contains agent configuration files for Open WebUI. These files define custom AI agents with specific roles, capabilities, and system prompts.

## Current Agents

- **coordinator-agent-config.json** - Project Coordinator agent specializing in task management, project planning, and team collaboration
- **financial-advisor-agent-config.json** - Financial Advisor agent focused on portfolio analysis, investment research, and strategic rebalancing
- **medical-diagnosis-agent-config.json** - Medical Diagnosis Specialist with expertise in radiology, pathology, and diagnostic interpretation of medical images

## Backup Files

This directory includes multiple backup copies of each agent configuration:

- **`.backup`** files - Simple backup copies with `.backup` extension
- **Timestamped files** - Backup copies with date/time stamps (format: `YYYYMMDD-HHMMSS`)

This ensures you have multiple restore points for your agent configurations.

## Usage

These configuration files can be imported into Open WebUI to create custom agents with specialized capabilities. Each file contains:

- Agent metadata (name, description, capabilities)
- System prompts defining the agent's role and expertise
- Model parameters and configuration
- Access control settings

### Medical Diagnosis Agent Features

The Medical Diagnosis Specialist agent includes:

- **Vision Capability**: Can analyze medical images (X-rays, CT scans, MRI, ultrasound, pathology slides)
- **File Upload**: Accepts various medical image formats
- **Web Search**: Access to current medical literature and guidelines
- **Specialized Prompts**: Pre-configured suggestions for common medical imaging tasks
- **Safety Disclaimers**: Built-in warnings about educational use only

**Important**: This agent is designed for educational and research purposes only. It should never be used as a substitute for professional medical diagnosis or treatment.

## Importing Agents into Open WebUI

These JSON files need to be imported into the Open WebUI database to appear in the UI.

### Quick Import
```bash
# From the Open WebUI root directory
python3 import_agents.py
```

### Manual Import
1. Go to Open WebUI → Settings → Models
2. Click "Import Models"
3. Select the JSON files from this directory
4. Click "Import"

### API Import
```bash
# Set your admin token first
export ADMIN_TOKEN="your_token_here"
./import_agents_api.sh
```

**Important**: After importing, refresh your browser to see the agents in the model selector.

For detailed instructions, see `AGENT_IMPORT_GUIDE.md` in the root directory.
