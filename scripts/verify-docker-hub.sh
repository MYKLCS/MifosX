#!/bin/bash

# 🔍 Docker Hub Secrets Verification Script

echo "🐳 Checking Docker Hub Integration Status"
echo "=========================================="
echo ""

echo "📋 Repository: https://github.com/MYKLCS/MifosX"
echo "🔧 Secrets Page: https://github.com/MYKLCS/MifosX/settings/secrets/actions"
echo "📊 Actions Page: https://github.com/MYKLCS/MifosX/actions"
echo ""

echo "🔍 Recent Git Activity:"
echo "======================="
git log --oneline -5
echo ""

echo "📋 Workflow Trigger Files:"
echo "=========================="
echo "✅ Docker workflow: .github/workflows/create-docker-hub-image.yml"
if [ -f ".github/workflows/create-docker-hub-image.yml" ]; then
    echo "   └── File exists and ready"
else
    echo "   └── ❌ File missing"
fi
echo ""

echo "🔍 Checking Workflow Configuration:"
echo "==================================="
if [ -f ".github/workflows/create-docker-hub-image.yml" ]; then
    # Check if workflow has secret validation
    if grep -q "secrets.DOCKER_USER" .github/workflows/create-docker-hub-image.yml; then
        echo "✅ Secret validation: Found DOCKER_USER reference"
    fi
    if grep -q "secrets.DOCKER_PASSWORD" .github/workflows/create-docker-hub-image.yml; then
        echo "✅ Secret validation: Found DOCKER_PASSWORD reference"
    fi
    if grep -q "secrets.DOCKER_ORGANIZATION" .github/workflows/create-docker-hub-image.yml; then
        echo "✅ Secret validation: Found DOCKER_ORGANIZATION reference"
    fi
    
    # Check for modern actions
    if grep -q "actions/checkout@v4" .github/workflows/create-docker-hub-image.yml; then
        echo "✅ Modern actions: Using checkout@v4"
    fi
    if grep -q "docker/setup-buildx-action@v3" .github/workflows/create-docker-hub-image.yml; then
        echo "✅ Modern actions: Using setup-buildx@v3"
    fi
    
    # Check for multi-arch
    if grep -q "linux/amd64,linux/arm64" .github/workflows/create-docker-hub-image.yml; then
        echo "✅ Multi-architecture: AMD64 + ARM64 builds enabled"
    fi
fi
echo ""

echo "🎯 Next Steps to Verify Docker Hub Integration:"
echo "==============================================="
echo "1. 📊 Check GitHub Actions: https://github.com/MYKLCS/MifosX/actions"
echo "2. 🔍 Look for 'Publish Image in Docker Hub' workflow"
echo "3. ✅ Verify workflow shows 'Docker Hub secrets configured' (not skipped)"
echo "4. 🐳 Check your Docker Hub repository for published images"
echo ""

echo "🔑 Required Secrets (should be configured):"
echo "============================================"
echo "• DOCKER_USER (your Docker Hub username)"
echo "• DOCKER_PASSWORD (Docker Hub access token)"
echo "• DOCKER_ORGANIZATION (where to publish images)"
echo ""

echo "🏷️ Expected Docker Images After Successful Build:"
echo "=================================================="
echo "• [organization]/web-app:dev"
echo "• [organization]/web-app:latest"
echo "• [organization]/web-app:dev-[git-hash]"
echo ""

echo "🔗 Quick Links for Verification:"
echo "================================"
echo "• GitHub Actions: https://github.com/MYKLCS/MifosX/actions"
echo "• Docker Hub: https://hub.docker.com/repositories"
echo "• Your repositories: https://hub.docker.com/u/[your-username]"
echo ""

echo "✅ Verification complete! Check the GitHub Actions page to see results."
