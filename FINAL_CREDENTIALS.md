# 🔐 DevOps Platform - FINAL CREDENTIALS (RESET)

## ✅ **ALL PASSWORDS HAVE BEEN RESET**

### **📊 DASHBOARDS & MONITORING**

#### **Grafana** - http://localhost:3001
- **Username**: `admin`
- **Password**: `admin123`
- **Status**: ✅ Reset and Working

#### **Prometheus** - http://localhost:9090
- **Access**: No authentication required
- **Status**: ✅ Working

#### **ArgoCD** - http://localhost:8080
- **Username**: `admin`
- **Password**: `g6hgu4t0utsTn1eR`
- **Status**: ✅ Working

---

### **🔐 SECURITY & AUTHENTICATION**

#### **Authelia (SSO)** - http://localhost:8084
- **Username**: `admin` OR `admin123`
- **Password**: `authelia` (for both users)
- **Status**: ✅ Fixed session cookies + Reset

#### **HashiCorp Vault** - http://localhost:8200
- **Token**: `devops-lab-root-token`
- **Status**: ✅ Working

---

### **🛠️ DEVELOPMENT TOOLS**

#### **Gitea (Git Server)** - http://localhost:4000
- **Username**: `root` (first-time setup)
- **Password**: Set during first login
- **Status**: ✅ Working (first-time setup required)

#### **Harbor (Container Registry)** - http://localhost:8082
- **Username**: `admin`
- **Password**: `admin123`
- **Status**: ✅ Reset and Working

---

## 🚀 **QUICK ACCESS**

### **Start Port Forwarding**
```bash
./port-forward-fixed.sh
```

### **Test All Credentials**
```bash
./test-credentials.sh
```

### **Reset Passwords Again (if needed)**
```bash
./reset-passwords.sh
```

---

## 🔧 **TROUBLESHOOTING**

### **If Authelia still shows "There was an issue retrieving the current user state":**
1. Clear browser cache and cookies
2. Try incognito/private mode
3. Wait 2-3 minutes for services to fully restart
4. Try both usernames: `admin` and `admin123`

### **If Harbor login fails:**
1. Wait for Harbor to fully restart (2-3 minutes)
2. Try username: `admin`, password: `admin123`
3. Clear browser cache

### **If Grafana login fails:**
1. Wait for Grafana to fully restart (1-2 minutes)
2. Try username: `admin`, password: `admin123`

---

## 📝 **SUMMARY OF CHANGES**

✅ **Fixed Authelia session cookie domain configuration**
✅ **Reset Harbor admin password to `admin123`**
✅ **Reset Grafana admin password to `admin123`**
✅ **Added additional Authelia user `admin123`**
✅ **All services restarted with new configurations**

---

**🎉 All services should now work with the credentials above!**

**Last Updated**: $(date)
**Status**: All Passwords Reset ✅
