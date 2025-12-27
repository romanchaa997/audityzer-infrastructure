# Audityzer Infrastructure Setup Guide

## Quick Start

### Prerequisites
- Terraform 1.0+
- kubectl 1.27+
- k3d (for local development)
- GNU Make
- AWS CLI configured with credentials
- Cloudflare API token

### Local Development Setup

1. **Create local Kubernetes cluster:**
   ```bash
   make k3d-create
   ```

2. **Initialize Terraform:**
   ```bash
   make init
   ```

3. **Deploy to development environment:**
   ```bash
   make plan ENV=dev
   make apply ENV=dev
   ```

## Environment Configuration

Each environment (dev, stage, prod) has its own configuration:

- `terraform/envs/dev/` - Development with minimal resources
- `terraform/envs/stage/` - Staging environment mirrors production
- `terraform/envs/prod/` - Production with HA and backup

## Terraform Structure

```
terraform/
├── versions.tf          # Provider versions
├── providers.tf         # Provider configurations
├── variables.tf         # Global variables
├── backend.tf           # Remote state config
├── modules/             # Reusable modules
│   └── cloudflare/      # Cloudflare DNS module
└── envs/                # Environment-specific configs
    ├── dev/
    ├── stage/
    └── prod/
```

## Kubernetes Deployment

### Base Resources
- Namespace: `audityzer`
- Network Policy: Default deny ingress
- Resource Quota: 100 CPU / 200GB memory

### Ingress & Certificates
- Ingress Controller: NGINX
- Certificate Manager: cert-manager with Let's Encrypt
- Domains: api.audityzer.com, app.audityzer.com

### Available Make Commands

```bash
make help          # Show all commands
make init          # Initialize Terraform
make plan          # Plan infrastructure changes
make apply         # Apply infrastructure changes  
make destroy       # Destroy infrastructure
make fmt           # Format Terraform files
make validate      # Validate Terraform configuration
make lint          # Run TFLint security checks
make k3d-create    # Create local Kubernetes cluster
make k3d-delete    # Delete local cluster
```

## CI/CD Pipeline

GitHub Actions workflows validate and deploy infrastructure:

1. **PR checks:**
   - Terraform format validation
   - Terraform syntax validation
   - TFLint security scanning
   - TFSec vulnerability scanning

2. **Merge to main:**
   - Plan infrastructure changes
   - Apply approved changes
   - Deploy Kubernetes manifests

## Security Considerations

- State files are remote (S3 + DynamoDB locking)
- All sensitive variables are encrypted
- Network policies restrict ingress
- Resource quotas prevent resource exhaustion
- TFSec scans for Terraform security issues

## Troubleshooting

### Terraform State Lock
```bash
cd terraform
terraform force-unlock <lock-id>
```

### View Cluster Info
```bash
kubectl cluster-info
kubectl get nodes
kubectl get all -n audityzer
```

### Access k3d Cluster
```bash
k3d kubeconfig merge audityzer-dev --kubeconfig-switch-context
kubectl config use-context k3d-audityzer-dev
```
