#!/bin/bash

# K3d Setup Script for Audityzer Platform
# This script automates the setup of a local Kubernetes cluster using k3d

set -e

echo "🚀 Starting K3d setup for Audityzer platform..."

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
  echo -e "${GREEN}✓${NC} $1"
}

print_error() {
  echo -e "${RED}✗${NC} $1"
}

print_info() {
  echo -e "${YELLOW}ℹ${NC} $1"
}

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
  print_error "Docker is not installed. Please install Docker first."
  exit 1
fi
print_status "Docker is installed"

# Check if Docker daemon is running
if ! docker info &> /dev/null; then
  print_error "Docker daemon is not running. Please start Docker."
  exit 1
fi
print_status "Docker daemon is running"

# Check if k3d is installed
if ! command -v k3d &> /dev/null; then
  print_info "k3d is not installed. Installing k3d..."
  curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
  print_status "k3d installed successfully"
else
  print_status "k3d is already installed"
fi

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
  print_info "kubectl is not installed. Installing kubectl..."
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/$(uname -s | tr A-Z a-z)/amd64/kubectl"
  chmod +x kubectl
  sudo mv kubectl /usr/local/bin/
  print_status "kubectl installed successfully"
else
  print_status "kubectl is already installed"
fi

# Create k3d cluster
CLUSTER_NAME="audityzer"
print_info "Creating k3d cluster: $CLUSTER_NAME"

if k3d cluster list | grep -q "$CLUSTER_NAME"; then
  print_info "Cluster '$CLUSTER_NAME' already exists. Skipping creation."
else
  k3d cluster create $CLUSTER_NAME \
    --agents 2 \
    --servers 1 \
    --volume /tmp/k3d:/var/lib/rancher/k3s/storage@all \
    --port 8080:80@loadbalancer \
    --port 8443:443@loadbalancer
  print_status "Cluster '$CLUSTER_NAME' created successfully"
fi

# Merge kubeconfig
print_info "Configuring kubeconfig..."
k3d kubeconfig merge $CLUSTER_NAME --switch-context
print_status "Kubeconfig configured"

# Wait for cluster to be ready
print_info "Waiting for cluster to be ready..."
sleep 5

# Verify cluster access
print_info "Verifying cluster access..."
if kubectl get nodes &> /dev/null; then
  print_status "Cluster is accessible"
  echo ""
  print_status "K3d cluster nodes:"
  kubectl get nodes
else
  print_error "Failed to access cluster"
  exit 1
fi

# Create audityzer namespace
print_info "Creating audityzer-dev namespace..."
kubectl create namespace audityzer-dev --dry-run=client -o yaml | kubectl apply -f -
print_status "Namespace 'audityzer-dev' ready"

# Final summary
echo ""
echo "════════════════════════════════════════════"
print_status "K3d setup completed successfully!"
echo ""
echo "Cluster Details:"
echo "  Name: $CLUSTER_NAME"
echo "  Nodes: $(kubectl get nodes --no-headers | wc -l)"
echo "  Context: $(kubectl config current-context)"
echo ""
echo "Next steps:"
echo "  1. Deploy applications: kubectl apply -f deployment.yaml -n audityzer-dev"
echo "  2. Port forward: kubectl port-forward svc/service-name 8000:8000 -n audityzer-dev"
echo "  3. View logs: kubectl logs -f pod-name -n audityzer-dev"
echo ""
echo "Cleanup:"
echo "  k3d cluster delete $CLUSTER_NAME"
echo "════════════════════════════════════════════"
echo ""

print_status "Setup script completed!"
