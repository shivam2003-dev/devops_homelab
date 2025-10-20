#!/bin/bash

echo "🚀 Setting up port forwarding for DevOps platform services..."
echo "Press Ctrl+C to stop all port forwarding"

# Kill any existing port forwards
pkill -f "kubectl port-forward" || true
sleep 2

# Function to start port forwarding in background
start_port_forward() {
    local service=$1
    local namespace=$2
    local local_port=$3
    local service_port=$4
    local name=$5
    
    echo "Starting port forward for $name on port $local_port..."
    kubectl port-forward -n $namespace service/$service $local_port:$service_port > /dev/null 2>&1 &
    sleep 1
}

# Start all port forwards with correct service names
start_port_forward "gitea-http" "devops-gitea" 4000 3000 "Gitea"
start_port_forward "vault" "devops-vault" 8200 8200 "Vault"
start_port_forward "argocd-server" "devops-argocd" 8080 80 "ArgoCD"
start_port_forward "authelia-svc" "devops-authelia" 8084 8080 "Authelia"
start_port_forward "harbor-portal" "devops-harbor" 8082 80 "Harbor"
start_port_forward "prometheus-server" "devops-monitoring" 9090 80 "Prometheus"
start_port_forward "grafana" "devops-monitoring" 3001 80 "Grafana"

echo ""
echo "🎉 DevOps Platform is now accessible at:"
echo ""
echo "📊 DASHBOARDS:"
echo "  • Grafana:     http://localhost:3001 (admin/admin123)"
echo "  • Prometheus:  http://localhost:9090"
echo "  • ArgoCD:      http://localhost:8080 (admin/g6hgu4t0utsTn1eR)"
echo ""
echo "🔐 SECURITY:"
echo "  • Authelia:    http://localhost:8084 (admin/authelia)"
echo "  • Vault:       http://localhost:8200 (token: devops-lab-root-token)"
echo ""
echo "🛠️  TOOLS:"
echo "  • Gitea:       http://localhost:4000"
echo "  • Harbor:      http://localhost:8082"
echo ""
echo "Press Ctrl+C to stop all port forwarding"

# Wait for user to stop
wait
