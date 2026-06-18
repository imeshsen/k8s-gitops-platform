# Kubernetes GitOps Platform

A production‑grade, GitOps‑ready Kubernetes deployment skeleton structuring infrastructure provisioning (Terraform), cluster packaging (Helm), and continuous deployment (ArgoCD).

## Repository Structure

```
k8s-gitops-platform/
│
├── application-sourcecodes/    # Source Application Code
│   ├── backend/                # Spring Boot API (served on port 8080)
│   │   ├── Dockerfile          # Multi-stage build configuration for Java
│   │   ├── openapi.yaml        # API contracts and specifications
│   │   ├── pom.xml             # Maven dependencies configuration
│   │   └── src/                # Spring Boot Application source code
│   │
│   ├── docker-compose.yaml     # Local multi-container development environment
│   │
│   └── frontend/               # React / TypeScript Vite web client
│       ├── Dockerfile          # Multi-stage production Nginx deployment
│       ├── eslint.config.js    # Linting rules matching team standards
│       ├── index.html          # Application entry point
│       ├── nginx.conf          # Custom optimized reverse proxy / routing
│       ├── package.json        # Frontend project metadata and dependencies
│       ├── public/             # Static web assets (favicons, vectors)
│       ├── src/                # Application components (TSX, CSS styles)
│       └── tsconfig*.json      # TypeScript compiler workspace configurations
│
├── argocd-manifests/           # Continuous Deployment Manifests
│   ├── app-of-apps.yaml        # ArgoCD Root Application (App-of-Apps pattern)
│   ├── backend-app.yaml        # Backend service target tracking and sync policy
│   └── frontend-app.yaml       # Frontend web client declarative sync policy
│
├── helm/                       # Enterprise Application Packaging
│   ├── backend/                # Spring Boot service Helm chart configuration
│   │   ├── Chart.yaml          # Packaging metadata and semantic versioning
│   │   ├── templates/          # K8s objects (Deployment, HPA, Ingress, SVC)
│   │   └── values.yaml         # Environment defaults and resource limits
│   │
│   └── frontend/               # Single Page Application Helm chart definition
│       ├── Chart.yaml          # Web client package manifest
│       ├── templates/          # Declarative K8s resources engine
│       └── values.yaml         # Configurable parameters (replicas, image tags)
│
├── ingress/                    # Global Cluster Entrypoints
│   └── nginx-ingress.yaml      # Path-based routing rules mappings
│
├── shellScripts/               # Platform Operator Automation Utilities
│   ├── helm.sh                 # Routine chart validation and package manager
│   ├── switchNS.sh             # Active Kubernetes namespace contextual toggle
│   └── terraform.sh            # Idempotent cloud infrastructure deployment wrap
│
└── terraform/                  # Infrastructure as Code (IaC) Workspace
├── grafana.tf              # Monitoring dashboards & observability layer
├── main.tf                 # Core cluster compute provisioning blueprint
├── namespace.tf            # Native cluster namespace baseline isolation
├── outputs.tf              # Cloud outputs export configurations
├── providers.tf            # Sourcing credentials (AWS, K8s, Helm)
├── secrets.tf              # Sealed variables and sensitive value provisions
└── variables.tf            # Input type constraints and variables schema
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

## Helm Notes for Grafana
- How to get admin username and password
  List helm charts in your namespace
    helm list -n monitoring
  Retrive admin password for your chart
    kubectl get secret --namespace monitoring your_chart_name -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
  
- Access the grafana dashboard
  kubectl port-forward svc/grafana 8081:80 --address 0.0.0.0.0

---
