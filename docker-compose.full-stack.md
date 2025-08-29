# Full Stack Docker Container Communication and Workflow Setup

This comprehensive setup provides a complete development environment with 5 interconnected Docker containers for advanced media processing, workflow automation, and AI integration.

## What's Included - All 5 Containers

- **ncat-media-toolkit**: No Code Architect Toolkit API with FFmpeg processing capabilities
- **minio**: S3-compatible object storage with web console for file management
- **n8n-app**: Workflow automation platform with built-in FFmpeg and PostgreSQL integration
- **n8n-postgres**: PostgreSQL database for n8n workflow persistence
- **ollama-cpu**: CPU-based AI/LLM processing engine for local AI operations

## Prerequisites

- Docker and Docker Compose installed
- Git (to clone the repository)
- At least 4GB available RAM
- At least 10GB available disk space

---

## Quick Start

### 1. Prepare Environment Configuration

```bash
cp .env.full-stack.example .env.full-stack
```

### 2. Create Shared Directories

```bash
mkdir -p ./shared-files/ffmpeg-input
mkdir -p ./shared-files/ffmpeg-output
```

### 3. Start All 5 Containers

```bash
docker compose -f docker-compose.full-stack.yml up -d
```

### 4. Access All Services

Once all services are running:

- **NCA Toolkit API**: http://localhost:8080
- **n8n Workflow Interface**: http://localhost:5678
- **MinIO Console**: http://localhost:9001 (minioadmin / minioadmin123)
- **PostgreSQL Database**: localhost:5432 (n8n / n8n123)
- **Ollama AI API**: http://localhost:11434

---

## Complete Container Communication Matrix

### External URLs (From Host Machine)

| Container | Service | External URL | Purpose |
|-----------|---------|--------------|----------|
| ncat-media-toolkit | API Endpoint | `http://localhost:8080` | Media processing API |
| n8n-app | Web Interface | `http://localhost:5678` | Workflow automation UI |
| n8n-app | Webhook Endpoint | `http://localhost:5678/webhook/` | Webhook receiver |
| minio | S3 API | `http://localhost:9000` | S3-compatible storage API |
| minio | Web Console | `http://localhost:9001` | MinIO management interface |
| n8n-postgres | Database | `localhost:5432` | PostgreSQL database |
| ollama-cpu | AI API | `http://localhost:11434` | Local AI/LLM processing |

### Internal URLs (Container-to-Container Communication)

| From Container | To Container | Internal URL | Purpose |
|----------------|--------------|---------------|----------|
| n8n-app | ncat-media-toolkit | `http://ncat-media-toolkit:8080` | API calls from workflows |
| n8n-app | minio | `http://minio:9000` | S3 operations from workflows |
| n8n-app | n8n-postgres | `postgresql://n8n:n8n123@n8n-postgres:5432/n8n` | Database operations |
| n8n-app | ollama-cpu | `http://ollama-cpu:11434` | AI processing from workflows |
| ncat-media-toolkit | minio | `http://minio:9000` | File storage operations |
| ncat-media-toolkit | ollama-cpu | `http://ollama-cpu:11434` | AI processing integration |
| ollama-cpu | minio | `http://minio:9000` | AI model storage/retrieval |

---

## Service Details and Communication Endpoints

### 1. NCA Toolkit (ncat-media-toolkit) - Port 8080

**External Access**: `http://localhost:8080`  
**Internal Access**: `http://ncat-media-toolkit:8080`  
**API Key**: `local-dev-key-123`

#### Available Endpoints for n8n Integration:
- `http://ncat-media-toolkit:8080/v1/toolkit/test` - API connection test
- `http://ncat-media-toolkit:8080/v1/media/transcribe` - Audio/video transcription
- `http://ncat-media-toolkit:8080/v1/video/caption` - Video captioning
- `http://ncat-media-toolkit:8080/v1/ffmpeg/compose` - Advanced FFmpeg operations
- `http://ncat-media-toolkit:8080/v1/image/screenshot/webpage` - Web screenshots

### 2. n8n Workflow Automation (n8n-app) - Port 5678

**External Access**: `http://localhost:5678`  
**Internal Network Name**: `n8n-app`  
**Database**: Connected to PostgreSQL for persistence  
**FFmpeg**: Pre-installed in container

#### Built-in Capabilities:
- FFmpeg command execution via Execute Command node
- Direct file access to shared folders
- PostgreSQL integration for workflow data
- HTTP requests to all other containers

