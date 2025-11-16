#!/usr/bin/env python3
"""
Open WebUI Agent Import Script

This script automatically imports agent configurations from JSON files
into the Open WebUI database so they appear in the UI.

Usage:
    python3 import_agents.py

The script will:
1. Look for agent JSON files in the agents/ directory
2. Import them into the Open WebUI database
3. Make them available in the UI
"""

import os
import sys
import json
import logging
from pathlib import Path

# Add the backend directory to Python path
backend_dir = Path(__file__).parent / "backend"
sys.path.insert(0, str(backend_dir))

try:
    from open_webui.models.models import Models, ModelForm
    from open_webui.internal.db import get_db
    from open_webui.env import DATA_DIR
except ImportError as e:
    print(f"Error importing Open WebUI modules: {e}")
    print("Make sure you're running this script from the Open WebUI root directory")
    sys.exit(1)

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

def load_agent_config(file_path):
    """Load agent configuration from JSON file"""
    try:
        with open(file_path, 'r') as f:
            config = json.load(f)
        return config
    except Exception as e:
        logger.error(f"Error loading {file_path}: {e}")
        return None

def import_agent_to_database(agent_config, admin_user_id="00000000-0000-0000-0000-000000000000"):
    """Import agent configuration into the database"""
    try:
        # Check if model already exists
        existing_model = Models.get_model_by_id(agent_config.get("id"))
        
        if existing_model:
            logger.info(f"Agent {agent_config.get('id')} already exists, updating...")
            # Update existing model
            agent_config["meta"] = agent_config.get("meta", {})
            agent_config["params"] = agent_config.get("params", {})
            
            updated_model = ModelForm(
                **{**existing_model.model_dump(), **agent_config}
            )
            Models.update_model_by_id(agent_config.get("id"), updated_model)
            logger.info(f"Updated agent: {agent_config.get('name')}")
        else:
            logger.info(f"Creating new agent: {agent_config.get('name')}")
            # Create new model
            agent_config["meta"] = agent_config.get("meta", {})
            agent_config["params"] = agent_config.get("params", {})
            
            new_model = ModelForm(**agent_config)
            Models.insert_new_model(user_id=admin_user_id, form_data=new_model)
            logger.info(f"Created agent: {agent_config.get('name')}")
            
        return True
    except Exception as e:
        logger.error(f"Error importing agent {agent_config.get('id')}: {e}")
        return False

def main():
    """Main function to import all agents"""
    agents_dir = Path("agents")
    
    if not agents_dir.exists():
        logger.error("Agents directory not found!")
        return False
    
    # Find all agent JSON files (excluding backups)
    agent_files = []
    for file_path in agents_dir.glob("*.json"):
        if not file_path.name.endswith(".backup") and not file_path.name.startswith("README"):
            agent_files.append(file_path)
    
    if not agent_files:
        logger.warning("No agent configuration files found!")
        return False
    
    logger.info(f"Found {len(agent_files)} agent configuration files")
    
    success_count = 0
    for file_path in agent_files:
        logger.info(f"Processing {file_path.name}...")
        
        agent_config = load_agent_config(file_path)
        if agent_config:
            if import_agent_to_database(agent_config):
                success_count += 1
        else:
            logger.error(f"Failed to load {file_path.name}")
    
    logger.info(f"Successfully imported {success_count}/{len(agent_files)} agents")
    
    if success_count > 0:
        logger.info("✅ Agents have been imported and should now appear in the Open WebUI interface!")
        logger.info("🔄 You may need to refresh your browser to see the new agents.")
    else:
        logger.error("❌ No agents were successfully imported.")
    
    return success_count > 0

if __name__ == "__main__":
    print("🚀 Open WebUI Agent Import Script")
    print("=" * 40)
    
    # Check if we're in the right directory
    if not Path("backend").exists() or not Path("agents").exists():
        print("❌ Error: Please run this script from the Open WebUI root directory")
        print("   (the directory containing 'backend' and 'agents' folders)")
        sys.exit(1)
    
    success = main()
    sys.exit(0 if success else 1)
