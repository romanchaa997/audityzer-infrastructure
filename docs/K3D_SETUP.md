# K3d Local Kubernetes Setup Guide

## Overview
This guide provides instructions for setting up a local Kubernetes cluster using k3d for Audityzer platform development. k3d is a lightweight wrapper for running k3s (a minimal Kubernetes distribution) in Docker containers.

## Prerequisites
- Docker installed and running
- curl or wget
- Linux/macOS/WSL2 (Windows)

## Installation

### 1. Install k3d

```bash
# Download and install k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# Or using brew (macOS/Linux)
brew install k3d

# Verify installation
k3d --version
```

### 2. Install kubectl

```bash
# macOS
brew install kubectl

# Linux
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Verify installation
kubectl version --client
```

## Creating a Local Cluster

### Quick Start

```bash
# Create a basic k3d cluster named 'audityzer'
k3d cluster create audityzer

# Verify cluster is running
k3d cluster list

# Get cluster kubeconfig
k3d kubeconfig merge audityzer --switch-context

# Test cluster access
kubectl get nodes
```

### Advanced Configuration

```bash
# Create cluster with custom settings
k3d cluster create audityzer \
  --agents 3 \
  --servers 1 \
  --volume /tmp/k3d:/var/lib/rancher/k3s/storage@all \
  --port 8080:80@loadbalancer \
  --port 8443:443@loadbalancer

# Parameters:
# --agents 3: Create 3 worker nodes
# --servers 1: Create 1 control plane node
# --volume: Mount volume for persistent storage
# --port: Expose ports on load balancer
```

## Cluster Management

### Start/Stop Cluster

```bash
# Start cluster
k3d cluster start audityzer

# Stop cluster
k3d cluster stop audityzer

# Delete cluster
k3d cluster delete audityzer
```

### Deploy Applications

```bash
# Create namespace
kubectl create namespace audityzer-dev

# Deploy from YAML
kubectl apply -f deployment.yaml -n audityzer-dev

# Check deployments
kubectl get deployments -n audityzer-dev
kubectl get pods -n audityzer-dev
kubectl get services -n audityzer-dev
```

### Port Forwarding

```bash
# Forward service port to local machine
kubectl port-forward svc/audityzer-service 8000:8000 -n audityzer-dev

# Access service locally at localhost:8000
```

## Docker Registry Integration

k3d automatically configures a built-in registry. To use it:

```bash
# Create cluster with built-in registry
k3d cluster create audityzer \
  --registry-create audityzer-registry:0.0.0.0:5000

# Tag and push images
docker tag myapp:latest localhost:5000/myapp:latest
docker push localhost:5000/myapp:latest

# Use in deployment
# imagePolicy: localhost:5000/myapp:latest
```

## Troubleshooting

### Check Cluster Status

```bash
# View cluster details
k3d cluster describe audityzer

# Check node status
kubectl get nodes -o wide

# View system pods
kubectl get pods -n kube-system
```

### Common Issues

1. **Port already in use**
   ```bash
   # Change port mapping
   k3d cluster create audityzer --port 8081:80@loadbalancer
   ```

2. **Docker daemon not running**
   ```bash
   # Start Docker
   sudo systemctl start docker  # Linux
   open -a Docker              # macOS
   ```

3. **Insufficient memory**
   ```bash
   # Increase Docker memory allocation
   # Settings > Resources > Memory (Increase to 4GB+)
   ```

## Next Steps

1. Deploy infrastructure components
2. Setup CI/CD pipelines
3. Configure persistent storage
4. Implement network policies
5. Setup monitoring and logging

## References
- [k3d Documentation](https://k3d.io/)
- [k3s Documentation](https://docs.k3s.io/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
