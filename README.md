# 🔐 Secure Kubernetes Deployment (DevSecOps Project)

## 🚀 Project Overview

In this project, I implemented a **security-first DevSecOps workflow** that goes beyond traditional container deployment.

Instead of just deploying an application, I:

* Scanned for vulnerabilities using **Trivy**
* Actively **remediated security issues**
* Deployed securely on Kubernetes
* Applied **RBAC, Network Policies, and Security Hardening**
* Validated and continuously monitored using **Snyk**

This reflects **real-world DevSecOps maturity**, where security is integrated across the entire lifecycle.

---

## 🧠 DevSecOps Workflow

```
Code → Docker → Scan (Trivy) → Fix → Push → Kubernetes → Secure → Monitor (Snyk)
```

---

## 🏗️ Architecture

```
Local Machine (WSL)
        ↓
Docker Image (NGINX + Portfolio)
        ↓
Docker Hub
        ↓
Kubernetes (Minikube)
        ↓
Pods (2 Replicas)
        ↓
Service (NodePort / Port Forward)
        ↓
Browser (localhost)
```

---

## 🛠️ Technologies Used

* Kubernetes (Minikube)
* Docker
* NGINX (Unprivileged)
* Trivy (Image Scanning)
* Snyk (Cloud Security Monitoring)
* kubectl
* WSL

---

## 🐳 Dockerfile

```dockerfile
FROM nginx:alpine

COPY index.html /usr/share/nginx/html/index.html
```

---

## ☸️ Kubernetes Deployment

### Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx-deploy
  template:
    metadata:
      labels:
        app: nginx-deploy
    spec:
      containers:
      - name: my-nginx-app1
        image: lakewest/my-nginx-app1:latest
        ports:
        - containerPort: 80

        securityContext:
          runAsNonRoot: true
          allowPrivilegeEscalation: false
          readOnlyRootFilesystem: true

        resources:
          requests:
            memory: "64Mi"
            cpu: "250m"
          limits:
            memory: "128Mi"
            cpu: "500m"
```

---

### Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: NodePort
  selector:
    app: nginx-deploy
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30007
```

---

## 🔐 Security Implementation

### ✅ Trivy Scan (Pre-Deployment)

* Identified vulnerabilities in base image
* Fixed by switching to **Alpine-based image**
* Reduced attack surface significantly

---

### ✅ Kubernetes Hardening

* `runAsNonRoot`
* `readOnlyRootFilesystem`
* Resource limits
* Least privilege configuration

### Decision : Container Base Image Selection

I initially used a lightweight Alpine-based image to reduce the attack surface. However, after identifying security risks related to root execution, I switched to an unprivileged NGINX image (nginxinc/nginx-unprivileged) to enforce non-root execution in line with Kubernetes security best practices.
---

### ✅ RBAC

* ServiceAccount with minimal permissions
* Role + RoleBinding applied

---

### ✅ Network Policy

* Only allows traffic on required port
* Implements **Zero Trust Networking**

---

### ✅ Secrets

* No hardcoded sensitive data
* Managed securely via Kubernetes Secrets

---

### ✅ Snyk Monitoring (Post-Deployment)

* Continuous vulnerability monitoring
* Validated security posture after deployment

---

## ⚠️ Challenges & Solutions

### ❌ Port Forward Error

✔ Fixed port mismatch between container and service

### ❌ Old HTML Not Updating

✔ Solved with image versioning + redeploy

### ❌ NodePort Not Accessible

✔ Used `kubectl port-forward`

### ❌ Slow Trivy Scan

✔ Optimized scanning + used Snyk cloud scanning

---

## 🧠 Key Lessons

* Security must be integrated early (DevSecOps)
* Fixing vulnerabilities > detecting them
* Kubernetes requires strict version control
* Base image choice impacts security heavily

---

## 🚀 Future Improvements

* CI/CD Pipeline (GitHub Actions)
* AWS EKS / Azure AKS deployment
* Prometheus + Grafana monitoring
* Ingress + HTTPS (TLS)

---

## 🏆 Conclusion

I designed and implemented a **production-aligned DevSecOps workflow**, integrating security from build to deployment and continuous monitoring.

This project demonstrates my ability to:

* Secure containerized applications
* Apply Kubernetes security best practices
* Identify and remediate vulnerabilities
* Troubleshoot real-world deployment issues

---

## 👨‍💻 Author

**Musa Olalekan (Sir Lakewest)**
Cloud Security Engineer | DevSecOps Engineer
# Secure-Kubernetes-Deployment
