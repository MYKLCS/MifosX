#!/bin/bash

# Railway Deployment Status Checker
# Verifies the current state of Railway deployment setup

set -e

echo "🔍 Railway Deployment Status Check"
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check file existence
check_file() {
    local file=$1
    local description=$2
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ $description${NC}"
        return 0
    else
        echo -e "${RED}❌ $description${NC}"
        return 1
    fi
}

# Function to check GitHub Actions workflow
check_workflow() {
    local workflow=$1
    local description=$2
    
    if [ -f ".github/workflows/$workflow" ]; then
        echo -e "${GREEN}✅ $description workflow exists${NC}"
        # Basic syntax check
        if grep -q "name:" ".github/workflows/$workflow" && grep -q "on:" ".github/workflows/$workflow"; then
            echo -e "${GREEN}   └── Basic syntax appears valid${NC}"
        else
            echo -e "${YELLOW}   └── Warning: Workflow syntax might be invalid${NC}"
        fi
        return 0
    else
        echo -e "${RED}❌ $description workflow missing${NC}"
        return 1
    fi
}

echo ""
echo "📋 Checking Core Files..."

# Check essential workflow files
check_workflow "deploy-railway.yml" "Railway deployment"
check_workflow "build.yml" "Build and deploy"
check_workflow "test.yml" "Testing"
check_workflow "create-docker-hub-image.yml" "Docker image"
check_workflow "stale.yml" "Stale issue management"

echo ""
echo "📋 Checking Railway Configuration Files..."

# Check Railway configuration files
check_file "railway.json" "Railway platform configuration"
check_file "RAILWAY_DEPLOYMENT.md" "Railway deployment documentation"
check_file "RAILWAY_SETUP_CHECKLIST.md" "Railway setup checklist"
check_file "RAILWAY_DEPLOYMENT_GUIDE.md" "Comprehensive deployment guide"
check_file "GITHUB_SECRETS_TEMPLATE.md" "GitHub secrets template"

echo ""
echo "📋 Checking Scripts..."

# Check deployment scripts
check_file "scripts/deploy-railway.sh" "Railway deployment script"
check_file "scripts/validate-env.sh" "Environment validation script"
check_file "scripts/setup-railway-projects.sh" "Railway project setup script"

# Check if scripts are executable
if [ -f "scripts/deploy-railway.sh" ]; then
    if [ -x "scripts/deploy-railway.sh" ]; then
        echo -e "${GREEN}   └── deploy-railway.sh is executable${NC}"
    else
        echo -e "${YELLOW}   └── Warning: deploy-railway.sh is not executable${NC}"
    fi
fi

if [ -f "scripts/setup-railway-projects.sh" ]; then
    if [ -x "scripts/setup-railway-projects.sh" ]; then
        echo -e "${GREEN}   └── setup-railway-projects.sh is executable${NC}"
    else
        echo -e "${YELLOW}   └── Warning: setup-railway-projects.sh is not executable${NC}"
    fi
fi

echo ""
echo "📋 Checking Project Configuration..."

# Check package.json for required scripts
if [ -f "package.json" ]; then
    echo -e "${GREEN}✅ package.json exists${NC}"
    
    # Check for required npm scripts
    if grep -q '"build:prod"' package.json; then
        echo -e "${GREEN}   └── build:prod script available${NC}"
    else
        echo -e "${YELLOW}   └── Warning: build:prod script not found${NC}"
    fi
    
    if grep -q '"test:ci"' package.json; then 
        echo -e "${GREEN}   └── test:ci script available${NC}"
    else
        echo -e "${YELLOW}   └── Warning: test:ci script not found${NC}"
    fi
    
    if grep -q '"lint"' package.json; then
        echo -e "${GREEN}   └── lint script available${NC}"
    else
        echo -e "${YELLOW}   └── Warning: lint script not found${NC}"
    fi
else
    echo -e "${RED}❌ package.json missing${NC}"
fi

# Check for Angular configuration
check_file "angular.json" "Angular configuration"

echo ""
echo "🔧 Checking Git Status..."

# Check git status
if git status &>/dev/null; then
    echo -e "${GREEN}✅ Git repository initialized${NC}"
    
    # Check for uncommitted changes
    if git diff --quiet && git diff --cached --quiet; then
        echo -e "${GREEN}   └── No uncommitted changes${NC}"
    else
        echo -e "${YELLOW}   └── Warning: Uncommitted changes present${NC}"
        echo -e "${BLUE}      Run 'git status' to see changes${NC}"
    fi
    
    # Check current branch
    CURRENT_BRANCH=$(git branch --show-current)
    echo -e "${BLUE}   └── Current branch: $CURRENT_BRANCH${NC}"
    
    # Check remote
    if git remote -v | grep -q origin; then
        echo -e "${GREEN}   └── Origin remote configured${NC}"
    else
        echo -e "${YELLOW}   └── Warning: No origin remote configured${NC}"
    fi
else
    echo -e "${RED}❌ Not a git repository${NC}"
fi

echo ""
echo "🌐 Railway CLI Check..."

# Check Railway CLI
if command -v railway &> /dev/null; then
    echo -e "${GREEN}✅ Railway CLI installed${NC}"
    RAILWAY_VERSION=$(railway --version 2>/dev/null || echo "unknown")
    echo -e "${BLUE}   └── Version: $RAILWAY_VERSION${NC}"
    
    # Check if logged in
    if railway whoami &>/dev/null; then
        USER=$(railway whoami 2>/dev/null || echo "unknown")
        echo -e "${GREEN}   └── Logged in as: $USER${NC}"
    else
        echo -e "${YELLOW}   └── Not logged in to Railway${NC}"
        echo -e "${BLUE}      Run 'railway login' to authenticate${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Railway CLI not installed${NC}"
    echo -e "${BLUE}   └── Install with: npm install -g @railway/cli${NC}"
fi

echo ""
echo "📊 Summary & Next Steps"
echo "======================"

echo ""
echo -e "${BLUE}🚀 Ready for Railway Deployment!${NC}"
echo ""
echo "Next steps to complete setup:"
echo "1. 🔑 Configure GitHub repository secrets (see GITHUB_SECRETS_TEMPLATE.md)"
echo "2. 🏗️  Run ./scripts/setup-railway-projects.sh to create Railway projects"
echo "3. 🔧 Deploy Fineract backend to Railway with PostgreSQL"
echo "4. ✅ Test deployment by pushing to develop or main branch"
echo ""
echo "For detailed instructions, see:"
echo "📖 RAILWAY_DEPLOYMENT_GUIDE.md - Complete deployment guide"
echo "📋 RAILWAY_SETUP_CHECKLIST.md - Step-by-step checklist"
echo ""
echo -e "${GREEN}All core deployment infrastructure is in place! 🎉${NC}"
