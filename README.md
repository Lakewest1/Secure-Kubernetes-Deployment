Yes — **don't just append that small section to the old README.** Your project has changed substantially since that README was written.

For example, the old README says:

* Minikube
* Docker Hub
* Snyk monitoring
* WSL architecture
* future AKS
* future GitHub Actions
* future CI/CD

But you have now **actually implemented**:

* Azure AKS
* Azure Container Registry
* GitHub Actions
* GitHub → Azure OIDC federation
* Trivy filesystem + container scanning
* Gitleaks
* Cilium networking
* Kubernetes RBAC
* NetworkPolicy
* hardened container runtime
* OPA Gatekeeper admission control
* immutable SHA-tagged image
* AKS → ACR pull
* live security validation

So I recommend **replacing the README with an upgraded version**, rather than trying to patch the old one.

And we should remove the old **Snyk monitoring claim** if Snyk is no longer part of the implemented workflow.

---

# Use this as your new README

Open:

```powershell
code README.md
```

Then replace the entire existing README with this:

````markdown
# 🔐 Secure Kubernetes Deployment — DevSecOps Security Pipeline

A practical **DevSecOps and Kubernetes security project** demonstrating how security controls can be integrated across the software delivery lifecycle — from source code and container scanning to cloud authentication, container registry security, Kubernetes hardening, network controls, and admission policy enforcement.

The project evolved from a local Kubernetes security lab into a cloud-based **Azure Kubernetes Service (AKS)** deployment with GitHub Actions CI/CD security controls and OPA Gatekeeper policy enforcement.

---

## 🎯 Project Objective

The goal of this project is to demonstrate a practical security-first workflow for deploying a containerized application to Kubernetes.

Security controls were implemented across multiple layers:

- Source and filesystem security scanning
- Secret detection
- Container image vulnerability scanning
- Secure container configuration
- Immutable image versioning
- GitHub Actions security pipeline
- Passwordless GitHub → Azure authentication using OIDC
- Azure Container Registry
- Kubernetes RBAC
- NetworkPolicy
- Cilium networking
- Kubernetes securityContext hardening
- OPA Gatekeeper admission control
- Runtime validation on AKS

---

# 🧠 DevSecOps Workflow

```text
Developer
    │
    ▼
GitHub Repository
    │
    ▼
GitHub Actions
    │
    ├── Trivy Filesystem Scan
    │
    ├── Gitleaks Secret Scan
    │
    ├── Docker Build
    │
    └── Trivy Container Image Scan
    │
    ▼
GitHub OIDC Federation
    │
    ▼
Microsoft Entra ID / Azure
    │
    ▼
Azure Container Registry
    │
    ▼
Azure Kubernetes Service (AKS)
    │
    ├── Kubernetes RBAC
    │
    ├── SecurityContext Hardening
    │
    ├── NetworkPolicy
    │
    ├── Cilium Networking
    │
    └── OPA Gatekeeper
            │
            ▼
      Admission Validation
            │
       ┌────┴────┐
       │         │
   Compliant   Non-Compliant
       │         │
       ▼         ▼
    Allowed     DENIED
````

---

# 🏗️ Architecture

```text
                    ┌─────────────────────┐
                    │     Developer       │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │   GitHub Repository │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │   GitHub Actions    │
                    │                     │
                    │ • Trivy FS          │
                    │ • Gitleaks          │
                    │ • Docker Build      │
                    │ • Trivy Image       │
                    └──────────┬──────────┘
                               │
                         OIDC Federation
                               │
                               ▼
                    ┌─────────────────────┐
                    │       Azure         │
                    │   Entra ID / OIDC   │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │ Azure Container     │
                    │ Registry (ACR)      │
                    └──────────┬──────────┘
                               │
                               ▼
              ┌────────────────────────────────┐
              │       Azure Kubernetes         │
              │          Service (AKS)         │
              │                                │
              │  ┌──────────────────────────┐  │
              │  │ OPA Gatekeeper           │  │
              │  │ Admission Policy         │  │
              │  └────────────┬─────────────┘  │
              │               │                │
              │  ┌────────────▼─────────────┐  │
              │  │ Hardened NGINX Workload  │  │
              │  │                          │  │
              │  │ • Non-root               │  │
              │  │ • Read-only filesystem   │  │
              │  │ • No privilege escalation│  │
              │  │ • Resource limits        │  │
              │  │ • Health probes          │  │
              │  │ • Dedicated ServiceAcct  │  │
              │  └──────────────────────────┘  │
              │                                │
              │  Cilium + NetworkPolicy        │
              └────────────────────────────────┘
