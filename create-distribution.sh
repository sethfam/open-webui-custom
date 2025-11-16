#!/bin/bash

# Open WebUI + Ollama Combined Installation Script
# This script creates a distributable package with everything needed to run locally

set -e

# Configuration
PACKAGE_NAME="open-webui-ollama-package"
VERSION=$(date +%Y%m%d-%H%M%S)
DIST_DIR="dist"
PACKAGE_DIR="${DIST_DIR}/${PACKAGE_NAME}-${VERSION}"

echo "🚀 Creating Open WebUI + Ollama Distribution Package"
echo "=================================================="

# Create distribution directory
mkdir -p "${PACKAGE_DIR}"

echo "📦 Building combined Docker image..."
# Build the combined image
docker build -f Dockerfile.combined -t open-webui-ollama:latest .

echo "💾 Saving Docker image to tar file..."
# Save the Docker image to a tar file
docker save open-webui-ollama:latest | gzip > "${PACKAGE_DIR}/open-webui-ollama-image.tar.gz"

echo "📋 Creating installation files..."

# Create installation script
cat > "${PACKAGE_DIR}/install.sh" << 'EOF'
#!/bin/bash

# Open WebUI + Ollama Installation Script
set -e

echo "🚀 Installing Open WebUI + Ollama Combined Package"
echo "================================================="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first:"
    echo "   https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

echo "📦 Loading Docker image..."
docker load < open-webui-ollama-image.tar.gz

echo "🏗️ Creating data directories..."
mkdir -p ./data/open-webui
mkdir -p ./data/ollama

echo "🚀 Starting Open WebUI + Ollama..."
docker run -d \
    --name open-webui-ollama \
    --restart unless-stopped \
    -p 3000:8080 \
    -p 11434:11434 \
    -v "$(pwd)/data/open-webui:/app/backend/data" \
    -v "$(pwd)/data/ollama:/root/.ollama" \
    -e WEBUI_SECRET_KEY="" \
    -e OLLAMA_BASE_URL=http://localhost:11434 \
    open-webui-ollama:latest

echo "⏳ Waiting for services to start..."
sleep 10

echo "✅ Installation complete!"
echo ""
echo "🌐 Open WebUI is available at: http://localhost:3000"
echo "🤖 Ollama API is available at: http://localhost:11434"
echo ""
echo "📁 Data is stored in:"
echo "   - Open WebUI: ./data/open-webui"
echo "   - Ollama models: ./data/ollama"
echo ""
echo "🛠️ Management commands:"
echo "   - Stop: docker stop open-webui-ollama"
echo "   - Start: docker start open-webui-ollama"
echo "   - Logs: docker logs open-webui-ollama"
echo "   - Remove: docker rm -f open-webui-ollama"
echo ""
echo "🎉 Enjoy your local AI setup!"
EOF

chmod +x "${PACKAGE_DIR}/install.sh"

# Create Docker Compose file for alternative installation
cat > "${PACKAGE_DIR}/docker-compose.yml" << 'EOF'
version: '3.8'

services:
  open-webui-ollama:
    image: open-webui-ollama:latest
    container_name: open-webui-ollama
    volumes:
      - ./data/open-webui:/app/backend/data
      - ./data/ollama:/root/.ollama
    ports:
      - "3000:8080"  # Open WebUI
      - "11434:11434"  # Ollama API
    environment:
      - WEBUI_SECRET_KEY=
      - OLLAMA_BASE_URL=http://localhost:11434
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
EOF

# Create README
cat > "${PACKAGE_DIR}/README.md" << 'EOF'
# Open WebUI + Ollama Combined Package

This package contains everything needed to run Open WebUI with Ollama locally in a single Docker container.

## Quick Start

1. **Extract the package**:
   ```bash
   tar -xzf open-webui-ollama-package-*.tar.gz
   cd open-webui-ollama-package-*
   ```

2. **Run the installer**:
   ```bash
   ./install.sh
   ```

3. **Access the application**:
   - Open WebUI: http://localhost:3000
   - Ollama API: http://localhost:11434

## Alternative Installation (Docker Compose)

If you prefer using Docker Compose:

1. Load the image:
   ```bash
   docker load < open-webui-ollama-image.tar.gz
   ```

2. Start with Docker Compose:
   ```bash
   docker-compose up -d
   ```

## What's Included

- **Open WebUI**: Modern web interface for AI chat
- **Ollama**: Local AI model server
- **Pre-configured**: Everything is set up to work together
- **Persistent data**: Your chats and models are saved locally

## Features

- 🤖 Run AI models locally (no internet required after setup)
- 💬 Modern chat interface
- 📁 File uploads and document processing
- 🔧 Easy model management
- 🔒 Privacy-focused (everything runs locally)

## System Requirements

- Docker installed and running
- At least 4GB RAM (8GB+ recommended)
- 10GB+ free disk space for models

## Managing Models

After installation, you can download models using Ollama:

```bash
# Download a model
docker exec open-webui-ollama ollama pull llama2

# List available models
docker exec open-webui-ollama ollama list
```

## Troubleshooting

- **Port conflicts**: If ports 3000 or 11434 are in use, modify the port mappings in the installation script
- **Memory issues**: Ensure you have enough RAM for the models you want to run
- **Docker issues**: Make sure Docker is running and you have permission to use it

## Support

For issues and support, visit:
- Open WebUI: https://github.com/open-webui/open-webui
- Ollama: https://github.com/ollama/ollama
EOF

# Copy agent configurations if they exist
if [ -d "agents" ]; then
    echo "📁 Including agent configurations..."
    cp -r agents "${PACKAGE_DIR}/"
fi

echo "📦 Creating final package..."
cd "${DIST_DIR}"
tar -czf "${PACKAGE_NAME}-${VERSION}.tar.gz" "${PACKAGE_NAME}-${VERSION}"

echo "✅ Package created successfully!"
echo ""
echo "📦 Package: ${DIST_DIR}/${PACKAGE_NAME}-${VERSION}.tar.gz"
echo "📁 Size: $(du -h "${PACKAGE_NAME}-${VERSION}.tar.gz" | cut -f1)"
echo ""
echo "🚀 To distribute:"
echo "   1. Send the .tar.gz file to the target computer"
echo "   2. Extract: tar -xzf ${PACKAGE_NAME}-${VERSION}.tar.gz"
echo "   3. Install: cd ${PACKAGE_NAME}-${VERSION} && ./install.sh"
echo ""
echo "🎉 Ready for distribution!"
