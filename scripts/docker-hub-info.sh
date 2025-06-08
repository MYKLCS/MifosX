#!/bin/bash

# Docker Hub Secrets Configuration Helper for MifosX

echo "🐳 Docker Hub Configuration for MifosX"
echo "======================================"
echo ""

echo "📋 Repository: https://github.com/MYKLCS/MifosX"
echo "🔧 Configure at: https://github.com/MYKLCS/MifosX/settings/secrets/actions"
echo ""

echo "🔑 Required GitHub Secrets:"
echo "============================"
echo ""

echo "1. DOCKER_USER"
echo "   • Your Docker Hub username"
echo "   • Example: myklcs"
echo ""

echo "2. DOCKER_PASSWORD"
echo "   • Generate access token from: https://hub.docker.com/settings/security"
echo "   • Click 'New Access Token', name it 'GitHub Actions - MifosX'"
echo "   • Select 'Read, Write, Delete' permissions"
echo "   • Copy the generated token"
echo ""

echo "3. DOCKER_ORGANIZATION"
echo "   • Docker Hub organization/username where images will be published"
echo "   • Example: openmf, myklcs, or your Docker Hub username"
echo ""

echo "🏷️ Generated Docker Image Tags:"
echo "==============================="
echo "For dev branch:"
echo "• [organization]/web-app:dev"
echo "• [organization]/web-app:latest"
echo "• [organization]/web-app:dev-[git-hash]"
echo ""
echo "For other branches:"
echo "• [organization]/web-app:[branch-name]"
echo "• [organization]/web-app:[branch-name]-[git-hash]"
echo ""

echo "🧪 Test Docker Build:"
echo "====================="
echo "1. Configure the 3 secrets above in GitHub"
echo "2. Push code to dev branch:"
echo "   git add . && git commit -m 'test: trigger Docker build' && git push origin dev"
echo "3. Watch: https://github.com/MYKLCS/MifosX/actions"
echo "4. Check your Docker Hub repository for the published image"
echo ""

echo "🌐 Workflow Features:"
echo "===================="
echo "✅ Multi-architecture builds (linux/amd64, linux/arm64)"
echo "✅ Optimized with GitHub Actions cache"
echo "✅ Smart tagging based on branch and git hash"
echo "✅ Security: Only pushes on push events (not PRs)"
echo "✅ Latest action versions with security updates"
echo ""

echo "📖 Documentation: DOCKER_HUB_SETUP.md"
echo ""
echo "✅ Docker Hub workflow updated and ready!"