```

---

# 🛠️ Technologies

### Cloud & Kubernetes

* Azure Kubernetes Service (AKS)
* Azure Container Registry (ACR)
* Kubernetes
* kubectl
* Cilium

### DevSecOps

* GitHub Actions
* Trivy
* Gitleaks
* Docker
* GitHub OIDC Federation

### Kubernetes Security

* RBAC
* ServiceAccount
* Role
* RoleBinding
* NetworkPolicy
* SecurityContext
* OPA Gatekeeper
* Rego

---

# 🐳 Container Security

The application uses an NGINX-based container image.

The workload is configured with Kubernetes security controls including:

```yaml
securityContext:
  runAsNonRoot: true
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
```

Writable temporary locations are explicitly provided using `emptyDir` volumes where required by the application.

Resource requests and limits are also configured:

```yaml
resources:
  requests:
    memory: "64Mi"
    cpu: "250m"

  limits:
    memory: "128Mi"
    cpu: "500m"
```

---

# 🔍 DevSecOps Security Pipeline

The GitHub Actions pipeline performs security checks before an image is pushed to Azure Container Registry.

## 1. Trivy Filesystem Scan

The repository is scanned for HIGH and CRITICAL vulnerabilities.

```yaml
- name: Trivy filesystem scan
  uses: aquasecurity/trivy-action@v0.36.0
  with:
    scan-type: fs
    scan-ref: .
    severity: HIGH,CRITICAL
    ignore-unfixed: true
```

---

## 2. Gitleaks Secret Detection

Gitleaks checks the repository for accidentally committed secrets.

```yaml
- name: Gitleaks secret scan
  uses: gitleaks/gitleaks-action@v3
```

---

## 3. Docker Image Build

The application image is built using the commit SHA as its version.

```text
secure-nginx:<git-sha>
```

This avoids relying on the mutable `latest` tag.

---

## 4. Trivy Container Image Scan

The built image is scanned before being pushed to ACR.

```yaml
- name: Trivy container image scan
  uses: aquasecurity/trivy-action@v0.36.0
  with:
    image-ref: ${{ env.IMAGE_NAME }}:${{ env.IMAGE_TAG }}
    severity: HIGH,CRITICAL
    ignore-unfixed: true
```

---

# 🔐 Passwordless GitHub → Azure Authentication

GitHub Actions authenticates to Azure using **OIDC federation** rather than storing a long-lived Azure client secret.

The workflow requests:

```yaml
permissions:
  contents: read
  id-token: write
```

Azure validates the GitHub-issued identity token through a federated credential.

The GitHub Actions identity is granted the required Azure permissions for pushing container images to ACR.

This reduces the need for long-lived credentials inside GitHub Actions.

---

# 📦 Azure Container Registry

Container images are pushed to:

```text
securek8sacr01.azurecr.io
```

The AKS kubelet identity has `AcrPull` permission so the cluster can retrieve private images from ACR without enabling anonymous image pulls.

---

# ☸️ Kubernetes Security

## SecurityContext

The application containers use:

```yaml
securityContext:
  runAsNonRoot: true
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
```

This reduces the impact of container compromise by:

* Preventing root execution
* Preventing privilege escalation
* Making the container root filesystem read-only

---

# 🔑 Kubernetes RBAC

A dedicated ServiceAccount is assigned to the application:

```yaml
serviceAccountName: nginx-sa
```

The ServiceAccount is bound to a namespace-scoped Role.

The Role permits only:

```yaml
resources:
  - pods

verbs:
  - get
  - list
```

The workload therefore does not receive broad Kubernetes permissions such as:

```text
create
delete
update
patch
```

This demonstrates the **principle of least privilege**.

---

# 🌐 NetworkPolicy

A Kubernetes NetworkPolicy is applied to the NGINX workload.

```text
nginx-allow-http
```

The policy limits ingress to the application's required TCP port:

```text
TCP 8080
```

The AKS cluster uses **Cilium** as the network dataplane and network policy implementation.

---

# 🛡️ OPA Gatekeeper

OPA Gatekeeper provides admission control for Kubernetes workloads.

A custom ConstraintTemplate was created using Rego.

The policy requires containers in Kubernetes Deployments to explicitly define:

```yaml
securityContext:
  runAsNonRoot: true
```

Policy files:

```text
policies/
└── gatekeeper/
    ├── constraint-template.yaml
    └── constraint.yaml
```

---

# 🚨 Security Validation

The security controls were validated against the live AKS cluster.

## Gatekeeper Admission Test

A deliberately non-compliant Deployment was submitted without:

```yaml
securityContext:
  runAsNonRoot: true
