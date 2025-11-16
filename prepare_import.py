#!/usr/bin/env python3
"""
Open WebUI Agent Import Data Generator

This script creates a properly formatted import file that can be used
with Open WebUI's built-in import functionality.
"""

import json
import os
from pathlib import Path

def load_agent_config(file_path):
    """Load agent configuration from JSON file"""
    try:
        with open(file_path, 'r') as f:
            config = json.load(f)
        return config
    except Exception as e:
        print(f"Error loading {file_path}: {e}")
        return None

def create_import_file():
    """Create a single import file with all agents"""
    agents_dir = Path("agents")
    
    if not agents_dir.exists():
        print("❌ Agents directory not found!")
        return False
    
    # Find all agent JSON files (excluding backups)
    agent_files = []
    for file_path in agents_dir.glob("*.json"):
        if not file_path.name.endswith(".backup") and not file_path.name.startswith("README"):
            agent_files.append(file_path)
    
    if not agent_files:
        print("⚠️  No agent configuration files found!")
        return False
    
    print(f"📦 Found {len(agent_files)} agent configuration files")
    
    # Load all agent configurations
    agents = []
    for file_path in agent_files:
        print(f"📄 Processing {file_path.name}...")
        agent_config = load_agent_config(file_path)
        if agent_config:
            agents.append(agent_config)
            print(f"✅ Loaded {agent_config.get('name', 'Unknown')}")
        else:
            print(f"❌ Failed to load {file_path.name}")
    
    if not agents:
        print("❌ No agents were successfully loaded!")
        return False
    
    # Create import file
    import_data = {
        "models": agents
    }
    
    # Write import file
    import_file = "agents_import.json"
    with open(import_file, 'w') as f:
        json.dump(import_data, f, indent=2)
    
    print(f"✅ Created import file: {import_file}")
    print(f"📊 Ready to import {len(agents)} agents:")
    
    for agent in agents:
        print(f"   - {agent.get('name', 'Unknown')} ({agent.get('id', 'No ID')})")
    
    print("\n🚀 To import:")
    print("1. Go to Open WebUI → Settings → Models")
    print("2. Click 'Import Models'")
    print(f"3. Select the file: {import_file}")
    print("4. Click 'Import'")
    print("5. Refresh your browser")
    
    return True

if __name__ == "__main__":
    print("🚀 Open WebUI Agent Import Data Generator")
    print("=" * 45)
    
    success = create_import_file()
    exit(0 if success else 1)
