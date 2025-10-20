#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
CLUSTER_NAME="devops-lab"
NAMESPACE_PREFIX="devops"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load environment variables
if [ -f "${SCRIPT_DIR}/.env" ]; then
    source "${SCRIPT_DIR}/.env"
fi

# Default values
export GITEA_ADMIN_USER="${GITEA_ADMIN_USER:-admin}"
export GITEA_ADMIN_PASSWORD="${GITEA_ADMIN_PASSWORD:-$(openssl rand -base64 12)}"
export GITEA_ADMIN_EMAIL="${GITEA_ADMIN_EMAIL:-admin@localhost}"

export ARGOCD_ADMIN_PASSWORD="${ARGOCD_ADMIN_PASSWORD:-$(openssl rand -base64 12)}"

export VAULT_ROOT_TOKEN="${VAULT_ROOT_TOKEN:-$(openssl rand -base64 12)}"

export HARBOR_ADMIN_PASSWORD="${HARBOR_ADMIN_PASSWORD:-$(openssl rand -base64 12)}"

export SONARQUBE_ADMIN_PASSWORD="${SONARQUBE_ADMIN_PASSWORD:-$(openssl rand -base64 12)}"

export GRAFANA_ADMIN_PASSWORD="${GRAFANA_ADMIN_PASSWORD:-$(openssl rand -base64 12)}"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check dependencies
check_dependencies() {
    print_status "Checking dependencies..."
    
    local missing_deps=()
    
    if ! command_exists docker; then
        missing_deps+=("docker")
    fi
    
    if ! command_exists kubectl; then
        missing_deps+=("kubectl")
    fi
    
    if ! command_exists helm; then
        missing_deps+=("helm")
    fi
    
    # kind is optional - we'll use Docker Desktop Kubernetes
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing dependencies: ${missing_deps[*]}"
        print_error "Please install the missing dependencies and try again."
        exit 1
    fi
    
    print_success "All dependencies are available"
}

# Function to create or use existing cluster
setup_cluster() {
    print_status "Setting up Kubernetes cluster..."
    
    # Check if Docker Desktop Kubernetes is available
    if kubectl cluster-info &>/dev/null; then
        print_success "Using existing Kubernetes cluster (Docker Desktop)"
        kubectl config current-context
    else
        print_error "No Kubernetes cluster found. Please enable Kubernetes in Docker Desktop."
        print_error "Go to Docker Desktop > Settings > Kubernetes > Enable Kubernetes"
        exit 1
    fi
    
    print_success "Cluster setup complete"
}

# Function to add Helm repositories
add_helm_repos() {
    print_status "Adding Helm repositories..."
    
    # Add repositories only if they don't exist
    helm repo add argo https://argoproj.github.io/argo-helm 2>/dev/null || true
    helm repo add hashicorp https://helm.releases.hashicorp.com 2>/dev/null || true
    helm repo add harbor https://helm.goharbor.io 2>/dev/null || true
    helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube 2>/dev/null || true
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 2>/dev/null || true
    helm repo add grafana https://grafana.github.io/helm-charts 2>/dev/null || true
    helm repo add gitea-charts https://dl.gitea.io/charts/ 2>/dev/null || true
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx 2>/dev/null || true
    helm repo add loki https://grafana.github.io/loki/charts 2>/dev/null || true
    
    helm repo update
    
    print_success "Helm repositories added"
}

# Function to create namespaces
create_namespaces() {
    print_status "Creating namespaces..."
    
    local namespaces=(
        "${NAMESPACE_PREFIX}-gitea"
        "${NAMESPACE_PREFIX}-argocd"
        "${NAMESPACE_PREFIX}-vault"
        "${NAMESPACE_PREFIX}-harbor"
        "${NAMESPACE_PREFIX}-sonarqube"
        "${NAMESPACE_PREFIX}-monitoring"
        "${NAMESPACE_PREFIX}-ingress"
    )
    
    for ns in "${namespaces[@]}"; do
        kubectl create namespace "$ns" --dry-run=client -o yaml | kubectl apply -f -
    done
    
    print_success "Namespaces created"
}

