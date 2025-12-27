.PHONY: help init plan apply destroy fmt validate lint test clean k3d-create k3d-delete

# Variables
TF_DIR := terraform
ENV ?= dev
REGION ?= us-east-1

help:
	@echo "Audityzer Infrastructure - Available targets:"
	@echo "  init              - Initialize Terraform"
	@echo "  plan              - Plan Terraform changes"
	@echo "  apply             - Apply Terraform changes"
	@echo "  destroy           - Destroy infrastructure"
	@echo "  fmt               - Format Terraform files"
	@echo "  validate          - Validate Terraform files"
	@echo "  lint              - Run TFLint"
	@echo "  test              - Run tests"
	@echo "  k3d-create        - Create local k3d cluster"
	@echo "  k3d-delete        - Delete local k3d cluster"

k3d-create:
	bash scripts/k3d-create-cluster.sh audityzer-dev 3

k3d-delete:
	k3d cluster delete audityzer-dev

init:
	cd $(TF_DIR) && terraform init

plan:
	cd $(TF_DIR)/envs/$(ENV) && terraform plan -var-file=$(ENV).tfvars

apply:
	cd $(TF_DIR)/envs/$(ENV) && terraform apply -var-file=$(ENV).tfvars

destroy:
	cd $(TF_DIR)/envs/$(ENV) && terraform destroy -var-file=$(ENV).tfvars

fmt:
	terraform fmt -recursive $(TF_DIR)/

validate:
	cd $(TF_DIR) && terraform init -backend=false && terraform validate

lint:
	cd $(TF_DIR) && tflint --init && tflint

test:
	@echo "Running infrastructure tests..."

clean:
	find $(TF_DIR) -name '.terraform' -type d -exec rm -rf {} + 2>/dev/null || true
	find $(TF_DIR) -name '*.tfstate*' -delete 2>/dev/null || true
