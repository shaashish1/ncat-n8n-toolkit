# FFmpeg Output Files

This directory contains processed files and is shared across all containers and mirrored in MinIO bucket `ffmpeg-output`.

## Access Points:
- **Host**: `./shared-files/ffmpeg-output/`
- **ncat-media-toolkit**: `/app/ffmpeg-output/`
- **n8n-app**: `/files/ffmpeg-output/`
- **minio**: `/data/ffmpeg-output/` (and accessible via S3 API at `http://minio:9000/ffmpeg-output/`)
- **ollama-cpu**: `/shared-files/ffmpeg-output/`

## Usage:
Processed files are automatically placed here by:
1. NCA Toolkit API processing endpoints
2. Direct FFmpeg commands in n8n workflows
3. Ollama AI processing results
4. Custom processing scripts

## Example Outputs:
- transcribed-audio.json
- processed-video.mp4
- compressed-video.mp4
- extracted-frames/
- captions.srt