#!/bin/bash

# Open WebUI Agent Import Script (API-based) - Port 3002
# This script imports agent configurations via the Open WebUI API

set -e

# Configuration
WEBUI_URL="http://localhost:3002"
JWT_TOKEN="${JWT_TOKEN}"
RESTORE_FILE="restore_agents.json"

echo "🚀 Open WebUI Agent Import Script (Port 3002)"
echo "============================================="

# Check if JWT token is provided
if [ -z "$JWT_TOKEN" ]; then
    echo "⚠️  JWT token not provided."
    echo "   Please set JWT_TOKEN environment variable:"
    echo "   export JWT_TOKEN='your_jwt_token_here'"
    echo "   ./import_agents_3002.sh"
    exit 1
fi

# Check if restore file exists
if [ ! -f "$RESTORE_FILE" ]; then
    echo "❌ Restore file not found: $RESTORE_FILE"
    exit 1
fi

echo "📄 Using restore file: $RESTORE_FILE"
echo "🔍 Testing API connection..."

# Test API connection
if ! curl -s -H "Authorization: Bearer $JWT_TOKEN" "$WEBUI_URL/api/v1/models" > /dev/null; then
    echo "❌ Cannot connect to Open WebUI API at $WEBUI_URL"
    echo "   Make sure Open WebUI is running and the JWT token is correct"
    exit 1
fi

echo "✅ API connection successful"
echo "📦 Importing agents..."

# Import via API
response=$(curl -s -w "\n%{http_code}" \
    -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $JWT_TOKEN" \
    -d @"$RESTORE_FILE" \
    "$WEBUI_URL/api/v1/models/import")

http_code=$(echo "$response" | tail -n1)
response_body=$(echo "$response" | head -n -1)

if [ "$http_code" = "200" ] || [ "$http_code" = "201" ]; then
    echo "✅ Successfully imported agents!"
    echo "📊 Response: $response_body"
    echo ""
    echo "🔄 Refresh your Open WebUI browser tab to see the agents."
else
    echo "❌ Failed to import agents (HTTP $http_code)"
    echo "   Response: $response_body"
    exit 1
fi

