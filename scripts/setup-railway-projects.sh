#!/bin/bash

# Railway Setup Script for MifosX Web App
# This script automates the creation of Railway projects and configuration

set -e

echo "🚀 Railway Setup Script for MifosX Web App"
echo "=========================================="

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI not found. Installing..."
    npm install -g @railway/cli
    echo "✅ Railway CLI installed"
fi

# Check if user is logged in
if ! railway whoami &> /dev/null; then
    echo "🔐 Please login to Railway..."
    railway login
fi

echo "👤 Logged in as: $(railway whoami)"

# Function to create Railway project
create_railway_project() {
    local project_name=$1
    local environment=$2
    
    echo ""
    echo "📦 Creating Railway project: $project_name"
    
    # Create new project
    railway new "$project_name" --template blank
    
    echo "✅ Created project: $project_name"
    
    # Get project info
    cd "$project_name"
    
    # Get service ID
    SERVICE_ID=$(railway status --json | jq -r '.services[0].id' 2>/dev/null || echo "")
    
    if [ -n "$SERVICE_ID" ]; then
        echo "📋 Service ID for $environment: $SERVICE_ID"
        echo "   Add this to GitHub secrets as: RAILWAY_SERVICE_ID_${environment^^}"
    else
        echo "⚠️  Could not retrieve service ID automatically"
        echo "   Please get it manually from Railway dashboard"
    fi
    
    cd ..
}

# Create staging project
read -p "📝 Enter staging project name (default: mifos-x-staging): " STAGING_NAME
STAGING_NAME=${STAGING_NAME:-mifos-x-staging}
create_railway_project "$STAGING_NAME" "staging"

# Create production project
read -p "📝 Enter production project name (default: mifos-x-production): " PRODUCTION_NAME
PRODUCTION_NAME=${PRODUCTION_NAME:-mifos-x-production}
create_railway_project "$PRODUCTION_NAME" "production"

echo ""
echo "🎉 Railway projects created successfully!"
echo ""
echo "📋 Next Steps:"
echo "1. Get your Railway API token from: https://railway.app/account/tokens"
echo "2. Add these secrets to your GitHub repository:"
echo "   - RAILWAY_TOKEN"
echo "   - RAILWAY_SERVICE_ID_STAGING"
echo "   - RAILWAY_SERVICE_ID_PRODUCTION"
echo "   - FINERACT_API_URL_STAGING"
echo "   - FINERACT_API_URL_PRODUCTION"
echo "   - And other Fineract configuration secrets"
echo ""
echo "3. Deploy Fineract backend to Railway"
echo "4. Test the deployment by pushing to develop or main branch"
echo ""
echo "📖 See RAILWAY_DEPLOYMENT_GUIDE.md for detailed instructions"
