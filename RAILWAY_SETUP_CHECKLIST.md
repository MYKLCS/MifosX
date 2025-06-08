# Railway Setup Checklist for Mifos X Web App

Use this checklist to ensure your Railway deployment is properly configured.

## ✅ Pre-Deployment Checklist

### Railway Platform Setup
- [ ] Railway account created and verified
- [ ] Railway CLI installed (`npm install -g @railway/cli`)
- [ ] Logged in to Railway (`railway login`)
- [ ] Production project created on Railway
- [ ] Staging project created on Railway
- [ ] Project IDs noted for GitHub secrets

### GitHub Repository Setup
- [ ] Repository has Railway deployment files committed
- [ ] GitHub Actions enabled for the repository
- [ ] Repository secrets configured (see below)

### Required GitHub Secrets
- [ ] `RAILWAY_TOKEN` - Your Railway API token
- [ ] `RAILWAY_PRODUCTION_PROJECT_ID` - Production project ID
- [ ] `RAILWAY_PRODUCTION_SERVICE_ID` - Production service ID (if using specific service)
- [ ] `RAILWAY_STAGING_PROJECT_ID` - Staging project ID
- [ ] `RAILWAY_STAGING_SERVICE_ID` - Staging service ID (if using specific service)

### Fineract Backend Setup
- [ ] Fineract backend deployed and running on Railway
- [ ] PostgreSQL database configured and connected to Fineract
- [ ] Fineract API endpoints accessible
- [ ] CORS configured to allow frontend domain
- [ ] Authentication mechanisms properly configured

## ✅ Environment Configuration

### Production Environment Variables (Railway Dashboard)
- [ ] `NODE_ENV=production`
- [ ] `FINERACT_BASE_URL=https://your-fineract-production.railway.app/fineract-provider`
- [ ] `FINERACT_TENANT_IDENTIFIER=default`
- [ ] `DEFAULT_LANGUAGE=en-US`
- [ ] `SUPPORTED_LANGUAGES=en-US,es-MX,fr-FR,pt-PT,sw-SW,lt-LT,lv-LV`
- [ ] `ALLOW_SERVER_SWITCHING=false`
- [ ] `PRELOAD_CLIENTS_ON_LOGIN=true`
- [ ] `DEFAULT_THEME=default`
- [ ] `ENABLE_MULTITENANT=false`
- [ ] `DEMO_CREDENTIALS_ENABLED=false`
- [ ] `PASSWORD_VALIDATION_ENABLED=true`
- [ ] `OAUTH_ENABLED=false`
- [ ] `SELF_SERVICE_ENABLED=true`
- [ ] `SHOW_LANGUAGE_SELECTOR=true`
- [ ] `SHOW_THEME_PICKER=true`

### Staging Environment Variables (Railway Dashboard)
- [ ] `NODE_ENV=staging`
- [ ] `FINERACT_BASE_URL=https://your-fineract-staging.railway.app/fineract-provider`
- [ ] `FINERACT_TENANT_IDENTIFIER=default`
- [ ] `ALLOW_SERVER_SWITCHING=true` (for testing)
- [ ] Other variables same as production

## ✅ Deployment Files

### GitHub Actions Workflow
- [ ] `.github/workflows/deploy-railway.yml` exists
- [ ] Workflow triggers on correct branches (main, develop)
- [ ] Test and security jobs configured
- [ ] Environment-specific deployment jobs configured

### Railway Configuration
- [ ] `railway.json` exists and configured
- [ ] Docker build settings correct
- [ ] Environment-specific variables defined
- [ ] Deployment settings appropriate

### Scripts
- [ ] `scripts/deploy-railway.sh` exists and is executable
- [ ] Script has proper environment handling
- [ ] Error handling implemented

### Documentation
- [ ] `RAILWAY_DEPLOYMENT.md` exists with complete setup instructions
- [ ] This checklist (`RAILWAY_SETUP_CHECKLIST.md`) exists

## ✅ Testing and Validation

### Local Testing
- [ ] Application builds successfully (`npm run build`)
- [ ] Tests pass (`npm run test`)
- [ ] Linting passes (`npm run lint`)
- [ ] Docker build works (`docker build -t mifos-x-test .`)
- [ ] Docker container runs (`docker run -p 8080:80 mifos-x-test`)

### Connectivity Testing
- [ ] Can reach Fineract backend from local environment
- [ ] API endpoints return expected responses
- [ ] Authentication flow works
- [ ] CORS allows frontend requests

## ✅ First Deployment

### Staging Deployment
- [ ] Push to `develop` branch triggers staging deployment
- [ ] GitHub Actions workflow completes successfully
- [ ] Application accessible on Railway staging URL
- [ ] Fineract connectivity working in staging
- [ ] Basic functionality tested

### Production Deployment
- [ ] Push to `main` branch triggers production deployment
- [ ] GitHub Actions workflow completes successfully
- [ ] Application accessible on Railway production URL
- [ ] Fineract connectivity working in production
- [ ] Full functionality tested

## ✅ Post-Deployment

### Monitoring Setup
- [ ] Railway dashboard monitoring configured
- [ ] Application logs accessible and readable
- [ ] Performance metrics being tracked
- [ ] Error reporting configured (if desired)

### Domain Configuration (Optional)
- [ ] Custom domain configured in Railway
- [ ] SSL certificate properly configured
- [ ] DNS records updated
- [ ] Domain accessible and secure

### Security Review
- [ ] All sensitive data stored as environment variables
- [ ] No hardcoded secrets in code
- [ ] CORS properly configured
- [ ] HTTPS enforced
- [ ] Security headers configured

## ✅ Operational Procedures

### Deployment Process
- [ ] Team understands branch-based deployment
- [ ] Code review process in place
- [ ] Testing procedures documented
- [ ] Rollback procedures documented

### Monitoring and Maintenance
- [ ] Log monitoring procedures established
- [ ] Performance monitoring in place
- [ ] Update procedures documented
- [ ] Backup strategies implemented

## 🚨 Troubleshooting Quick Reference

### Common Issues and Solutions

1. **Build Failures**
   - Check Node.js version (should be 22.9.0)
   - Verify all dependencies installed
   - Review build logs in Railway dashboard

2. **Deployment Failures**
   - Check GitHub secrets are correctly set
   - Verify Railway project IDs are correct
   - Review GitHub Actions logs

3. **Application Not Loading**
   - Check Railway service status
   - Verify environment variables are set
   - Review application logs

4. **Fineract Connection Issues**
   - Verify `FINERACT_BASE_URL` is correct and accessible
   - Check CORS configuration
   - Test API endpoints directly

### Getting Help
- Railway documentation: https://docs.railway.app/
- Railway community: https://railway.app/help
- GitHub Actions documentation: https://docs.github.com/en/actions
- Mifos community: https://mifosforge.jira.com/

---

## Notes
- Complete this checklist before attempting deployment
- Keep this checklist updated as your setup evolves
- Share with team members involved in deployment
- Review periodically to ensure best practices
