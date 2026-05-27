# Kubernetes GitOps Platform

A production-grade, GitOps-ready Kubernetes deployment skeleton structuring infrastructure provisioning (Terraform), cluster packaging (Helm), and continuous deployment (ArgoCD).

## Repository Structure

```
k8s-gitops-platform/
│
├── terraform/                  # Infrastructure as Code (IaC)
│   ├── main.tf                 # EKS variable resources and local declarations
│   ├── providers.tf            # AWS, Kubernetes, Helm providers configuration
│   └── outputs.tf              # Cloud outputs (Cluster Endpoints, Regions)
│
├── helm/                       # Application Packaging
│   ├── frontend/               # Nginx Static Dashboard Helm chart
│   ├── backend/                # Node.js API Service Helm chart
│   └── monitoring/             # Grafana + Prometheus stack chart
│
├── argocd/                     # Continuous Deployment Manifests
│   ├── app-of-apps.yaml        # ArgoCD Root Application (App of Apps pattern)
│   ├── frontend-app.yaml       # Frontend service CD configuration
│   └── backend-app.yaml        # Backend API service CD configuration
│
├── apps/                       # Source Application Code
│   ├── frontend/               # HTML/CSS Darkmode Web Client
│   └── backend/                # Node.js Express API Server
│
├── ingress/                    # Global Routing Policies
│   └── nginx-ingress.yaml      # Nginx Ingress proxy paths configuration
│
└── README.md                   # This instruction manual
```

---

## Getting Started

### 1. Provision Infrastructure
Configure the Terraform workspaces inside the `terraform` folder to match your cloud architecture:
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 2. Run Applications Locally
You can test the application components locally using Docker Compose:

Create a `docker-compose.yaml` in the root:
```yaml
version: '3.8'
services:
  backend:
    build: ./apps/backend
    ports:
      - "8080:8080"
  frontend:
    build: ./apps/frontend
    ports:
      - "80:80"
    depends_on:
      - backend
```
Run `docker compose up --build` to see them spin up.

### 3. Deploy via ArgoCD
Apply the root application configuration to trigger the ArgoCD App-of-Apps synchronization engine:
```bash
kubectl apply -f argocd/app-of-apps.yaml
```

---

## Security Practices
- All container base images use minimal footprint `alpine` builds to minimize attack surface area.
- Express backend executes under the context of the unprivileged system user (`USER node`) instead of root.
- Resource constraints (`requests`/`limits`) are explicitly defined on all charts to prevent Denial of Service (DoS) through pod resource exhaustion.