### 3. MinIO Object Storage (minio) - Ports 9000, 9001

**S3 API**: `http://localhost:9000` (external) / `http://minio:9000` (internal)  
**Web Console**: `http://localhost:9001`  
**Credentials**: minioadmin / minioadmin123

#### Pre-configured Buckets:
- `nca-toolkit-local` - General toolkit storage
- `ffmpeg-input` - Input files for processing
- `ffmpeg-output` - Processed output files

### 4. PostgreSQL Database (n8n-postgres) - Port 5432

**External Access**: `localhost:5432`  
**Internal Access**: `n8n-postgres:5432`  
**Database**: n8n  
**Credentials**: n8n / n8n123

### 5. Ollama AI Engine (ollama-cpu) - Port 11434

**External Access**: `http://localhost:11434`  
**Internal Access**: `http://ollama-cpu:11434`  
**Pre-loaded Model**: llama3.2:1b (lightweight model)

#### Available Endpoints:
- `http://ollama-cpu:11434/api/generate` - Text generation
- `http://ollama-cpu:11434/api/chat` - Chat completions
- `http://ollama-cpu:11434/api/embeddings` - Text embeddings

---

## Shared Folder Structure and Access

All containers can access shared folders for seamless file processing:

```
./shared-files/
├── ffmpeg-input/    # Input files (mirrors MinIO bucket)
├── ffmpeg-output/   # Processed files (mirrors MinIO bucket)
└── general/         # General shared files
```

### Container Access Points:

| Container | Mount Path | Purpose |
|-----------|------------|----------|
| ncat-media-toolkit | `/app/ffmpeg-input` | Direct FFmpeg input processing |
| ncat-media-toolkit | `/app/ffmpeg-output` | Direct FFmpeg output storage |
| n8n-app | `/files/ffmpeg-input` | n8n workflow input access |
| n8n-app | `/files/ffmpeg-output` | n8n workflow output access |
| minio | `/data/ffmpeg-input` | S3 bucket mirroring |
| minio | `/data/ffmpeg-output` | S3 bucket mirroring |
| ollama-cpu | `/shared-files` | AI processing file access |

---

## Complete n8n Workflow Integration Examples

### Example 1: Media Processing Workflow

**HTTP Request Node Configuration:**
```json
{
  "method": "POST",
  "url": "http://ncat-media-toolkit:8080/v1/media/transcribe",
  "headers": {
    "x-api-key": "local-dev-key-123",
    "Content-Type": "application/json"
  },
  "body": {
    "media_url": "http://minio:9000/ffmpeg-input/sample-audio.mp3",
    "language": "en",
    "response_format": "json"
  }
}
```

### Example 2: AI Processing with Ollama

**HTTP Request Node Configuration:**
```json
{
  "method": "POST",
  "url": "http://ollama-cpu:11434/api/generate",
  "headers": {
    "Content-Type": "application/json"
  },
  "body": {
    "model": "llama3.2:1b",
    "prompt": "Summarize this transcription: {{ $json.transcription }}",
    "stream": false
  }
}
```

### Example 3: Direct FFmpeg Processing in n8n

**Execute Command Node:**
```bash
ffmpeg -i /files/ffmpeg-input/input-video.mp4 \
       -vf "scale=1280:720" \
       -c:v libx264 -crf 23 \
       /files/ffmpeg-output/processed-video.mp4
```

### Example 4: File Upload to MinIO

**HTTP Request Node (S3 PUT):**
```json
{
  "method": "PUT",
  "url": "http://minio:9000/ffmpeg-output/{{ $json.filename }}",
  "headers": {
    "Authorization": "AWS4-HMAC-SHA256 Credential=minioadmin/...",
    "Content-Type": "video/mp4"
  }
}
```

---

## Advanced Inter-Container Communication Patterns

### 1. Sequential Processing Pipeline
```
Input File → MinIO → NCA Toolkit → FFmpeg Processing → Ollama AI Analysis → Output Storage
```

### 2. Parallel Processing
```
Input File → [NCA Toolkit + Ollama CPU] → Combine Results → MinIO Storage
```

### 3. Workflow Orchestration
```
n8n Trigger → PostgreSQL Query → API Calls → File Operations → Webhook Response
```

---

## Environment Variables for Container Communication

### Application Configuration
```env
APP_NAME=NCAToolkit
APP_URL=http://localhost:8080
API_KEY=local-dev-key-123
```

