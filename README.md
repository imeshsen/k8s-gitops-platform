# Kubernetes GitOps Platform

This repository is a sample platform for deploying a Java backend, a React frontend, and supporting Kubernetes infrastructure using Terraform, Helm, and ArgoCD.

It is designed to demonstrate a GitOps-oriented architecture with:

- Terraform for cluster and infrastructure provisioning
- Helm charts for application packaging
- ArgoCD manifests for GitOps deployment
- Kubernetes namespaces, secrets, and provider configuration
- Minikube-based local environment setup

---

## Project overview

The platform includes:

- A Spring Boot backend under `application-sourcecodes/backend`
- A React + TypeScript frontend under `application-sourcecodes/frontend`
- Helm charts for the backend and frontend under `helm/`
- ArgoCD application manifests under `argocd-manifests/`
- Terraform configuration for Minikube under `terraform/environments/minikube`
- Support modules for provider setup and secret creation under `terraform/modules/minikube`

---

## Repository structure

```text
k8s-gitops-platform/
├── README.md
├── application-sourcecodes/
│   ├── docker-compose.yaml
│   ├── backend/
│   │   ├── Dockerfile
│   │   ├── openapi.yaml
│   │   ├── pom.xml
│   │   └── src/
│   └── frontend/
│       ├── Dockerfile
│       ├── eslint.config.js
│       ├── index.html
│       ├── nginx.conf
│       ├── package.json
│       ├── public/
│       ├── src/
│       ├── tsconfig.app.json
│       ├── tsconfig.json
│       └── tsconfig.node.json
├── argocd-manifests/
│   ├── app-of-apps.yaml
│   ├── backend-app.yaml
│   └── frontend-app.yaml
├── helm/
│   ├── backend/
│   │   ├── Chart.yaml
│   │   ├── templates/
│   │   ├── values.yaml
│   │   └── charts/
│   └── frontend/
│       ├── Chart.yaml
│       ├── templates/
│       ├── values.yaml
│       └── charts/
├── ingress/
│   └── nginx-ingress.yaml
├── monitoring/
│   ├── docker-compose.yml
│   └── prometheus.yml
├── shellScripts/
│   ├── deployAppHelm.sh
│   ├── grafana.sh
│   ├── switchNS.sh
│   └── terraform.sh
├── terraform/
│   ├── environments/
│   │   └── minikube/
│   │       ├── argocd.tf
│   │       ├── minikube.tfvars
│   │       ├── namespace.tf
│   │       ├── outputs.tf
│   │       ├── providers.tf
│   │       ├── secrets.tf
│   │       ├── var.tfvars.example
│   │       ├── variables.tf
│   │       └── .terraform/
│   ├── modules/
│   │   └── minikube/
│   │       ├── providers/
│   │       ├── secrets/
│   │       └── namespace/
│   ├── main.tf
│   ├── minikube.tfvars
│   ├── namespace.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── secrets.tf
│   ├── var.tfvars.example
│   └── variables.tf
└── .gitignore
```

---

## Prerequisites

Before running the platform, install the following tools:

- Docker
- kubectl
- Helm
- Terraform
- Minikube
- Java 17+ (for the backend build)
- Node.js 18+ and npm (for the frontend build)

---

## Local Minikube setup

The environment configuration is under:

```text
terraform/environments/minikube
```

### 1. Start Minikube

```bash
minikube start
```

### 2. Initialize Terraform

```bash
cd terraform/environments/minikube
terraform init
```

### 3. Validate configuration

```bash
terraform validate
```

### 4. Review the plan

```bash
terraform plan -var-file=minikube.tfvars
```

### 5. Apply infrastructure

```bash
terraform apply -var-file=minikube.tfvars
```

This environment uses variables such as:

- `username`
- `password`
- `namespace`
- `terraform_source`
- `terraform_version`
- `config_path`
- `config_context`

---

## Application run flow

### Backend

```bash
cd application-sourcecodes/backend
mvn clean package
java -jar target/*.jar
```

### Frontend

```bash
cd application-sourcecodes/frontend
npm install
npm run dev
```

### Docker Compose

For a containerized local development run:

```bash
docker compose -f application-sourcecodes/docker-compose.yaml up --build
```

---

## ArgoCD and GitOps

The repository contains ArgoCD application definitions in `argocd-manifests/` to deploy the backend and frontend using a GitOps model.

Typical flow:

```bash
kubectl apply -f argocd-manifests/app-of-apps.yaml
```

This gives ArgoCD a root application to reconcile the child app manifests.

---

## Helm deployment

The Helm charts are under `helm/backend` and `helm/frontend`.

Example:

```bash
helm install backend ./helm/backend -n default
helm install frontend ./helm/frontend -n default
```

---

## Useful scripts

The repo includes helper scripts in `shellScripts/` for common platform tasks:

- `deployAppHelm.sh`
- `grafana.sh`
- `switchNS.sh`
- `terraform.sh`

These are intended to simplify deployment and namespace switching during local and demo usage.

---

## Notes

- The Terraform configuration validates successfully in the Minikube environment.
- The repo is structured as a demonstration platform and is meant to be adapted to your environment-specific Kubernetes cluster and secrets management workflow.
- For production use, prefer a secure secret manager such as AWS Secrets Manager, Azure Key Vault, or Kubernetes external-secrets instead of plain tfvars values.

---

## License

This project is intended for learning and demonstration purposes unless otherwise stated in repository files.
