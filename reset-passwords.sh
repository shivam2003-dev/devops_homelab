#!/bin/bash

echo "🔐 Resetting all service passwords..."

# Reset Harbor admin password
echo "Resetting Harbor admin password to 'admin123'..."
kubectl patch secret harbor-core -n devops-harbor --type='json' -p='[{"op": "replace", "path": "/data/HARBOR_ADMIN_PASSWORD", "value": "'$(echo -n "admin123" | base64)'"}]'
kubectl rollout restart deployment/harbor-core -n devops-harbor

# Reset Grafana admin password
echo "Resetting Grafana admin password to 'admin123'..."
kubectl patch deployment grafana -n devops-monitoring --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/env/0/value", "value": "admin123"}]'

# Create new Authelia user with simple password
echo "Creating new Authelia user with password 'admin123'..."
kubectl patch configmap authelia-users -n devops-authelia --type='json' -p='[{"op": "replace", "path": "/data/users.yml", "value": "users:\n  admin:\n    displayname: '\''Admin User'\''\n    password: '\''$6$rounds=50000$BpLnfgDsc2WD8F2q$Zis.ixdg9s/UOJYrs56b5QEZFiZECu0qZVNsIYxBaNJ7ucIL.nlxVCT5tqh8KHG8X4tlwCFm5r6NTOZZ5qRFN/'\n    email: '\''admin@devops.localhost'\''\n    groups:\n      - '\''admin'\''\n      - '\''dev'\''\n  admin123:\n    displayname: '\''Admin123 User'\''\n    password: '\''$6$rounds=50000$BpLnfgDsc2WD8F2q$Zis.ixdg9s/UOJYrs56b5QEZFiZECu0qZVNsIYxBaNJ7ucIL.nlxVCT5tqh8KHG8X4tlwCFm5r6NTOZZ5qRFN/'\n    email: '\''admin123@devops.localhost'\''\n    groups:\n      - '\''admin'\''\n      - '\''dev'\''"}]'

# Restart services
echo "Restarting services..."
kubectl rollout restart deployment/authelia -n devops-authelia
kubectl rollout restart deployment/grafana -n devops-monitoring

echo "⏳ Waiting for services to restart..."
sleep 30

echo "✅ Password reset complete!"
echo ""
echo "🔑 NEW CREDENTIALS:"
echo "  • Harbor:     admin/admin123"
echo "  • Grafana:   admin/admin123"
echo "  • Authelia:  admin/authelia OR admin123/authelia"
echo "  • ArgoCD:    admin/g6hgu4t0utsTn1eR"
echo "  • Vault:     token: devops-lab-root-token"
echo "  • Gitea:     First-time setup (no default password)"
echo ""
echo "🌐 Access URLs:"
echo "  • Harbor:     http://localhost:8082"
echo "  • Grafana:    http://localhost:3001"
echo "  • Authelia:   http://localhost:8084"
echo "  • ArgoCD:     http://localhost:8080"
echo "  • Vault:      http://localhost:8200"
echo "  • Gitea:      http://localhost:4000"
