# DevOps Lab Makefile
# Provides shortcuts for common operations

.PHONY: help up down status logs clean port-forward stop-port-forward

# Default target
help:
	@echo "DevOps Lab - Available Commands:"
	@echo ""
	@echo "  make up          - Deploy the entire DevOps platform"
	@echo "  make down         - Remove the DevOps platform"
	@echo "  make status       - Show status of all components"
	@echo "  make logs         - Show logs for all components"
	@echo "  make port-forward - Start port forwarding for all services"
	@echo "  make stop-port-forward - Stop port forwarding"
	@echo "  make clean        - Clean up everything (cluster, data, etc.)"
	@echo "  make help         - Show this help message"
	@echo ""

# Deploy the entire platform
up:
	@echo "🚀 Starting DevOps Lab deployment..."
	@./deploy.sh

# Remove the platform
down:
	@echo "🛑 Stopping DevOps Lab..."
	@kubectl delete namespace devops-gitea devops-argocd devops-vault devops-harbor devops-sonarqube devops-monitoring devops-ingress --ignore-not-found=true
	@echo "✅ DevOps Lab stopped"

# Show status of all components
status:
	@echo "📊 DevOps Lab Status:"
	@echo ""
	@echo "Namespaces:"
	@kubectl get namespaces | grep devops || echo "No devops namespaces found"
	@echo ""
	@echo "Pods:"
	@kubectl get pods -A | grep devops || echo "No devops pods found"
	@echo ""
	@echo "Services:"
	@kubectl get services -A | grep devops || echo "No devops services found"

# Show logs for all components
logs:
	@echo "📋 DevOps Lab Logs:"
	@echo ""
	@echo "=== Gitea Logs ==="
	@kubectl logs -l app=gitea -n devops-gitea --tail=10 || echo "No Gitea logs found"
	@echo ""
	@echo "=== ArgoCD Logs ==="
	@kubectl logs -l app=argocd-server -n devops-argocd --tail=10 || echo "No ArgoCD logs found"
	@echo ""
	@echo "=== Vault Logs ==="
	@kubectl logs -l app=vault -n devops-vault --tail=10 || echo "No Vault logs found"
	@echo ""
	@echo "=== Harbor Logs ==="
	@kubectl logs -l app=harbor-core -n devops-harbor --tail=10 || echo "No Harbor logs found"
	@echo ""
	@echo "=== SonarQube Logs ==="
	@kubectl logs -l app=sonarqube -n devops-sonarqube --tail=10 || echo "No SonarQube logs found"
	@echo ""
	@echo "=== Prometheus Logs ==="
	@kubectl logs -l app=prometheus -n devops-monitoring --tail=10 || echo "No Prometheus logs found"
	@echo ""
	@echo "=== Grafana Logs ==="
	@kubectl logs -l app=grafana -n devops-monitoring --tail=10 || echo "No Grafana logs found"

# Start port forwarding
port-forward:
	@echo "🔗 Starting port forwarding..."
	@kubectl port-forward -n devops-gitea svc/gitea-http 3000:3000 &
	@kubectl port-forward -n devops-argocd svc/argocd-server 8080:80 &
	@kubectl port-forward -n devops-vault svc/vault 8200:8200 &
	@kubectl port-forward -n devops-sonarqube svc/sonarqube-sonarqube 9000:9000 &
	@kubectl port-forward -n devops-monitoring svc/prometheus-server 9090:80 &
	@kubectl port-forward -n devops-monitoring svc/grafana 3001:80 &
	@kubectl port-forward -n devops-harbor svc/harbor 8082:80 &
	@echo "✅ Port forwarding started"
	@echo "Access URLs:"
	@echo "  Gitea:        http://localhost:3000"
	@echo "  ArgoCD:       http://localhost:8080"
	@echo "  Vault:        http://localhost:8200"
	@echo "  SonarQube:    http://localhost:9000"
	@echo "  Prometheus:   http://localhost:9090"
	@echo "  Grafana:      http://localhost:3001"
	@echo "  Harbor:       http://localhost:8082"

# Stop port forwarding
stop-port-forward:
	@echo "🛑 Stopping port forwarding..."
	@pkill -f "kubectl port-forward" || true
	@echo "✅ Port forwarding stopped"

# Clean up everything
clean:
	@echo "🧹 Cleaning up DevOps Lab..."
	@make stop-port-forward
	@kind delete cluster --name devops-lab || true
	@echo "✅ Cleanup complete"

# Quick access commands
gitea-logs:
	@kubectl logs -l app=gitea -n devops-gitea -f

argocd-logs:
	@kubectl logs -l app=argocd-server -n devops-argocd -f

vault-logs:
	@kubectl logs -l app=vault -n devops-vault -f

harbor-logs:
	@kubectl logs -l app=harbor-core -n devops-harbor -f

sonarqube-logs:
	@kubectl logs -l app=sonarqube -n devops-sonarqube -f

prometheus-logs:
	@kubectl logs -l app=prometheus -n devops-monitoring -f

grafana-logs:
	@kubectl logs -l app=grafana -n devops-monitoring -f
