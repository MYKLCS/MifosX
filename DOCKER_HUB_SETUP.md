# Docker Hub Secrets Configuration

## Overview

The `create-docker-hub-image.yml` workflow publishes Docker images to Docker Hub when code is pushed to specific branches. This requires configuring Docker Hub credentials as GitHub secrets.

## Required GitHub Secrets

### 1. DOCKER_USER

- **Purpose**: Docker Hub username for authentication
- **How to get**: Your Docker Hub username
- **Required**: Yes

### 2. DOCKER_PASSWORD

- **Purpose**: Docker Hub password or access token for authentication
- **How to get**:
  - Use your Docker Hub password (less secure)
  - **Recommended**: Generate a Docker Hub access token from [Docker Hub Account Settings → Security](https://hub.docker.com/settings/security)
- **Required**: Yes

### 3. DOCKER_ORGANIZATION

- **Purpose**: Docker Hub organization or username where images will be published
- **Example**: `openmf`, `myklcs`, or your Docker Hub username
- **Required**: Yes

## Setup Instructions

### Step 1: Create Docker Hub Access Token (Recommended)

1. Go to [Docker Hub](https://hub.docker.com/)
2. Sign in to your account
3. Go to Account Settings → Security
4. Click "New Access Token"
5. Name it: `GitHub Actions - MifosX`
6. Select permissions: `Read, Write, Delete`
7. Copy the generated token

### Step 2: Configure GitHub Secrets

1. Go to [GitHub Repository Settings → Secrets](https://github.com/MYKLCS/MifosX/settings/secrets/actions)
2. Click "New repository secret" for each secret:

**DOCKER_USER**

- Name: `DOCKER_USER`
- Value: `[Your Docker Hub username]`

**DOCKER_PASSWORD**

- Name: `DOCKER_PASSWORD`
- Value: `[Your Docker Hub password or access token]`

**DOCKER_ORGANIZATION**

- Name: `DOCKER_ORGANIZATION`
- Value: `[Your Docker Hub organization/username]`

## Docker Image Tags

The workflow automatically creates the following Docker image tags:

### For dev branch (main branch):

- `organization/web-app:dev`
- `organization/web-app:latest`
- `organization/web-app:dev-[short-git-hash]`

### For other branches:

- `organization/web-app:[branch-name]`
- `organization/web-app:[branch-name]-[short-git-hash]`

### For pull requests:

- `organization/web-app:pr-[pr-number]` (built but not pushed)

## Workflow Features

✅ **Updated to latest actions**:

- `actions/checkout@v4`
- `docker/setup-qemu-action@v3`
- `docker/setup-buildx-action@v3`
- `docker/login-action@v3`
- `docker/metadata-action@v5`
- `docker/build-push-action@v5`

✅ **Multi-architecture builds**: `linux/amd64`, `linux/arm64`

✅ **Optimized caching**: Uses GitHub Actions cache for faster builds

✅ **Security**: Only pushes images on push events (not pull requests)

✅ **Smart tagging**: Automatic tag generation based on branch and git hash

## Testing the Workflow

1. Configure the GitHub secrets above
2. Push code to the `dev` branch:
   ```bash
   git add .
   git commit -m "test: trigger Docker Hub image build"
   git push origin dev
   ```
3. Watch the workflow: [GitHub Actions](https://github.com/MYKLCS/MifosX/actions)
4. Check your Docker Hub repository for the published image

## Troubleshooting

### Common Issues:

1. **"authentication failed"**

   - Check DOCKER_USER and DOCKER_PASSWORD are correctly configured
   - If using access token, ensure it has write permissions

2. **"repository does not exist"**

   - Check DOCKER_ORGANIZATION is correct
   - Ensure the repository exists on Docker Hub or will be auto-created

3. **"platform not supported"**
   - The workflow builds for both `linux/amd64` and `linux/arm64`
   - Ensure your Dockerfile supports multi-architecture builds

### Workflow Logs:

- Check GitHub Actions logs: Repository → Actions tab → Select workflow run
- Docker build logs will show detailed build progress and any errors

## Security Notes

- Use Docker Hub access tokens instead of passwords when possible
- Regularly rotate your Docker Hub access tokens
- Never commit Docker credentials to your repository
- The workflow only triggers on specified branches for security