```

The Kubernetes admission webhook rejected the deployment:

```text
admission webhook "validation.gatekeeper.sh" denied the request:
[require-non-root] Containers must set securityContext.runAsNonRoot to true
```

The rejected workload was then verified to not exist:

```text
deployments.apps "gatekeeper-test" not found
```

This demonstrates that the Gatekeeper policy is actively enforced by the Kubernetes admission layer rather than merely existing as configuration.

---

## Compliant Application Validation

The hardened application continued running successfully after Gatekeeper enforcement.

Deployment status:

```text
NAME           READY   UP-TO-DATE   AVAILABLE
nginx-deploy   2/2     2             2
```

Application pods:

```text
nginx-deploy-65bd478c4f-2chxk   1/1   Running   0
nginx-deploy-65bd478c4f-7x4cd   1/1   Running   0
```

Both replicas remained healthy with zero restarts.

---

## Gatekeeper Audit Findings

The Gatekeeper audit currently reports five violations from AKS-managed system Deployments:

```text
konnectivity-agent-autoscaler
konnectivity-agent
coredns-autoscaler
coredns
cilium-operator
```

These are AKS-managed system workloads rather than the application's Deployment.

They were not manually modified because they are managed components of the AKS platform.

The application workload `nginx-deploy` was not among the reported violations.

---

# 📊 Kubernetes Validation

The final cluster validation confirmed:

```text
nginx-deploy                         2/2 Running
gatekeeper-controller-manager       Running
gatekeeper-audit                    Running
cilium                              Running
coredns                             Running
metrics-server                      Running
```

Security resources were also confirmed:

```text
NetworkPolicy
ServiceAccount
Role
RoleBinding
ConstraintTemplate
Gatekeeper Constraint
```

---

# 🔄 Project Evolution

This project started as a local Kubernetes security lab using Minikube and Docker.

The implementation was subsequently expanded to demonstrate cloud-based DevSecOps practices:

```text
Local Kubernetes Lab
        ↓
Container Security Hardening
        ↓
RBAC + NetworkPolicy
        ↓
GitHub Actions
        ↓
Trivy + Gitleaks
        ↓
GitHub OIDC
        ↓
Azure Container Registry
        ↓
Azure Kubernetes Service
        ↓
Cilium
        ↓
OPA Gatekeeper
        ↓
Live Admission Control Validation
```

This evolution demonstrates the transition from basic Kubernetes deployment toward a more complete cloud DevSecOps security workflow.

---

# ⚠️ Lessons Learned

### 1. Security must be enforced at multiple layers

Container scanning alone is not sufficient.

Security controls were applied across:

```text
Source
  ↓
Container
  ↓
Registry
  ↓
Identity
  ↓
Kubernetes
  ↓
Network
  ↓
Admission Control
```

### 2. Detection and enforcement are different

A vulnerability scanner can identify a problem.

Gatekeeper can prevent a non-compliant workload from being admitted.

Both capabilities are valuable but solve different problems.

### 3. Least privilege matters

Kubernetes workloads should not automatically receive broad API permissions.

Dedicated ServiceAccounts and namespace-scoped RBAC reduce the potential impact of workload compromise.

### 4. Immutable image versions improve deployment integrity

Using Git commit SHA-based image tags provides a stronger deployment reference than relying on:

```text
latest
```

---

# 🚀 Future Improvements

Potential future improvements include:

* Automated deployment from GitHub Actions to AKS using a dedicated least-privilege deployment identity
* Additional Gatekeeper policies
* Pod Security Standards enforcement
* External secret management with Azure Key Vault
* Centralized Kubernetes audit logging
* Prometheus/Grafana monitoring
* Advanced network segmentation
* Automated policy testing in CI

These are intentionally not presented as implemented features of the current project.

---

# 🏆 Key Outcomes

This project demonstrates practical experience with:

* Container security
* Kubernetes hardening
* Kubernetes RBAC
* Network security
* Admission control
* OPA/Rego policy
* Azure Kubernetes Service
* Azure Container Registry
* GitHub Actions
* OIDC federation
* Vulnerability scanning
* Secret detection
* DevSecOps automation
* Security validation and troubleshooting

The emphasis is on **implementing and validating security controls**, rather than simply deploying a Kubernetes application.

---

## 👨‍💻 Author

**Musa Olalekan (Sir Lakewest)**

Cloud Security Engineer | DevSecOps | Kubernetes Security | Detection Engineering

GitHub: [Lakewest1](https://github.com/Lakewest1)

---

# 🔐 Build → Scan → Fix → Authenticate → Validate → Deploy → Harden

````
