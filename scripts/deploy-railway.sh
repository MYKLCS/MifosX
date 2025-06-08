#!/bin/bash

# Railway Deployment Script for Mifos X Web App
# This script helps set up and deploy the application to Railway

set -e

echo "🚀 Mifos X Railway Deployment Script"
echo "===================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Railway CLI is installed
check_railway_cli() {
    print_status "Checking Railway CLI installation..."
    if ! command -v railway &> /dev/null; then
        print_warning "Railway CLI not found. Installing..."
        npm install -g @railway/cli
        print_success "Railway CLI installed successfully"
    else
        print_success "Railway CLI is already installed"
    fi
}

# Check if user is logged in to Railway
check_railway_auth() {
    print_status "Checking Railway authentication..."
    if ! railway whoami &> /dev/null; then
        print_warning "Not logged in to Railway. Please log in..."
        railway login
    else
        print_success "Already logged in to Railway"
    fi
}

# Validate environment variables
validate_environment() {
    print_status "Validating environment configuration..."
    
    # Check if required files exist
    if [ ! -f "railway.json" ]; then
        print_error "railway.json not found!"
        exit 1
    fi
    
    if [ ! -f ".github/workflows/deploy-railway.yml" ]; then
        print_error "Railway workflow file not found!"
        exit 1
    fi
    
    print_success "Environment configuration validated"
}

# Build and test the application
build_and_test() {
    print_status "Building and testing the application..."
    
    # Install dependencies
    print_status "Installing dependencies..."
    npm ci
    
    # Run tests
    print_status "Running tests..."
    npm run test:ci || {
        print_error "Tests failed!"
        exit 1
    }
    
    # Run linting
    print_status "Running linting..."
    npm run lint || {
        print_error "Linting failed!"
        exit 1
    }
    
    # Build the application
    print_status "Building application..."
    npm run build || {
        print_error "Build failed!"
        exit 1
    }
    
    print_success "Build and tests completed successfully"
}

# Deploy to Railway
deploy_to_railway() {
    local environment=${1:-"staging"}
    
    print_status "Deploying to Railway ($environment environment)..."
    
    case $environment in
        "staging")
            if [ -z "$RAILWAY_STAGING_PROJECT_ID" ]; then
                print_error "RAILWAY_STAGING_PROJECT_ID environment variable not set"
                exit 1
            fi
            railway link $RAILWAY_STAGING_PROJECT_ID
            ;;
        "production")
            if [ -z "$RAILWAY_PRODUCTION_PROJECT_ID" ]; then
                print_error "RAILWAY_PRODUCTION_PROJECT_ID environment variable not set"
                exit 1
            fi
            railway link $RAILWAY_PRODUCTION_PROJECT_ID
            ;;
        *)
            print_error "Invalid environment: $environment. Use 'staging' or 'production'"
            exit 1
            ;;
    esac
    
    # Deploy
    railway up || {
        print_error "Deployment failed!"
        exit 1
    }
    
    print_success "Deployment to $environment completed successfully!"
}

# Main deployment flow
main() {
    local environment=${1:-"staging"}
    local skip_tests=${2:-false}
    
    echo ""
    print_status "Starting deployment process for $environment environment"
    echo ""
    
    # Check prerequisites
    check_railway_cli
    check_railway_auth
    validate_environment
    
    # Build and test (unless skipped)
    if [ "$skip_tests" != "true" ]; then
        build_and_test
    else
        print_warning "Skipping tests as requested"
    fi
    
    # Deploy
    deploy_to_railway $environment
    
    echo ""
    print_success "🎉 Deployment completed successfully!"
    echo ""
    print_status "Next steps:"
    echo "1. Check Railway dashboard for deployment status"
    echo "2. Verify application is running correctly"
    echo "3. Test Fineract backend connectivity"
    echo "4. Configure custom domain if needed"
    echo ""
}

# Parse command line arguments
case "${1:-help}" in
    "staging")
        main "staging" "${2}"
        ;;
    "production")
        main "production" "${2}"
        ;;
    "help"|"--help"|"-h")
        echo ""
        echo "Usage: $0 [environment] [options]"
        echo ""
        echo "Environments:"
        echo "  staging     Deploy to staging environment"
        echo "  production  Deploy to production environment"
        echo ""
        echo "Options:"
        echo "  --skip-tests  Skip running tests before deployment"
        echo ""
        echo "Examples:"
        echo "  $0 staging                Deploy to staging with tests"
        echo "  $0 production --skip-tests Deploy to production without tests"
        echo ""
        ;;
    *)
        print_error "Invalid command: $1"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac
