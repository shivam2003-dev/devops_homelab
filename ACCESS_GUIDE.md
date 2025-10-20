# 🚀 DevOps Platform - Access Guide

## ✅ **CONFIRMED WORKING CREDENTIALS**

All credentials have been tested and are working correctly:

### **📊 DASHBOARDS**
- **Grafana**: http://localhost:3001 (admin/admin)
- **Prometheus**: http://localhost:9090 (no auth)
- **ArgoCD**: http://localhost:8080 (admin/g6hgu4t0utsTn1eR)

### **🔐 SECURITY**
- **Authelia**: http://localhost:8084 (admin/authelia)
- **Vault**: http://localhost:8200 (token: devops-lab-root-token)

### **🛠️ TOOLS**
- **Gitea**: http://localhost:4000 (root - first time setup)
- **Harbor**: http://localhost:8082 (admin/Harbor12345)

---

## 🔧 **TROUBLESHOOTING STEPS**

### If you get "Invalid password/username":

1. **Check Port Forwarding**:
   ```bash
   lsof -i :3001 -i :8080 -i :8082 -i :8084 -i :8200 -i :4000
   ```

2. **Restart Port Forwarding**:
   ```bash
   pkill -f "kubectl port-forward"
   ./port-forward-fixed.sh
   ```

3. **Check Service Status**:
   ```bash
   kubectl get pods -A | grep -E "grafana|argocd|harbor|authelia|vault|gitea"
   ```

4. **Test Credentials**:
   ```bash
   ./test-credentials.sh
   ```

---

## 🌐 **BROWSER ACCESS TIPS**

### **Grafana** (http://localhost:3001)
- Username: `admin`
- Password: `admin`
- If login fails, try refreshing the page

### **ArgoCD** (http://localhost:8080)
- Username: `admin`
- Password: `g6hgu4t0utsTn1eR`
- Should work immediately

### **Harbor** (http://localhost:8082)
- Username: `admin`
- Password: `Harbor12345`
- Login button should be visible

### **Authelia** (http://localhost:8084)
- Username: `admin`
- Password: `authelia`
- Should show login form

### **Vault** (http://localhost:8200)
- Use token: `devops-lab-root-token`
- Click "Token" and enter the token

### **Gitea** (http://localhost:4000)
- First time: Set up admin user
- Username: `root`
- Set your own password

---

## 🚨 **COMMON ISSUES**

1. **"Connection Refused"**: Port forwarding not running
2. **"Invalid Credentials"**: Try the exact credentials above
3. **"Page Not Found"**: Wrong URL path (use root paths)
4. **"Loading Forever"**: Service starting up, wait 2-3 minutes

---

## 📞 **QUICK FIXES**

```bash
# Restart everything
pkill -f "kubectl port-forward"
./port-forward-fixed.sh

# Check what's running
kubectl get pods -A

# Test credentials
./test-credentials.sh
```

**All services are confirmed working with the credentials above!** 🎉
