# Container Communication URLs - Complete Reference

## Overview
This document provides all possible URLs for communication between the 5 Docker containers in the full-stack setup:

1. **ncat-media-toolkit** (NCA Toolkit API)
2. **minio** (S3-compatible storage)
3. **n8n-app** (Workflow automation with FFmpeg)
4. **n8n-postgres** (PostgreSQL database)
5. **ollama-cpu** (AI/LLM processing)

## Complete URL Matrix

### External URLs (Access from Host/Outside Docker)

| Service | Purpose | External URL | Credentials |
|---------|---------|--------------|-------------|
| NCA Toolkit | API Endpoint | `http://localhost:8080` | API Key: `local-dev-key-123` |
| n8n | Web Interface | `http://localhost:5678` | None (local dev) |
| n8n | Webhook Endpoint | `http://localhost:5678/webhook/{webhook-id}` | None |
| MinIO | S3 API | `http://localhost:9000` | minioadmin / minioadmin123 |
| MinIO | Web Console | `http://localhost:9001` | minioadmin / minioadmin123 |
| PostgreSQL | Database | `localhost:5432` | n8n / n8n123 |
| Ollama | AI API | `http://localhost:11434` | None |

### Internal URLs (Container-to-Container Communication)

#### From n8n-app to other containers:
```bash
# To NCA Toolkit
http://ncat-media-toolkit:8080/v1/toolkit/test
http://ncat-media-toolkit:8080/v1/media/transcribe
http://ncat-media-toolkit:8080/v1/video/caption
http://ncat-media-toolkit:8080/v1/ffmpeg/compose

# To MinIO
http://minio:9000/bucket-name/file.ext
http://minio:9000/ffmpeg-input/
http://minio:9000/ffmpeg-output/

# To PostgreSQL
postgresql://n8n:n8n123@n8n-postgres:5432/n8n

# To Ollama
http://ollama-cpu:11434/api/generate
http://ollama-cpu:11434/api/chat
http://ollama-cpu:11434/api/embeddings
```

#### From ncat-media-toolkit to other containers:
```bash
# To MinIO (for file operations)
http://minio:9000

# To Ollama (for AI processing)
http://ollama-cpu:11434/api/generate

# To PostgreSQL (if needed)
postgresql://n8n:n8n123@n8n-postgres:5432/n8n
```

#### From ollama-cpu to other containers:
```bash
# To MinIO (for model/file storage)
http://minio:9000

# To NCA Toolkit (callback/webhook)
http://ncat-media-toolkit:8080/v1/webhook/ollama
```

## n8n Workflow Configuration Examples

### HTTP Request to NCA Toolkit
```json
{
  "method": "POST",
  "url": "http://ncat-media-toolkit:8080/v1/media/transcribe",
  "headers": {
    "x-api-key": "local-dev-key-123",
    "Content-Type": "application/json"
  },
  "body": {
    "media_url": "http://minio:9000/ffmpeg-input/audio.mp3",
    "language": "en"
  }
}
```

### HTTP Request to Ollama
```json
{
  "method": "POST", 
  "url": "http://ollama-cpu:11434/api/generate",
  "headers": {
    "Content-Type": "application/json"
  },
  "body": {
    "model": "llama3.2:1b",
    "prompt": "Process this text: {{ $json.content }}",
    "stream": false
  }
}
```

### PostgreSQL Query in n8n
```sql
-- Connection: postgresql://n8n:n8n123@n8n-postgres:5432/n8n
SELECT * FROM workflow_entity WHERE name = 'media_processing';
```

### MinIO S3 Operations
```bash
# Upload file
PUT http://minio:9000/ffmpeg-output/processed-video.mp4
Authorization: AWS4-HMAC-SHA256 Credential=minioadmin/...

# Download file  
GET http://minio:9000/ffmpeg-input/source-video.mp4
```

## Shared Folder Access

All containers can access shared folders at these mount points:

### Container Mount Points:
```bash
# ncat-media-toolkit
/app/ffmpeg-input/     # Input files
/app/ffmpeg-output/    # Output files

# n8n-app  
/files/ffmpeg-input/   # Input access
/files/ffmpeg-output/  # Output access
/files/general/        # General shared files

# minio
/data/ffmpeg-input/    # S3 bucket mirror
/data/ffmpeg-output/   # S3 bucket mirror

# ollama-cpu
/shared-files/         # All shared files access
```

### Host System Access:
```bash
./shared-files/ffmpeg-input/    # Input files (host)
./shared-files/ffmpeg-output/   # Output files (host)
./shared-files/general/         # General files (host)
```

## Complete Workflow Example

Here's how all 5 containers work together in a typical workflow:

1. **File Upload** → MinIO (`http://minio:9000/ffmpeg-input/`)
2. **n8n Trigger** → Detects new file via webhook
3. **API Call** → NCA Toolkit (`http://ncat-media-toolkit:8080/v1/media/transcribe`)
4. **Processing** → NCA Toolkit uses FFmpeg to process file
5. **AI Analysis** → NCA Toolkit calls Ollama (`http://ollama-cpu:11434/api/generate`)
6. **Storage** → Results saved to MinIO (`http://minio:9000/ffmpeg-output/`)
7. **Database** → Workflow status stored in PostgreSQL
8. **Notification** → n8n sends completion webhook

## Environment Variables for URLs

Set these in your `.env.full-stack` file:

```env
# Service URLs (internal communication)
MINIO_ENDPOINT=http://minio:9000
POSTGRES_URL=postgresql://n8n:n8n123@n8n-postgres:5432/n8n
OLLAMA_ENDPOINT=http://ollama-cpu:11434
NCAT_ENDPOINT=http://ncat-media-toolkit:8080

# External access URLs  
EXTERNAL_MINIO_URL=http://localhost:9000
EXTERNAL_N8N_URL=http://localhost:5678
EXTERNAL_NCAT_URL=http://localhost:8080
EXTERNAL_OLLAMA_URL=http://localhost:11434
EXTERNAL_POSTGRES_URL=localhost:5432

# API Keys and Credentials
API_KEY=local-dev-key-123
MINIO_ACCESS_KEY=minioadmin  
MINIO_SECRET_KEY=minioadmin123
POSTGRES_USER=n8n
POSTGRES_PASSWORD=n8n123
```

## Quick Reference Commands

### Test Container Communication:
```bash
# Test NCA Toolkit
curl -H "x-api-key: local-dev-key-123" http://localhost:8080/v1/toolkit/test

# Test Ollama
curl -X POST http://localhost:11434/api/generate \
  -H "Content-Type: application/json" \
  -d '{"model":"llama3.2:1b","prompt":"Hello","stream":false}'

# Test MinIO
curl http://localhost:9001/minio/health/live

# Test PostgreSQL
psql -h localhost -p 5432 -U n8n -d n8n -c "SELECT version();"

# Test n8n
curl http://localhost:5678/healthz
```

### Container Network Inspection:
```bash
# List networks
docker network ls

# Inspect full-stack network
docker network inspect ncat-n8n-toolkit_full-stack-network

# Check container IPs
docker compose -f docker-compose.full-stack.yml ps
```

This reference provides all the URLs needed for complete communication between all 5 containers in your setup.