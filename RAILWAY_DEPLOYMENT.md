# Railway Deployment Guide for Mifos X Web App

This guide covers deploying the Mifos X Web Application (Angular frontend for Fineract 1x) to Railway platform.

## Overview

The Mifos X Web App is deployed to Railway with the following setup:
- **Frontend**: Angular 17 application serving Fineract 1x UI
- **Backend Connection**: Connects to Fineract backend running on Railway
- **Database**: Fineract connects to PostgreSQL database on Railway
- **Environments**: Staging (develop branch) and Production (main branch)

## Quick Start

### 1. Prerequisites

- Railway account with CLI installed
- GitHub repository with appropriate secrets configured
- Fineract backend deployed on Railway
- PostgreSQL database configured for Fineract

### 2. Railway Setup

1. **Create Railway Projects**:
   ```bash
   # Production environment
   railway login
   railway new mifos-x-production
   
   # Staging environment
   railway new mifos-x-staging
   ```

2. **Configure GitHub Secrets**:
   - `RAILWAY_TOKEN`: Your Railway API token
   - `RAILWAY_PRODUCTION_PROJECT_ID`: Production project ID
   - `RAILWAY_PRODUCTION_SERVICE_ID`: Production service ID
   - `RAILWAY_STAGING_PROJECT_ID`: Staging project ID
   - `RAILWAY_STAGING_SERVICE_ID`: Staging service ID

### 3. Environment Variables

Configure these variables in your Railway dashboard:

#### Required Variables
```
NODE_ENV=production
FINERACT_BASE_URL=https://your-fineract.railway.app/fineract-provider
FINERACT_TENANT_IDENTIFIER=default
```

#### Optional UI Configuration
```
DEFAULT_LANGUAGE=en-US
SUPPORTED_LANGUAGES=en-US,es-MX,fr-FR,pt-PT,sw-SW,lt-LT,lv-LV
ALLOW_SERVER_SWITCHING=false
PRELOAD_CLIENTS_ON_LOGIN=true
DEFAULT_THEME=default
ENABLE_MULTITENANT=false
DEMO_CREDENTIALS_ENABLED=false
PASSWORD_VALIDATION_ENABLED=true
OAUTH_ENABLED=false
SELF_SERVICE_ENABLED=true
SHOW_LANGUAGE_SELECTOR=true
SHOW_THEME_PICKER=true
```

## Deployment Process

### Automatic Deployment

Deployments are triggered automatically:
- **Staging**: Push to `develop` branch → deploys to staging environment
- **Production**: Push to `main` branch → deploys to production environment

### Manual Deployment

If you need to deploy manually:

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login to Railway
railway login

# Link to your project
railway link [PROJECT_ID]

# Deploy
railway up
```

## Configuration Files

### railway.json
The `railway.json` file configures:
- Docker build settings using the existing Dockerfile
- Environment-specific variables
- Deployment settings and restart policies

### GitHub Actions Workflow
`.github/workflows/deploy-railway.yml` handles:
- Automated testing before deployment
- Security auditing with npm audit
- Environment-specific deployments
- Build validation

## Fineract Backend Integration

The frontend connects to Fineract backend via:
- `FINERACT_BASE_URL`: Full URL to Fineract API endpoint
- `FINERACT_TENANT_IDENTIFIER`: Tenant identifier (usually 'default')

Ensure your Fineract backend is properly configured with:
- CORS settings allowing your frontend domain
- Proper authentication mechanisms
- Database connectivity to PostgreSQL

## Environment Configuration

### Production Environment
- Uses `main` branch
- Connects to production Fineract instance
- Server switching disabled for security
- Optimized for performance

### Staging Environment
- Uses `develop` branch
- Connects to staging Fineract instance
- Server switching enabled for testing
- Debug features available

## Monitoring and Logs

### Railway Dashboard
- View deployment status
- Monitor application logs
- Check resource usage
- Manage environment variables

### GitHub Actions
- Build and deployment logs
- Test results
- Security audit reports

## Troubleshooting

### Common Issues

1. **Build Failures**
   - Check Node.js version compatibility (22.9.0)
   - Verify all dependencies are installed
   - Review build logs in Railway dashboard

2. **Fineract Connection Issues**
   - Verify `FINERACT_BASE_URL` is correct
   - Check CORS configuration on Fineract backend
   - Ensure Fineract backend is running and accessible

3. **Environment Variable Issues**
   - Verify all required environment variables are set
   - Check variable names match exactly
   - Review Railway environment configuration

### Debug Steps

1. **Check Application Logs**:
   ```bash
   railway logs
   ```

2. **Verify Environment Variables**:
   ```bash
   railway variables
   ```

3. **Test Local Build**:
   ```bash
   npm run build
   docker build -t mifos-x-test .
   docker run -p 8080:80 mifos-x-test
   ```

## Security Considerations

- All sensitive configuration stored as Railway environment variables
- GitHub secrets used for deployment tokens
- CORS properly configured between frontend and Fineract backend
- Regular security audits via npm audit in CI/CD pipeline

## Support

For deployment issues:
1. Check Railway dashboard logs
2. Review GitHub Actions workflow logs
3. Verify Fineract backend connectivity
4. Consult Railway documentation

## Next Steps

After successful deployment:
1. Configure custom domain (optional)
2. Set up monitoring and alerts
3. Configure backup strategies
4. Plan scaling based on usage
