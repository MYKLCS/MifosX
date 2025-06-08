# GitHub Secrets Setup for MifosX Railway Deployment

## Overview

This guide helps you configure GitHub Secrets for automated Railway deployment. Your GitHub Actions workflow will automatically deploy to Railway when you push to the `main` or `develop` branches.

## Required GitHub Secrets

Configure these 3 secrets in your GitHub repository to enable automated Railway deployment:

### 1. RAILWAY_TOKEN

- **Purpose**: Authenticates GitHub Actions with Railway
- **How to get**: Generate from [Railway Dashboard → Account Settings → Tokens](https://railway.app/account/tokens)
- **Required**: Yes

### 2. RAILWAY_PRODUCTION_PROJECT_ID

- **Purpose**: Identifies your production Railway project
- **Value**: `71e46957-dc0f-4e52-80ba-f1edb3e11666`
- **Required**: Yes

### 3. RAILWAY_PRODUCTION_SERVICE_ID

- **Purpose**: Identifies your MifosX service in Railway
- **Value**: `a2567a8b-16bc-4089-b82b-ec7547450707`
- **Required**: Yes

## Quick Setup Guide

### Step 1: Generate Railway Token

1. Open [Railway Dashboard → Account Settings → Tokens](https://railway.app/account/tokens)
2. Click **"Create New Token"**
3. Name it: `GitHub Actions - MifosX`
4. **Copy the token** (save it securely!)

### Step 2: Configure GitHub Secrets

1. Go to [GitHub Repository Settings → Secrets](https://github.com/MYKLCS/MifosX/settings/secrets/actions)
2. Click **"New repository secret"** for each secret below:
3. Click **"New repository secret"** for each secret below:

**Secret 1: RAILWAY_TOKEN**

- Name: `RAILWAY_TOKEN`
- Value: `[The token you generated in Step 1]`

**Secret 2: RAILWAY_PRODUCTION_PROJECT_ID**

- Name: `RAILWAY_PRODUCTION_PROJECT_ID`
- Value: `71e46957-dc0f-4e52-80ba-f1edb3e11666`

**Secret 3: RAILWAY_PRODUCTION_SERVICE_ID**

- Name: `RAILWAY_PRODUCTION_SERVICE_ID`
- Value: `a2567a8b-16bc-4089-b82b-ec7547450707`

### Step 3: Test Deployment

1. Make a small change to any file (e.g., add a comment to README.md)
2. Commit and push to main branch:
   ```bash
   git add .
   git commit -m "test: trigger Railway deployment"
   git push origin main
   ```
3. Watch the deployment at: [GitHub Actions](https://github.com/MYKLCS/MifosX/actions)

## Current Deployment Information

- **Project**: fineract working
- **Frontend URL**: https://mifosx-production.up.railway.app
- **Backend URL**: https://fineract-production.up.railway.app
- **GitHub Repository**: https://github.com/MYKLCS/MifosX

## Troubleshooting

### Common Issues:

- **"railway login failed"**: Check RAILWAY_TOKEN is correctly configured
- **"project not found"**: Verify RAILWAY_PRODUCTION_PROJECT_ID is correct
- **"service not found"**: Verify RAILWAY_PRODUCTION_SERVICE_ID is correct

### Support:

- Check GitHub Actions logs: Repository → Actions tab → Select workflow run
- Check Railway logs: [Railway Dashboard](https://railway.app/dashboard) → Your project → Service → Deployments

## Security Notes

- Never commit Railway tokens to your repository
- Tokens should only be stored in GitHub Secrets
- Regularly rotate your Railway tokens for security
