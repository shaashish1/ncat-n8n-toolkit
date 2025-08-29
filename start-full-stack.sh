#!/bin/bash

echo "🚀 Starting Full Stack NCA Toolkit Environment..."

# Create shared directories if they don't exist
mkdir -p ./shared-files/ffmpeg-input
mkdir -p ./shared-files/ffmpeg-output
mkdir -p ./shared-files/general

# Copy environment file if it doesn't exist
if [ ! -f .env.full-stack ]; then
    echo "📋 Creating environment configuration..."
    cp .env.full-stack.example .env.full-stack
    echo "✅ Created .env.full-stack - customize it if needed"
fi

# Stop any running containers first
echo "🛑 Stopping any existing containers..."
docker compose -f docker-compose.full-stack.yml down

# Start all containers
echo "🔧 Building and starting all 5 containers..."
docker compose -f docker-compose.full-stack.yml up -d --build

echo "⏳ Waiting for services to initialize..."
sleep 30

# Check container status
echo "📊 Container Status:"
docker compose -f docker-compose.full-stack.yml ps

echo ""
echo "🎉 Full Stack Environment Ready!"
echo ""
echo "📋 Service Access URLs:"
echo "• NCA Toolkit API:        http://localhost:8080"
echo "• n8n Workflow Interface: http://localhost:5678"
echo "• MinIO Console:          http://localhost:9001 (minioadmin/minioadmin123)"
echo "• PostgreSQL Database:    localhost:5432 (n8n/n8n123)"
echo "• Ollama AI API:          http://localhost:11434"
echo ""
echo "📁 Shared Folders Created:"
echo "• ./shared-files/ffmpeg-input/  - Place input files here"
echo "• ./shared-files/ffmpeg-output/ - Processed files appear here"
echo ""
echo "🧪 Test the setup:"
echo "curl -H 'x-api-key: local-dev-key-123' http://localhost:8080/v1/toolkit/test"
echo ""
echo "📚 Full documentation: docker-compose.full-stack.md"
echo ""