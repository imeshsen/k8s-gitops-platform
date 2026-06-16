# Kubernetes GitOps Platform

A production‑grade, GitOps‑ready Kubernetes deployment skeleton structuring infrastructure provisioning (Terraform), cluster packaging (Helm), and continuous deployment (ArgoCD).

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
│   ├── frontend/               # React/Vite client Helm chart
│   └── backend/                # Spring Boot API Service Helm chart
│
├── argocd-manifests/           # Continuous Deployment Manifests
│   ├── app-of-apps.yaml        # ArgoCD Root Application (App of Apps pattern)
│   ├── frontend-app.yaml       # Frontend service CD configuration
│   └── backend-app.yaml        # Backend API service CD configuration
│
├── application-sourcecodes/    # Source Application Code
│   ├── frontend/               # React/Vite web client (served on port 3000)
│   └── backend/                # Spring Boot API (served on port 8080)
│
├── ingress/                    # Global Routing Policies
│   └── nginx-ingress.yaml      # Nginx Ingress proxy paths configuration
│
└── README.md                   # This file
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

### 2. Run Applications Locally with Docker
You can test the application components locally using Docker. A `docker-compose.yaml` is provided in the repository root.

```yaml
version: '3.8'
services:
  backend:
    build:
      context: "./application-sourcecodes/backend"
      dockerfile: Dockerfile
    ports:
      - "8080:8080"
  frontend:
    build:
      context: "./application-sourcecodes/frontend"
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      - VITE_API_URL=http://host.docker.internal:8080
    depends_on:
      - backend
```

Run the stack:

```bash
docker compose up --build
```

The frontend will be available at `http://localhost:3000` and will automatically call the backend at `http://host.docker.internal:8080`.

### 3. Deploy via ArgoCD
Apply the root application configuration to trigger the ArgoCD App‑of‑Apps synchronization engine:

```bash
kubectl apply -f argocd-manifests/app-of-apps.yaml
```

---

## Security Practices
- All container base images use minimal‑footprint `alpine` builds to minimise attack surface.
- The Spring Boot backend runs under an unprivileged user (`spring`) rather than root, and the frontend runs under `node`.
- Resource constraints (`requests`/`limits`) are explicitly defined on all Helm charts to prevent Denial‑of‑Service attacks.

---

## Development Notes
- The frontend uses Vite's proxy during development (`vite.config.ts`) and falls back to `VITE_API_URL` environment variable in production.
- The backend CORS configuration now allows calls from both `http://localhost:5173` (Vite dev server) and `http://localhost:3000` (preview container).

---

