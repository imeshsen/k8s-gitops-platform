# AWS DevOps Learning Roadmap

A PR-sized checklist for leveling up this repo from a Minikube demo into an
AWS-flavored GitOps platform. Each item is scoped to be one focused PR.
Ordered by suggested sequence — later items build on earlier ones.

---

## Phase 1 — Get real AWS infra under Terraform

- [ ] **1.1 Implement the EKS Terraform module**
      `terraform/modules/EKS/` and `terraform/environments/EKS/` are currently
      empty stubs. Mirror the structure already used for Minikube
      (`terraform/modules/minikube/{providers,namespace,secrets}`):
      - `modules/EKS/cluster` — VPC, subnets, EKS cluster + managed node group
        (or Fargate profile)
      - `modules/EKS/providers` — kubernetes/helm provider wired to the new
        cluster's endpoint + auth token instead of `~/.kube/config`
      - `environments/EKS/` — `variables.tf`, `outputs.tf`, `*.tfvars.example`
        following the same pattern as `terraform/environments/minikube/`

- [ ] **1.2 Move Terraform state to S3 + DynamoDB lock**
      Add a `backend "s3" {}` block in `terraform/environments/EKS/providers.tf`
      (and optionally minikube, though local state is fine there). Provision
      the state bucket + lock table either by hand once, or in a tiny
      bootstrap Terraform config.

- [ ] **1.3 Clean up the duplicate root-level Terraform files**
      `terraform/main.tf`, `variables.tf`, `secrets.tf`, etc. look like
      leftovers from before the `environments/` split. Decide: delete them,
      or turn the root into a real shared-module entry point. Either way,
      resolve the duplication before adding EKS makes it worse.

## Phase 2 — Secrets done properly

- [ ] **2.1 Replace plaintext tfvars secrets with AWS Secrets Manager**
      Today `username`/`password` flow through `*.tfvars` → Terraform
      variable → Kubernetes secret (`terraform/modules/minikube/secrets/main.tf`).
      For EKS, provision the secret in AWS Secrets Manager via Terraform, and
      reference it — don't pass raw passwords through `.tfvars` at all.

- [ ] **2.2 Add the External Secrets Operator**
      Install via a Helm release in Terraform (same pattern as the existing
      `helm_release.argocd` in `terraform/environments/minikube/argocd.tf`),
      then create an `ExternalSecret` manifest so backend pods pull secrets
      from Secrets Manager at runtime instead of Terraform writing a
      Kubernetes `Secret` directly.

## Phase 3 — CI/CD

- [ ] **3.1 GitHub Actions: build + push images**
      `.github/workflows/ci.yml` — on push to `application-sourcecodes/**`,
      build the backend (`application-sourcecodes/backend/Dockerfile`) and
      frontend (`application-sourcecodes/frontend/Dockerfile`) images, tag
      with the git SHA, push to ECR (new) or Docker Hub (matches current
      `spims96/k8s-stack-api` convention in `helm/backend/values.yaml`).

- [ ] **3.2 Auto-bump Helm values on new image**
      Add a CI step (or a tool like Argo Image Updater) that updates
      `helm/backend/values.yaml` / `helm/frontend/values.yaml` image tags
      after a successful build, so ArgoCD's `selfHeal`/`automated` sync in
      `argocd-manifests/*.yaml` picks up the new version automatically.

- [ ] **3.3 Fix the ArgoCD placeholder repo URL**
      `argocd-manifests/app-of-apps.yaml`, `backend-app.yaml`,
      `frontend-app.yaml` all point at
      `https://github.com/<your-org>/k8s-gitops-platform.git`. Swap in the
      real URL so `kubectl apply -f argocd-manifests/app-of-apps.yaml`
      actually reconciles.

- [ ] **3.4 Add image + secret scanning to CI**
      Trivy for the built images, gitleaks (or similar) as a pre-commit/CI
      check so a repeat of the `var.tfvars copy.example` pattern never
      accidentally becomes a real committed secret.

## Phase 4 — EKS-specific hardening

- [ ] **4.1 IAM Roles for Service Accounts (IRSA)**
      Give the backend's `serviceAccount` (see
      `helm/backend/templates/serviceaccount.yaml`) a real IAM role via
      annotation, scoped to only what it needs (e.g. Secrets Manager read).
      Good hands-on IAM least-privilege practice.

- [ ] **4.2 Ingress via AWS Load Balancer Controller**
      `ingress/nginx-ingress.yaml` and the Helm `ingress.enabled` values
      assume nginx-ingress. On EKS, install the AWS Load Balancer Controller
      and add an EKS-specific ingress class / values override.

## Phase 5 — Observability

- [ ] **5.1 Wire CloudWatch alongside Prometheus/Grafana**
      Keep `monitoring/docker-compose.yml` /
      `application-sourcecodes/prometheus.yml` for local dev, but for EKS add
      Container Insights or the CloudWatch agent so you learn the AWS-native
      path too.

- [ ] **5.2 Consolidate the two monitoring docker-compose setups**
      `monitoring/docker-compose.yml` and
      `application-sourcecodes/docker-compose.yaml` both define
      Prometheus/Grafana independently — merge into one to avoid drift.

## Phase 6 — Polish

- [ ] **6.1 Set resource requests/limits and a non-empty `securityContext`**
      Both `helm/backend/values.yaml` and `helm/frontend/values.yaml` leave
      `resources: {}` and `securityContext: {}` as scaffolding defaults —
      fill these in (the backend Dockerfile already runs as non-root, so
      `runAsNonRoot: true` costs nothing to add).

- [ ] **6.2 Tighten backend CORS for deployed environments**
      `HelloController` hardcodes `http://localhost:5173` /
      `http://localhost:3000` — parameterize via `application.properties` so
      the deployed frontend's real origin can be set per environment.

---

## Suggested pacing

Work top to bottom — each phase assumes the previous one merged. Phase 1–2
are the highest-value AWS learning (EKS + IAM + Secrets Manager are the
crux of the AWS DevOps Professional exam). Treat Phase 6 as cleanup you can
interleave whenever a phase feels heavy.
