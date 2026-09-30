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
- A single shared Helm chart (`helm/app`) with per-app values files under `helm/`
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
cp minikube.tfvars.example minikube.tfvars   # then edit values (gitignored)
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
kubectl apply -f ingress/nginx-ingress.yaml   # requires: minikube addons enable ingress
```

This gives ArgoCD a root application to reconcile the child app manifests. Both apps deploy into the `k8s` namespace; the ingress routes `/api` to the backend and everything else to the frontend.

---

## Helm deployment

Both apps are deployed from one generic chart, `helm/app`. Shared defaults live in `helm/app/values.yaml`; each app's differences (image, port, probes) live in `helm/values-<app>.yaml`. `fullnameOverride` keeps the service names `backend` and `frontend`, which the ingress relies on.

Example:

```bash
helm upgrade --install backend  ./helm/app -n k8s --create-namespace -f helm/values-backend.yaml
helm upgrade --install frontend ./helm/app -n k8s -f helm/values-frontend.yaml
```

To add another app, create `helm/values-<app>.yaml` and an ArgoCD `Application` pointing at `helm/app` with that values file.

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
