#!/bin/bash
# k3d Local Kubernetes Cluster Setup Script
set -e

# Configuration
CLUSTER_NAME="${1:-audityzer-dev}"
NODE_COUNT="${2:-3}"
KUBERNETES_VERSION="${3:-v1.27.4}"
PORT_API="${4:-6443}"
PORT_HTTP="${5:-80}"
PORT_HTTPS="${6:-443}"

echo "Creating k3d cluster: $CLUSTER_NAME"
echo "Nodes: $NODE_COUNT, K8s Version: $KUBERNETES_VERSION"

# Create k3d cluster with config
k3d cluster create "$CLUSTER_NAME" \
  --servers 1 \
  --agents "$((NODE_COUNT - 1))" \
  --image "rancher/k3s:$KUBERNETES_VERSION" \
  --port "$PORT_API:6443@loadbalancer" \
  --port "$PORT_HTTP:80@loadbalancer" \
  --port "$PORT_HTTPS:443@loadbalancer" \
  --volume /tmp/k3d-storage:/var/lib/storage@all \
  --wait

echo ""
echo "✓ Cluster '$CLUSTER_NAME' created successfully!"
echo ""
echo "Get kubeconfig:"
echo "  k3d kubeconfig get $CLUSTER_NAME > ~/.kube/config-$CLUSTER_NAME"
echo ""
echo "Merge into existing kubeconfig:"
echo "  k3d kubeconfig merge $CLUSTER_NAME --kubeconfig-switch-context"
echo ""
echo "Verify cluster:"
echo "  kubectl cluster-info"
echo "  kubectl get nodes"
