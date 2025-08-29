# FFmpeg Input Files

This directory is shared across all containers and mirrored in MinIO bucket `ffmpeg-input`.

## Access Points:
- **Host**: `./shared-files/ffmpeg-input/`
- **ncat-media-toolkit**: `/app/ffmpeg-input/`
- **n8n-app**: `/files/ffmpeg-input/`
- **minio**: `/data/ffmpeg-input/` (and accessible via S3 API at `http://minio:9000/ffmpeg-input/`)
- **ollama-cpu**: `/shared-files/ffmpeg-input/`

## Usage:
Place input media files here for processing by:
1. Uploading directly to this folder
2. Using MinIO S3 API to upload to `ffmpeg-input` bucket
3. Using n8n workflows to move files here
4. API calls that reference `http://minio:9000/ffmpeg-input/filename.ext`

## Example Files:
- sample-audio.mp3
- input-video.mp4
- presentation.pptx
- source-image.jpg