# Function to deploy component
deploy_component() {
    local component=$1
    local namespace=$2
    
    print_status "Deploying ${component}..."
    
    if [ -d "${SCRIPT_DIR}/k8s/${component}" ]; then
        # Apply all YAML files in the component directory (excluding kustomization and applications files)
        for yaml_file in "${SCRIPT_DIR}/k8s/${component}"/*.yaml; do
            if [ -f "$yaml_file" ] && [[ ! "$yaml_file" =~ kustomization\.yaml$ ]] && [[ ! "$yaml_file" =~ applications\.yaml$ ]]; then
                kubectl apply -f "$yaml_file"
            fi
        done
        
        # Wait for deployment to be ready
        print_status "Waiting for ${component} to be ready..."
        # Try different label selectors
        kubectl wait --for=condition=available --timeout=300s deployment -l app="${component}" -n "$namespace" || \
        kubectl wait --for=condition=available --timeout=300s deployment -l app.kubernetes.io/name="${component}" -n "$namespace" || \
        kubectl wait --for=condition=available --timeout=300s deployment -l app.kubernetes.io/component="${component}" -n "$namespace" || true
    else
        print_warning "No manifests found for ${component}"
    fi
}

# Function to wait for pods
wait_for_pods() {
    local namespace=$1
    local timeout=${2:-300}
    
    print_status "Waiting for pods in namespace ${namespace} to be ready..."
    kubectl wait --for=condition=ready pod --all -n "$namespace" --timeout="${timeout}s" || true
}

# Function to setup port forwarding
setup_port_forwarding() {
    print_status "Setting up port forwarding..."
    
    # Kill existing port forwards
    pkill -f "kubectl port-forward" || true
    sleep 2
    
    # Start port forwarding in background
    kubectl port-forward -n "${NAMESPACE_PREFIX}-gitea" svc/gitea-http 3000:3000 &
    kubectl port-forward -n "${NAMESPACE_PREFIX}-argocd" svc/argocd-server 8080:80 &
    kubectl port-forward -n "${NAMESPACE_PREFIX}-vault" svc/vault 8200:8200 &
    kubectl port-forward -n "${NAMESPACE_PREFIX}-sonarqube" svc/sonarqube-sonarqube 9000:9000 &
    kubectl port-forward -n "${NAMESPACE_PREFIX}-monitoring" svc/prometheus-server 9090:80 &
    kubectl port-forward -n "${NAMESPACE_PREFIX}-monitoring" svc/grafana 3001:80 &
    kubectl port-forward -n "${NAMESPACE_PREFIX}-harbor" svc/harbor 8082:80 &
    kubectl port-forward -n "${NAMESPACE_PREFIX}-argo-workflows" svc/argo-server 8081:80 &
    kubectl port-forward -n "${NAMESPACE_PREFIX}-netbox" svc/netbox 8083:80 &
    kubectl port-forward -n "${NAMESPACE_PREFIX}-authelia" svc/authelia 8084:80 &
    
    sleep 5
    print_success "Port forwarding setup complete"
}

# Function to print access information
print_access_info() {
    print_success "DevOps Lab deployment complete!"
    echo
    echo "=== ACCESS INFORMATION ==="
    echo
    echo "Services:"
    echo "  Gitea:        http://localhost:3000"
    echo "  ArgoCD:       http://localhost:8080"
    echo "  Vault:        http://localhost:8200"
    echo "  SonarQube:    http://localhost:9000"
    echo "  Prometheus:   http://localhost:9090"
    echo "  Grafana:      http://localhost:3001"
    echo "  Harbor:       http://localhost:8082"
    echo "  Argo Workflows: http://localhost:8081"
    echo "  NetBox:       http://localhost:8083"
    echo "  Authelia:     http://localhost:8084"
    echo
    echo "Default Credentials:"
    echo "  Gitea:        ${GITEA_ADMIN_USER} / ${GITEA_ADMIN_PASSWORD}"
    echo "  ArgoCD:       admin / ${ARGOCD_ADMIN_PASSWORD}"
    echo "  Vault:        root / ${VAULT_ROOT_TOKEN}"
    echo "  Harbor:       admin / ${HARBOR_ADMIN_PASSWORD}"
    echo "  SonarQube:    admin / ${SONARQUBE_ADMIN_PASSWORD}"
    echo "  Grafana:      admin / ${GRAFANA_ADMIN_PASSWORD}"
    echo
    echo "To stop port forwarding: pkill -f 'kubectl port-forward'"
    echo "To view logs: kubectl logs -f deployment/<deployment-name> -n <namespace>"
    echo
}

# Main deployment function
main() {
    print_status "Starting DevOps Lab deployment..."
    
    # Save credentials to .env file
    cat > "${SCRIPT_DIR}/.env" <<EOF
# DevOps Lab Credentials
GITEA_ADMIN_USER=${GITEA_ADMIN_USER}
GITEA_ADMIN_PASSWORD=${GITEA_ADMIN_PASSWORD}
GITEA_ADMIN_EMAIL=${GITEA_ADMIN_EMAIL}

ARGOCD_ADMIN_PASSWORD=${ARGOCD_ADMIN_PASSWORD}

VAULT_ROOT_TOKEN=${VAULT_ROOT_TOKEN}

HARBOR_ADMIN_PASSWORD=${HARBOR_ADMIN_PASSWORD}

SONARQUBE_ADMIN_PASSWORD=${SONARQUBE_ADMIN_PASSWORD}

GRAFANA_ADMIN_PASSWORD=${GRAFANA_ADMIN_PASSWORD}
EOF
    
    check_dependencies
    setup_cluster
    add_helm_repos
    create_namespaces
    
    # Deploy components in order
    deploy_component "ingress" "${NAMESPACE_PREFIX}-ingress"
    deploy_component "gitea" "${NAMESPACE_PREFIX}-gitea"
    deploy_component "vault" "${NAMESPACE_PREFIX}-vault"
    deploy_component "harbor" "${NAMESPACE_PREFIX}-harbor"
    deploy_component "sonarqube" "${NAMESPACE_PREFIX}-sonarqube"
    deploy_component "monitoring" "${NAMESPACE_PREFIX}-monitoring"
    deploy_component "argocd" "${NAMESPACE_PREFIX}-argocd"
    
    # Wait for all components to be ready
    print_status "Waiting for all components to be ready..."
    sleep 30
    
    setup_port_forwarding
    print_access_info
}

# Run main function
main "$@"
