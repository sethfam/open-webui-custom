#!/bin/bash

# Open WebUI Agent Import Script (API-based)
# This script imports agent configurations via the Open WebUI API

set -e

# Configuration
WEBUI_URL="http://localhost:3000"
ADMIN_TOKEN=""  # You'll need to get this from Open WebUI admin settings
AGENTS_DIR="agents"

echo "🚀 Open WebUI Agent Import Script (API-based)"
echo "============================================="

# Check if agents directory exists
if [ ! -d "$AGENTS_DIR" ]; then
    echo "❌ Agents directory not found!"
    exit 1
fi

# Check if admin token is provided
if [ -z "$ADMIN_TOKEN" ]; then
    echo "⚠️  Admin token not provided."
    echo "   To get your admin token:"
    echo "   1. Go to Open WebUI admin settings"
    echo "   2. Generate an API token"
    echo "   3. Set ADMIN_TOKEN environment variable or edit this script"
    echo ""
    echo "   Example: ADMIN_TOKEN=your_token_here ./import_agents_api.sh"
    exit 1
fi

# Function to import a single agent
import_agent() {
    local file_path="$1"
    local filename=$(basename "$file_path")
    
    echo "📄 Processing $filename..."
    
    # Load the agent configuration
    local agent_config=$(cat "$file_path")
    
    # Create the import payload
    local import_payload=$(cat << EOF
{
    "models": [$agent_config]
}
EOF
)
    
    # Import via API
    local response=$(curl -s -w "\n%{http_code}" \
        -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $ADMIN_TOKEN" \
        -d "$import_payload" \
        "$WEBUI_URL/api/v1/models/import")
    
    local http_code=$(echo "$response" | tail -n1)
    local response_body=$(echo "$response" | head -n -1)
    
    if [ "$http_code" = "200" ]; then
        echo "✅ Successfully imported $filename"
        return 0
    else
        echo "❌ Failed to import $filename (HTTP $http_code)"
        echo "   Response: $response_body"
        return 1
    fi
}

# Find all agent JSON files (excluding backups)
agent_files=()
while IFS= read -r -d '' file; do
    agent_files+=("$file")
done < <(find "$AGENTS_DIR" -name "*.json" -not -name "*.backup" -not -name "README*" -print0)

if [ ${#agent_files[@]} -eq 0 ]; then
    echo "⚠️  No agent configuration files found!"
    exit 1
fi

echo "📦 Found ${#agent_files[@]} agent configuration files"

# Test API connection
echo "🔍 Testing API connection..."
if ! curl -s -H "Authorization: Bearer $ADMIN_TOKEN" "$WEBUI_URL/api/v1/models" > /dev/null; then
    echo "❌ Cannot connect to Open WebUI API at $WEBUI_URL"
    echo "   Make sure Open WebUI is running and the admin token is correct"
    exit 1
fi

echo "✅ API connection successful"

# Import all agents
success_count=0
for file_path in "${agent_files[@]}"; do
    if import_agent "$file_path"; then
        ((success_count++))
    fi
done

echo ""
echo "📊 Import Summary:"
echo "   Successfully imported: $success_count/${#agent_files[@]} agents"

if [ $success_count -gt 0 ]; then
    echo ""
    echo "✅ Agents have been imported!"
    echo "🔄 Refresh your Open WebUI browser tab to see the new agents."
    echo ""
    echo "🌐 Your agents should now appear in the model selector."
else
    echo ""
    echo "❌ No agents were successfully imported."
    echo "   Check the error messages above for details."
fi
