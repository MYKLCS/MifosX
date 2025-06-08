# Railway Deployment Guide for MifosX Web App

## Overview

This guide provides complete instructions for deploying the MifosX Angular web application to Railway with Fineract backend integration.

## Prerequisites

### 1. Railway Account Setup

- Create a Railway account at [railway.app](https://railway.app)
- Install Railway CLI: `npm install -g @railway/cli`
- Login to Railway: `railway login`

### 2. Required GitHub Secrets

Configure these secrets in your GitHub repository settings (`Settings > Secrets and variables > Actions`):

#### Core Railway Secrets

```
RAILWAY_TOKEN                    # Your Railway API token
RAILWAY_SERVICE_ID_STAGING       # Staging service ID
RAILWAY_SERVICE_ID_PRODUCTION    # Production service ID
```

#### Fineract Integration Secrets (Staging)

```
FINERACT_API_URLS_STAGING        # e.g., "https://your-fineract-staging.railway.app"
FINERACT_API_URL_STAGING         # Primary Fineract API URL
FINERACT_TENANT_ID_STAGING       # Default tenant identifier
FINERACT_TENANT_IDS_STAGING      # Comma-separated tenant IDs
```

#### Fineract Integration Secrets (Production)

```
FINERACT_API_URLS_PRODUCTION     # e.g., "https://your-fineract-prod.railway.app"
FINERACT_API_URL_PRODUCTION      # Primary Fineract API URL
FINERACT_TENANT_ID_PRODUCTION    # Default tenant identifier
FINERACT_TENANT_IDS_PRODUCTION   # Comma-separated tenant IDs
```

## Step-by-Step Deployment Setup

### Step 1: Create Railway Projects

#### For Staging Environment

```bash
# Create staging project
railway new mifos-x-staging

# Navigate to project
cd mifos-x-staging

# Deploy from GitHub
railway connect

# Get service ID
railway status
# Copy the service ID for RAILWAY_SERVICE_ID_STAGING
```

#### For Production Environment

```bash
# Create production project
railway new mifos-x-production

# Navigate to project
cd mifos-x-production

# Deploy from GitHub
railway connect

# Get service ID
railway status
# Copy the service ID for RAILWAY_SERVICE_ID_PRODUCTION
```

### Step 2: Configure GitHub Secrets

1. Go to your GitHub repository
2. Navigate to `Settings > Secrets and variables > Actions`
3. Add all the required secrets listed above

### Step 3: Set Up Railway Token

1. Go to [Railway Dashboard](https://railway.app/dashboard)
2. Click on your profile > Settings
3. Go to "Tokens" section
4. Create a new token
5. Copy the token and add it as `RAILWAY_TOKEN` in GitHub secrets

### Step 4: Configure Fineract Backend

#### Deploy Fineract to Railway

```bash
# Create Fineract project
railway new fineract-backend

# Add PostgreSQL database
railway add postgresql

# Set environment variables for Fineract
railway variables set SPRING_DATASOURCE_URL="jdbc:postgresql://[host]:[port]/[database]"
railway variables set SPRING_DATASOURCE_USERNAME="[username]"
railway variables set SPRING_DATASOURCE_PASSWORD="[password]"
railway variables set SPRING_JPA_HIBERNATE_DDL_AUTO="update"

# Deploy Fineract
railway up
```

#### Get Fineract URLs

After Fineract deployment, get the Railway-provided URLs and use them for:

- `FINERACT_API_URL_STAGING`
- `FINERACT_API_URL_PRODUCTION`

### Step 5: Test Deployment

#### Trigger Staging Deployment

```bash
# Push to develop branch
git checkout develop
git push origin develop
```

#### Trigger Production Deployment

```bash
# Push to main branch
git checkout main
git push origin main
```

## Workflow Behavior

### Automatic Triggers

- **Staging**: Triggered on push to `develop` branch
- **Production**: Triggered on push to `main` branch

### Deployment Process

1. **Test Job**: Runs linting, tests, and builds the application
2. **Deploy Job**: Deploys to Railway and configures environment variables
3. **Notification**: Reports deployment status

### Environment Variables Set Automatically

The workflow automatically configures these environment variables in Railway:

```bash
FINERACT_API_URLS               # From GitHub secrets
FINERACT_API_URL                # From GitHub secrets
FINERACT_PLATFORM_TENANT_IDENTIFIER  # From GitHub secrets
FINERACT_PLATFORM_TENANTS_IDENTIFIER # From GitHub secrets
FINERACT_API_PROVIDER="/fineract-provider/api"
FINERACT_API_VERSION="/v1"
MIFOS_DEFAULT_LANGUAGE="en-US"
MIFOS_SUPPORTED_LANGUAGES="cs-CS,de-DE,en-US,es-MX,fr-FR,it-IT,ko-KO,lt-LT,lv-LV,ne-NE,pt-PT,sw-SW"
MIFOS_PRELOAD_CLIENTS="true"
MIFOS_DEFAULT_CHAR_DELIMITER=","
MIFOS_DISPLAY_BACKEND_INFO="true"
MIFOS_DISPLAY_TENANT_SELECTOR="true"
MIFOS_WAIT_TIME_FOR_NOTIFICATIONS="60"
MIFOS_WAIT_TIME_FOR_CATCHUP="30"
MIFOS_MIN_PASSWORD_LENGTH="12"
MIFOS_SESSION_IDLE_TIMEOUT="300000"
ENVIRONMENT="staging|production"
```

## Troubleshooting

### Common Issues

#### 1. "Context access might be invalid" warnings

- These are validation warnings for unconfigured secrets
- Normal behavior until secrets are configured in GitHub
- Will not prevent deployment once secrets are added

#### 2. Railway CLI installation fails

```bash
# Try with sudo or use npx
sudo npm install -g @railway/cli
# OR
npx @railway/cli login
```

#### 3. Authentication errors

```bash
# Re-authenticate with Railway
railway logout
railway login
```

#### 4. Service ID not found

- Ensure the service ID in GitHub secrets matches Railway
- Check Railway dashboard for correct service IDs

### Verification Steps

#### 1. Check GitHub Actions

- Go to your repository > Actions tab
- Verify workflow runs successfully
- Check logs for any errors

#### 2. Verify Railway Deployment

```bash
# Login to Railway
railway login

# Check project status
railway status

# View logs
railway logs
```

#### 3. Test Application

- Visit the Railway-provided URL
- Verify Fineract API connectivity
- Test login functionality

## Security Considerations

1. **Never commit secrets** to the repository
2. **Use environment-specific secrets** for staging vs production
3. **Regularly rotate Railway tokens**
4. **Monitor Railway logs** for security events
5. **Use HTTPS** for all API communications

## Support

### Railway Resources

- [Railway Documentation](https://docs.railway.app/)
- [Railway CLI Reference](https://docs.railway.app/develop/cli)
- [Railway Community](https://railway.app/discord)

### Fineract Resources

- [Apache Fineract Documentation](https://fineract.apache.org/)
- [Fineract API Documentation](https://demo.fineract.dev/fineract-provider/api-docs/apiLive.htm)

### MifosX Resources

- [MifosX GitHub Repository](https://github.com/openMF/web-app)
- [Mifos Community](https://mifos.org/)
