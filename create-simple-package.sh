#!/bin/bash

# Simple Open WebUI + Ollama Distribution Script
# Creates a minimal package that can be easily distributed and installed

set -e

PACKAGE_NAME="open-webui-local"
VERSION=$(date +%Y%m%d)
DIST_DIR="dist"
PACKAGE_DIR="${DIST_DIR}/${PACKAGE_NAME}-${VERSION}"

echo "🚀 Creating Simple Open WebUI + Ollama Package"
echo "=============================================="

# Create distribution directory
mkdir -p "${PACKAGE_DIR}"

echo "📋 Creating installation files..."

# Create simple installation script
cat > "${PACKAGE_DIR}/install.sh" << 'EOF'
#!/bin/bash

# Simple Open WebUI + Ollama Installation
set -e

echo "🚀 Installing Open WebUI + Ollama"
echo "================================="

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is required. Install from: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! docker info &> /dev/null; then
    echo "❌ Docker is not running. Please start Docker."
    exit 1
fi

echo "📦 Pulling images..."
docker pull ghcr.io/open-webui/open-webui:main
docker pull ollama/ollama:latest

echo "🏗️ Creating data directories..."
mkdir -p ./data/open-webui
mkdir -p ./data/ollama

echo "🚀 Starting services..."

# Create Docker Compose file
cat > docker-compose.yml << 'COMPOSE_EOF'
version: '3.8'

services:
  ollama:
    image: ollama/ollama:latest
    container_name: ollama
    volumes:
      - ./data/ollama:/root/.ollama
    ports:
      - "11434:11434"
    restart: unless-stopped

  open-webui:
    image: ghcr.io/open-webui/open-webui:main
    container_name: open-webui
    volumes:
      - ./data/open-webui:/app/backend/data
    ports:
      - "3000:8080"
    environment:
      - OLLAMA_BASE_URL=http://ollama:11434
      - WEBUI_SECRET_KEY=
    depends_on:
      - ollama
    restart: unless-stopped
COMPOSE_EOF

# Start services
docker-compose up -d

echo "⏳ Waiting for services to start..."
sleep 15

echo "✅ Installation complete!"
echo ""
echo "🌐 Open WebUI: http://localhost:3000"
echo "🤖 Ollama API: http://localhost:11434"
echo ""
echo "📁 Data stored in: ./data/"
echo ""
echo "🛠️ Commands:"
echo "   - Stop: docker-compose down"
echo "   - Start: docker-compose up -d"
echo "   - Logs: docker-compose logs"
echo "   - Update: docker-compose pull && docker-compose up -d"
echo ""
echo "🎉 Ready to use!"
EOF

chmod +x "${PACKAGE_DIR}/install.sh"

# Create README
cat > "${PACKAGE_DIR}/README.md" << 'EOF'
# Open WebUI + Ollama Local Installation

Simple, one-command installation of Open WebUI with Ollama for local AI chat.

## Quick Start

1. **Run the installer**:
   ```bash
   ./install.sh
   ```

2. **Access the application**:
   - Open WebUI: http://localhost:3000
   - Ollama API: http://localhost:11434

## What This Installs

- **Open WebUI**: Modern web interface for AI chat
- **Ollama**: Local AI model server
- **Docker Compose**: Orchestrates both services
- **Persistent Storage**: Your data is saved locally

## System Requirements

- Docker installed and running
- 4GB+ RAM (8GB+ recommended)
- 10GB+ free disk space

## Downloading Models

After installation, download AI models:

```bash
# Download a model (example: Llama 2)
docker exec ollama ollama pull llama2

# List available models
docker exec ollama ollama list

# Remove a model
docker exec ollama ollama rm llama2
```

## Popular Models to Try

- `llama2` - Meta's Llama 2 (7B parameters)
- `codellama` - Code-focused Llama model
- `mistral` - Mistral 7B model
- `phi` - Microsoft's Phi model (smaller, faster)

## Management

- **Stop services**: `docker-compose down`
- **Start services**: `docker-compose up -d`
- **View logs**: `docker-compose logs`
- **Update**: `docker-compose pull && docker-compose up -d`

## Troubleshooting

- **Port conflicts**: Edit `docker-compose.yml` to change ports
- **Memory issues**: Download smaller models or increase system RAM
- **Docker issues**: Ensure Docker is running and accessible

## Data Location

- Open WebUI data: `./data/open-webui/`
- Ollama models: `./data/ollama/`

## Privacy

Everything runs locally on your machine - no data is sent to external servers.
EOF

# Copy agent configurations if they exist
if [ -d "agents" ]; then
    echo "📁 Including agent configurations..."
    cp -r agents "${PACKAGE_DIR}/"
    echo "📝 Agent configurations included in package"
fi

echo "📦 Creating package..."
cd "${DIST_DIR}"
tar -czf "${PACKAGE_NAME}-${VERSION}.tar.gz" "${PACKAGE_NAME}-${VERSION}"

echo "✅ Package created!"
echo ""
echo "📦 File: ${DIST_DIR}/${PACKAGE_NAME}-${VERSION}.tar.gz"
echo "📁 Size: $(du -h "${PACKAGE_NAME}-${VERSION}.tar.gz" | cut -f1)"
echo ""
echo "🚀 Distribution ready!"
echo "   Send the .tar.gz file to install on any computer with Docker"
