# 🐳 Docker Hub Secrets Setup - Step by Step

## 🎯 **Quick Setup Guide**

Follow these exact steps to configure Docker Hub login for your GitHub Actions workflow:

### **Step 1: Open GitHub Secrets Page**

Click this link: [**Configure GitHub Secrets**](https://github.com/MYKLCS/MifosX/settings/secrets/actions)

### **Step 2: Generate Docker Hub Access Token**

1. **Go to Docker Hub Security Settings**:
   👉 [**Docker Hub Security**](https://hub.docker.com/settings/security)

2. **Create New Access Token**:
   - Click **"New Access Token"**
   - **Name**: `GitHub Actions - MifosX`
   - **Permissions**: Select **"Read, Write, Delete"**
   - Click **"Generate"**
   - **COPY THE TOKEN IMMEDIATELY** (you won't see it again!)

### **Step 3: Add 3 GitHub Secrets**

Go back to: https://github.com/MYKLCS/MifosX/settings/secrets/actions

Add these **3 secrets**:

#### 1. **DOCKER_USER**

- **Name**: `DOCKER_USER`
- **Value**: Your Docker Hub username (e.g., `myklcs`)

#### 2. **DOCKER_PASSWORD**

- **Name**: `DOCKER_PASSWORD`
- **Value**: The access token you just generated (NOT your Docker Hub password!)

#### 3. **DOCKER_ORGANIZATION**

- **Name**: `DOCKER_ORGANIZATION`
- **Value**: Where to publish images (usually your Docker Hub username, e.g., `myklcs`)

## 🧪 **Step 4: Test the Setup**

After adding the secrets, test the Docker workflow:

```bash
# Make a small change to trigger Docker build
echo "# Docker test $(date)" >> README.md
git add README.md
git commit -m "test: trigger Docker Hub build"
git push origin dev
```

## 📋 **Step 5: Verify Success**

1. **Watch GitHub Actions**: https://github.com/MYKLCS/MifosX/actions
2. **Check Docker Hub**: Look for new images in your Docker Hub repository
3. **Expected tags**: `[your-org]/web-app:dev`, `[your-org]/web-app:latest`

## ❓ **Common Issues & Solutions**

### **"Login failed" Error**

- ✅ Make sure you used an **access token**, not your Docker Hub password
- ✅ Check that the token has **"Read, Write, Delete"** permissions
- ✅ Verify your **DOCKER_USER** is exactly your Docker Hub username

### **"Repository not found" Error**

- ✅ Make sure **DOCKER_ORGANIZATION** matches your Docker Hub username/organization
- ✅ The repository will be created automatically on first push

### **"Secrets not configured" Message**

- ✅ Check that all 3 secrets are added with exact names: `DOCKER_USER`, `DOCKER_PASSWORD`, `DOCKER_ORGANIZATION`
- ✅ No extra spaces or typos in secret names

## 🎉 **Expected Results**

Once configured successfully, every push to `dev` branch will:

- ✅ Build Docker image for both `linux/amd64` and `linux/arm64`
- ✅ Push to Docker Hub with smart tags
- ✅ Show success in GitHub Actions
- ✅ Make images available for deployment

---

## 🔗 **Quick Links**

| Resource                | URL                                                       |
| ----------------------- | --------------------------------------------------------- |
| **Configure Secrets**   | https://github.com/MYKLCS/MifosX/settings/secrets/actions |
| **Docker Hub Security** | https://hub.docker.com/settings/security                  |
| **GitHub Actions**      | https://github.com/MYKLCS/MifosX/actions                  |
| **Your Docker Hub**     | https://hub.docker.com/u/[your-username]                  |

**⏱️ Setup Time**: 5-10 minutes total
**🎯 Result**: Automated Docker image publishing on every git push!
