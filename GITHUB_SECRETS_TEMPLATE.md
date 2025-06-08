# GitHub Secrets Configuration for MifosX Railway Deployment

# Copy this template and add the actual values to your GitHub repository secrets

# === CORE RAILWAY SECRETS ===

RAILWAY_TOKEN=your_railway_api_token_here

# === RAILWAY SERVICE IDS ===

RAILWAY_SERVICE_ID_STAGING=your_staging_service_id_here
RAILWAY_SERVICE_ID_PRODUCTION=your_production_service_id_here

# === FINERACT STAGING CONFIGURATION ===

FINERACT_API_URLS_STAGING=https://your-fineract-staging.railway.app
FINERACT_API_URL_STAGING=https://your-fineract-staging.railway.app
FINERACT_TENANT_ID_STAGING=default
FINERACT_TENANT_IDS_STAGING=default,demo,test

# === FINERACT PRODUCTION CONFIGURATION ===

FINERACT_API_URLS_PRODUCTION=https://your-fineract-production.railway.app
FINERACT_API_URL_PRODUCTION=https://your-fineract-production.railway.app
FINERACT_TENANT_ID_PRODUCTION=default
FINERACT_TENANT_IDS_PRODUCTION=default,live

# === OPTIONAL TEST SECRETS (for TestRigor integration) ===

MIFOS_TEST_SUITE_ID=your_testrigor_suite_id
MIFOS_AUTH_TOKEN=your_testrigor_auth_token
LOCALHOST_URL=http://localhost:4200

# === OPTIONAL DOCKER SECRETS (for Docker Hub publishing) ===

DOCKER_ORGANIZATION=your_docker_org
DOCKER_USER=your_docker_username
DOCKER_PASSWORD=your_docker_password

# === INSTRUCTIONS ===

# 1. Go to your GitHub repository

# 2. Navigate to Settings > Secrets and variables > Actions

# 3. Click "New repository secret" for each secret above

# 4. Use the exact secret name (left side of =) as the secret name

# 5. Use the actual value (replace right side of =) as the secret value

#

# IMPORTANT: Never commit actual secret values to your repository!

# This file contains only template placeholders.

# === RAILWAY TOKEN SETUP ===

# 1. Go to https://railway.app/account/tokens

# 2. Click "Create Token"

# 3. Copy the generated token

# 4. Add it as RAILWAY_TOKEN in GitHub secrets

# === SERVICE ID SETUP ===

# Run the setup-railway-projects.sh script to get service IDs

# Or get them manually from Railway dashboard:

# 1. Go to your Railway project

# 2. Click on the service

# 3. Copy the service ID from the URL or settings

# === FINERACT URL SETUP ===

# 1. Deploy Fineract to Railway first

# 2. Get the Railway-provided URL for your Fineract deployment

# 3. Use that URL for FINERACT*API_URL*\* secrets
