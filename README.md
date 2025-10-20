# 🚀 DevOps Lab - Complete Local DevOps Platform

A comprehensive self-hosted DevOps platform that can be run locally using Docker Desktop with Kubernetes enabled. This platform simulates a full production DevOps stack with all essential tools for modern software development and operations.

## 🏗️ Architecture Overview

The DevOps Lab includes the following components:

### 🔧 Core DevOps Tools
- **Gitea** - Git server for source code management
- **ArgoCD** - GitOps continuous deployment  
- **Argo Workflows** - CI/CD pipeline automation
- **HashiCorp Vault** - Secrets management
- **Harbor** - Container registry
- **SonarQube** - Code quality analysis

### 📊 Infrastructure & Monitoring
- **NetBox** - Infrastructure inventory management
- **Prometheus** - Metrics collection and monitoring
- **Grafana** - Metrics visualization and dashboards
- **Loki** - Log aggregation
- **Alertmanager** - Alert management
- **Beyla** - eBPF-based application monitoring
- **Alloy** - Observability data collection

### 🔐 Security & Access
- **Authelia** - Single Sign-On (SSO) and authentication
- **Nginx Ingress Controller** - Load balancing and routing

## 🚀 Quick Start

### Prerequisites

- **Docker Desktop** with Kubernetes enabled
- **kubectl** (Kubernetes CLI)
- **helm** (Helm package manager)

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd devops-lab
   ```

2. **Deploy the entire platform:**
   ```bash
   ./deploy.sh
   ```

3. **Start port forwarding:**
   ```bash
   ./port-forward.sh
   ```

4. **Access the services:**
   - **Grafana**: http://localhost:3001 (admin/admin123)
   - **ArgoCD**: http://localhost:8080 (admin/g6hgu4t0utsTn1eR)
   - **Harbor**: http://localhost:8082 (admin/admin123)
   - **Authelia**: http://localhost:8084 (admin/authelia)
   - **Vault**: http://localhost:8200 (token: devops-lab-root-token)
   - **Gitea**: http://localhost:4000 (first-time setup)
   - **Prometheus**: http://localhost:9090 (no auth)

## 📋 Service Status

### ✅ Working Services

| Service | URL | Username | Password | Status |
|---------|-----|----------|----------|--------|
| **Grafana** | http://localhost:3001 | admin | admin123 | ✅ Working |
| **ArgoCD** | http://localhost:8080 | admin | g6hgu4t0utsTn1eR | ✅ Working |
| **Harbor** | http://localhost:8082 | admin | admin123 | ✅ Working |
| **Authelia** | http://localhost:8084 | admin | authelia | ✅ Working |
| **Vault** | http://localhost:8200 | - | devops-lab-root-token | ✅ Working |
| **Gitea** | http://localhost:4000 | root | (first-time setup) | ✅ Working |
| **Prometheus** | http://localhost:9090 | - | (no auth) | ✅ Working |

### 🔧 Services with Issues

| Service | Status | Issue | Solution |
|---------|--------|-------|----------|
| **NetBox** | ⚠️ Partial | PostgreSQL image issues | Use simplified configuration |
| **SonarQube** | ⚠️ Partial | Image pull issues | Use simplified configuration |
| **Beyla** | ⚠️ Partial | eBPF compatibility | Check system requirements |
| **Alloy** | ⚠️ Partial | Image pull issues | Use stable image versions |

## 🛠️ Management Commands

### Start All Services
```bash
./port-forward.sh
```

### Stop All Port Forwarding
```bash
pkill -f "kubectl port-forward"
```

### Check Service Status
```bash
kubectl get pods -A | grep -E "gitea|argocd|grafana|prometheus|vault|harbor|authelia"
```

### Reset Passwords
```bash
./reset-passwords.sh
```

### Test All Credentials
```bash
./test-credentials.sh
```

## 📁 Project Structure

```
devops-lab/
├── deploy.sh                    # Main deployment script
├── port-forward.sh              # Port forwarding script
├── reset-passwords.sh           # Password reset script
├── test-credentials.sh          # Credential testing script
├── CREDENTIALS.md              # Complete credentials reference
├── k8s/                        # Kubernetes manifests
│   ├── gitea/                  # Git server
│   ├── argocd/                 # GitOps
│   ├── vault/                  # Secrets management
│   ├── harbor/                 # Container registry
│   ├── sonarqube/              # Code quality
│   ├── monitoring/              # Prometheus, Grafana, Loki
│   ├── ingress/                # Nginx Ingress
│   ├── argo-workflows/         # CI/CD
│   ├── netbox/                 # Infrastructure inventory
│   └── authelia/               # SSO
└── README.md                   # This file
```

## 🔧 Configuration Details

### Port Forwarding

All services are accessible via localhost with the following ports:

- **3001** - Grafana
- **4000** - Gitea  
- **8080** - ArgoCD
- **8082** - Harbor
- **8084** - Authelia
- **8200** - Vault
- **9090** - Prometheus

### Persistent Storage

The following services use persistent storage:

- **Gitea** - Git repositories and data
- **Harbor** - Container images and metadata
- **Vault** - Secrets and configuration
- **Grafana** - Dashboards and configuration
- **NetBox** - Infrastructure data
- **SonarQube** - Code analysis data

### Security Configuration

- **Authelia** provides SSO for all services
- **Vault** manages secrets and certificates
- **Harbor** provides secure container registry
- All services use self-signed certificates for local development

## 🚨 Troubleshooting

### Common Issues

1. **"Connection Refused"**
   - Check if port forwarding is running: `lsof -i :PORT`
   - Restart port forwarding: `./port-forward.sh`

2. **"Invalid Credentials"**
   - Use the exact credentials from `FINAL_CREDENTIALS.md`
   - Reset passwords: `./reset-passwords.sh`

3. **"Page Not Found"**
   - Use root paths (e.g., http://localhost:8082, not http://localhost:8082/harbor)
   - Check service status: `kubectl get pods -A`

4. **"Loading Forever"**
   - Wait 2-3 minutes for services to fully start
   - Check pod logs: `kubectl logs -n NAMESPACE deployment/SERVICE-NAME`

### Service-Specific Issues

#### Harbor Login Issues
- Wait for Harbor to fully restart (2-3 minutes)
- Use username: `admin`, password: `admin123`
- Clear browser cache

#### Authelia "User State" Error
- Clear browser cache and cookies
- Try incognito/private mode
- Wait for Authelia to fully restart

#### Grafana Login Issues
- Use username: `admin`, password: `admin123`
- Wait for Grafana to fully restart (1-2 minutes)

## 🔄 Development Workflow

### 1. Code Development
- Use **Gitea** for Git repositories
- Set up webhooks for automatic builds

### 2. Code Quality
- **SonarQube** analyzes code quality
- **Argo Workflows** runs CI/CD pipelines

### 3. Container Management
- **Harbor** stores container images
- **ArgoCD** deploys applications

### 4. Monitoring & Observability
- **Prometheus** collects metrics
- **Grafana** visualizes data
- **Loki** aggregates logs
- **Beyla** provides eBPF monitoring

### 5. Security & Access
- **Authelia** provides SSO
- **Vault** manages secrets
- **NetBox** tracks infrastructure

## 📚 Additional Resources

### Documentation Files
- `CREDENTIALS.md` - Complete credentials reference

### Scripts
- `deploy.sh` - Main deployment script
- `port-forward.sh` - Port forwarding management
- `reset-passwords.sh` - Password reset utility
- `test-credentials.sh` - Credential testing

## 🎯 Next Steps

### For Production Use
1. **Change all default passwords**
2. **Configure proper SSL certificates**
3. **Set up external DNS**
4. **Configure backup strategies**
5. **Implement proper RBAC**

### For Development
1. **Set up Git repositories in Gitea**
2. **Configure ArgoCD applications**
3. **Create monitoring dashboards**
4. **Set up CI/CD pipelines**

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

If you encounter issues:

1. Check the troubleshooting section above
2. Review the service logs: `kubectl logs -n NAMESPACE deployment/SERVICE-NAME`
3. Check service status: `kubectl get pods -A`
4. Verify port forwarding: `lsof -i :PORT`

---

**🎉 Enjoy your complete DevOps platform!**

**Last Updated**: October 2025  
**Status**: Core services operational ✅  
**Platform**: Docker Desktop Kubernetes