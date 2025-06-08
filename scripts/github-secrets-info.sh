#!/bin/bash

# GitHub Secrets Configuration Helper for MifosX Railway Deployment

echo "🚀 GitHub Secrets Configuration for MifosX Railway Deployment"
echo "=============================================================="
echo ""

echo "📋 Repository: https://github.com/MYKLCS/MifosX"
echo "🔧 Configure at: https://github.com/MYKLCS/MifosX/settings/secrets/actions"
echo ""

echo "🔑 Required GitHub Secrets:"
echo "============================"
echo ""

echo "1. RAILWAY_TOKEN"
echo "   • Generate from: https://railway.app/account/tokens"
echo "   • Click 'Create New Token', name it 'GitHub Actions - MifosX'"
echo "   • Copy the generated token"
echo ""

echo "2. RAILWAY_PRODUCTION_PROJECT_ID"
echo "   • Value: 71e46957-dc0f-4e52-80ba-f1edb3e11666"
echo ""

echo "3. RAILWAY_PRODUCTION_SERVICE_ID"
echo "   • Value: a2567a8b-16bc-4089-b82b-ec7547450707"
echo ""

echo "🧪 Test Deployment:"
echo "==================="
echo "1. Configure the 3 secrets above in GitHub"
echo "2. Make any code change"
echo "3. Run: git add . && git commit -m 'test: trigger deployment' && git push origin main"
echo "4. Watch: https://github.com/MYKLCS/MifosX/actions"
echo ""

echo "🌐 Current Deployment URLs:"
echo "==========================="
echo "Frontend: https://mifosx-production.up.railway.app"
echo "Backend:  https://fineract-production.up.railway.app"
echo ""

echo "📖 Documentation: SETUP_GITHUB_SECRETS.md"
echo ""
echo "✅ Ready for automated Railway deployment!"