### Inter-Service URLs
```env
MINIO_ENDPOINT=http://minio:9000
POSTGRES_URL=postgresql://n8n:n8n123@n8n-postgres:5432/n8n
OLLAMA_ENDPOINT=http://ollama-cpu:11434
N8N_WEBHOOK_URL=http://n8n-app:5678/webhook/
```

### File Paths
```env
FFMPEG_INPUT_PATH=/app/ffmpeg-input
FFMPEG_OUTPUT_PATH=/app/ffmpeg-output
SHARED_FILES_PATH=/shared-files
```

---

## Network Architecture

All containers communicate through the `full-stack-network` Docker bridge network:

```
┌─────────────────────┐    ┌─────────────────────┐    ┌─────────────────────┐
│   ncat-media-       │    │      n8n-app        │    │       minio         │
│   toolkit           │◄──►│   (with FFmpeg)     │◄──►│   S3 Storage        │
│   localhost:8080    │    │   localhost:5678    │    │  localhost:9000     │
└─────────────────────┘    └─────────────────────┘    └─────────────────────┘
         │                           │                           │
         │                           │                           │
         └────────┬──────────────────┼───────────────────────────┘
                  │                  │
    ┌─────────────▼─────┐    ┌──────▼──────────┐
    │   ollama-cpu      │    │  n8n-postgres   │
    │   localhost:11434 │    │  localhost:5432 │
    └───────────────────┘    └─────────────────┘
                  │                  │
                  └──────────────────┘
                           │
                ┌─────────────────────┐
                │  full-stack-network │
                │   (Docker Bridge)   │
                └─────────────────────┘
```

---

## Data Persistence

The following data persists between container restarts:

- **Application Storage**: `storage` volume (`/app/storage`)
- **Application Logs**: `logs` volume (`/app/logs`)
- **MinIO Data**: `minio_data` volume
- **n8n Workflows**: `n8n_data` volume (`/home/node/.n8n`)
- **PostgreSQL Data**: `postgres_data` volume (`/var/lib/postgresql/data`)
- **Ollama Models**: `ollama_data` volume (`/root/.ollama`)
- **Shared Files**: `./shared-files` directory (host-mounted)

---

## Development Workflow

### 1. Upload Files for Processing
```bash
# Upload to MinIO input bucket
curl -X PUT "http://localhost:9000/ffmpeg-input/sample.mp4" \
     -H "Authorization: AWS minioadmin:minioadmin123" \
     --data-binary @sample.mp4
```

### 2. Create n8n Workflow
1. Access n8n at http://localhost:5678
2. Create HTTP Request nodes pointing to internal service URLs
3. Use Execute Command nodes for direct FFmpeg operations
4. Store results in MinIO or PostgreSQL

### 3. Test API Endpoints
```bash
# Test NCA Toolkit
curl -H "x-api-key: local-dev-key-123" \
     http://localhost:8080/v1/toolkit/test

# Test Ollama
curl -X POST http://localhost:11434/api/generate \
     -H "Content-Type: application/json" \
     -d '{"model":"llama3.2:1b","prompt":"Hello world","stream":false}'
```

### 4. Monitor Logs
```bash
# View all container logs
docker compose -f docker-compose.full-stack.yml logs -f

# View specific container logs
docker compose -f docker-compose.full-stack.yml logs -f ncat-media-toolkit
```

---

## Troubleshooting

### Port Conflicts
If any ports are already in use, modify the port mappings in `docker-compose.full-stack.yml`:

```yaml
ports:
  - "8081:8080"  # Change external port
```

### Service Communication Issues
Verify all containers are on the same network:
```bash
docker network ls
docker network inspect ncat-n8n-toolkit_full-stack-network
```

### Database Connection Issues
Check PostgreSQL container status and credentials:
```bash
docker compose -f docker-compose.full-stack.yml logs n8n-postgres
```

### FFmpeg Issues in n8n
Verify FFmpeg installation:
```bash
docker compose -f docker-compose.full-stack.yml exec n8n-app ffmpeg -version
```

---

## Security Considerations

- Change default passwords in production
- Use proper authentication for API endpoints
- Limit network access between containers as needed
- Regularly update container images
- Use proper SSL/TLS certificates for external access

---

## Scaling and Production Notes

- Increase resource limits for production workloads
- Consider using external databases for production
- Implement proper backup strategies for persistent volumes
- Use container orchestration platforms (Kubernetes) for scaling
- Monitor container health and performance

This setup provides a complete foundation for advanced media processing workflows with AI integration, allowing seamless communication between all 5 containers through both internal Docker networking and shared file systems.