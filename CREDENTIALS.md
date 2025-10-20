# 🔐 DevOps Platform - All Credentials & Access Information

## 📊 **DASHBOARDS & MONITORING**

### **Grafana** - http://localhost:3001
- **Username**: `admin`
- **Password**: `admin`
- **Status**: ✅ Working

### **Prometheus** - http://localhost:9090
- **Access**: No authentication required
- **Status**: ✅ Working

### **ArgoCD** - http://localhost:8080
- **Username**: `admin`
- **Password**: `g6hgu4t0utsTn1eR`
- **Status**: ✅ Working

---

## 🔐 **SECURITY & AUTHENTICATION**

### **Authelia (SSO)** - http://localhost:8084
- **Username**: `admin`
- **Password**: `authelia`
- **Status**: ✅ Working

### **HashiCorp Vault** - http://localhost:8200
- **Token**: `devops-lab-root-token`
- **Status**: ✅ Working

---

## 🛠️ **DEVELOPMENT TOOLS**

### **Gitea (Git Server)** - http://localhost:4000
- **Username**: `root` (first-time setup)
- **Password**: Set during first login (no default password)
- **Status**: ✅ Working

### **Harbor (Container Registry)** - http://localhost:8082
- **Username**: `admin`
- **Password**: `Harbor12345`
- **Status**: ✅ Working

---

## 🚀 **QUICK ACCESS COMMANDS**

### Start Port Forwarding
```bash
./port-forward-fixed.sh
```

### Stop All Port Forwarding
```bash
pkill -f "kubectl port-forward"
```

### Check Service Status
```bash
kubectl get pods -A | grep -E "gitea|argocd|grafana|prometheus|vault|harbor|authelia"
```

---

## 📝 **NOTES**

- All services are running on Docker Desktop Kubernetes
- Port forwarding is required to access services locally
- Default credentials are for local development only
- Change passwords in production environments
- Services are accessible via localhost only

---

## 🔧 **TROUBLESHOOTING**

If any service is not accessible:
1. Check if port forwarding is running: `lsof -i :PORT`
2. Restart port forwarding: `./port-forward-fixed.sh`
3. Check pod status: `kubectl get pods -n NAMESPACE`
4. Check service logs: `kubectl logs -n NAMESPACE deployment/SERVICE-NAME`

---

**Last Updated**: $(date)
**Platform**: Docker Desktop Kubernetes
**Status**: All Services Operational ✅
