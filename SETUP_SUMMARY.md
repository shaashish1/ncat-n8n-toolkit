# Complete Answer: 5-Container Docker Setup with Communication URLs

## Summary

You now have a complete 5-container Docker setup with comprehensive documentation covering:

### ✅ All 5 Containers Included:
1. **ncat-media-toolkit** (No-Code Architects Toolkit API)
2. **minio** (S3-compatible object storage) 
3. **n8n-app** (Workflow automation with FFmpeg pre-installed)
4. **n8n-postgres** (PostgreSQL database)
5. **ollama-cpu** (AI/LLM processing engine)

### ✅ Complete URL Communication Matrix:

#### External URLs (from host/browser):
- NCA Toolkit API: `http://localhost:8080`
- n8n Interface: `http://localhost:5678`
- MinIO Console: `http://localhost:9001`
- PostgreSQL: `localhost:5432`
- Ollama AI API: `http://localhost:11434`

#### Internal URLs (container-to-container):
- From n8n → NCA Toolkit: `http://ncat-media-toolkit:8080`
- From n8n → MinIO: `http://minio:9000`
- From n8n → PostgreSQL: `postgresql://n8n:n8n123@n8n-postgres:5432/n8n`
- From n8n → Ollama: `http://ollama-cpu:11434`
- From NCA Toolkit → MinIO: `http://minio:9000`
- From NCA Toolkit → Ollama: `http://ollama-cpu:11434`

### ✅ Shared Folder Structure (Accessible by All Containers):
```
./shared-files/
├── ffmpeg-input/    # Input files for processing
├── ffmpeg-output/   # Processed output files
└── general/         # General shared files
```

### ✅ FFmpeg Integration:
- **Pre-installed in n8n container** for direct workflow use
- **Available in NCA Toolkit** for API-based processing
- **Shared folders** accessible from both containers
- **Direct file paths**: `/files/ffmpeg-input/` and `/files/ffmpeg-output/` in n8n

## Quick Start:

1. **Start All Containers:**
   ```bash
   ./start-full-stack.sh
   ```

2. **Access Services:**
   - NCA Toolkit: http://localhost:8080
   - n8n Workflows: http://localhost:5678
   - MinIO Console: http://localhost:9001

3. **Test Communication:**
   ```bash
   curl -H "x-api-key: local-dev-key-123" http://localhost:8080/v1/toolkit/test
   ```

## Key Files Created:

1. **docker-compose.full-stack.yml** - Complete 5-container setup
2. **docker-compose.full-stack.md** - Comprehensive documentation (13KB)
3. **CONTAINER_URLS.md** - Complete URL reference matrix
4. **start-full-stack.sh** - One-command setup script
5. **.env.full-stack.example** - Environment configuration template

## Workflow Integration:

Your n8n workflows can now:
- ✅ Call NCA Toolkit endpoints via `http://ncat-media-toolkit:8080/v1/*`
- ✅ Use Ollama AI via `http://ollama-cpu:11434/api/*`
- ✅ Access MinIO storage via `http://minio:9000/*`
- ✅ Store data in PostgreSQL database
- ✅ Run FFmpeg commands directly with Execute Command nodes
- ✅ Access shared folders at `/files/ffmpeg-input/` and `/files/ffmpeg-output/`

All containers are connected on the same Docker network (`full-stack-network`) enabling seamless communication using internal hostnames and shared file access.

**Complete documentation available in: `docker-compose.full-stack.md`**