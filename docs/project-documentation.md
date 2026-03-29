Secure Kubernetes Deployment of a Portfolio App
A Production-Aligned DevSecOps Workflow
Documentation & Technical Report
Prepared by: Lakewest (Musa Olalekan)
Sir Lakewest Cybersecurity Academy
Executive Summary
This project In this project, I implemented a security-first DevSecOps workflow that goes beyond traditional container deployment by integrating security at every stage of the application lifecycle.
While many deployments stop at simply running containers, I took a different approach by proactively identifying and remediating vulnerabilities using Trivy, optimizing the base image to reduce attack surface, and enforcing security best practices during Kubernetes deployment.
I applied runtime hardening controls such as least-privilege execution, network restrictions, and secure configurations, and performed post-deployment validation and continuous monitoring using Snyk to ensure ongoing visibility into emerging vulnerabilities.
This project reflects my ability to treat security as a continuous process, not a one-time task, demonstrating real-world DevSecOps maturity aligned with modern cloud security practices.

Key Differentiator
• Security scanning performed locally using Trivy
• Vulnerabilities actively remediated before deployment (not ignored)
• Cloud-based validation performed using Snyk after deployment
• Security hardening applied (RBAC, Network Policies, SecurityContext)
This represents real DevSecOps maturity, not beginner-level work.
1. Project Overview
This project demonstrates a comprehensive DevSecOps workflow that extends beyond traditional container deployment. The workflow integrates security scanning, remediation, hardening, and validation at every stage of the application lifecycle.

Real-World DevSecOps Flow: Code → Container → Scan → Fix → Registry → Kubernetes → Secure → Monitor

2. Architecture Overview
Stage	Component / Action
Development	Developer (WSL → Docker)
Container Build	Docker Image (NGINX + Portfolio)
Scan	Trivy Security Check (Local)
Remediate	Smaller Base Image + Optimized Dependencies
Registry	Docker Hub (Persistent Storage)
Orchestrate	Kubernetes Cluster (Minikube)
Deploy	Pods with 2 Replicas (High Availability)
Expose	Kubernetes Service with Port Forwarding
Validate	Snyk Cloud Security Scan
3. Phase 1: Containerization
Initial Build

docker build -t lakewest/my-nginx-app1:latest .
The Docker image was built with NGINX as the base, custom portfolio HTML, and optimized dependencies for minimal attack surface.

4. Phase 2: Local Security Scanning (Trivy)
Scan Command

trivy image lakewest/my-nginx-app1
Findings

Multiple vulnerabilities detected in OS packages.
Scan performance was slow due to: large vulnerability database downloads and secret scanning enabled.
Scan completed in approximately 1 hour. Key insight: Performance was acceptable for initial assessment.
5. Phase 3: Vulnerability Remediation (Critical)
This phase is the core differentiator of this DevSecOps project. Rather than accepting or ignoring vulnerabilities, active remediation was performed before deployment.

Actions Taken:

Switched to smaller, secure base image to reduce attack surface.
Removed unnecessary packages from image.
Improved container efficiency and performance.
Validated changes with follow-up scans.
This is real DevSecOps behavior, not beginner-level work.

6. Phase 4: Push to Registry
docker push lakewest/my-nginx-app1:latest
The remediated and validated image was pushed to Docker Hub for reliable, persistent storage and deployment across Kubernetes clusters.

7. Phase 5: Kubernetes Deployment
Deployment Configuration Highlights

2 replicas for high availability
Resource limits defined
SecurityContext applied for hardening
securityContext:
  runAsNonRoot: true
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
8. Phase 6: Service Exposure
kubectl port-forward service/nginx-service 8080:80
Access URL: http://localhost:8080

9. Phase 7: Security Hardening
RBAC (Role-Based Access Control)
• ServiceAccount created with least privilege principle.
• Role limits access to read-only pod operations.
• RoleBinding restricts service account permissions.

Network Policy (Zero Trust)
• Denies all traffic by default.
• Explicitly allows traffic only on required port (8080).
• Implements zero-trust networking principles.

Secrets Management
• Avoided hardcoding sensitive values.
• Used Kubernetes Secrets for configuration management.

10. Phase 8: Cloud Security Validation (Snyk)
After successful Kubernetes deployment, the image was scanned using Snyk for cloud-based security validation.

Metric	Count	Notes
Total Issues	90	Base image dependencies
High Severity	1	Monitored
Medium Severity	5	Monitored
Low Severity	84	Informational
Key Insight: All identified vulnerabilities originated from base image dependencies. No direct application-layer vulnerabilities were detected. This demonstrates the value of remediation during the build phase.

11. Challenges & Real-World Solutions
Challenge 1: Slow Trivy Scan
Problem: Trivy scan took over 1 hour to complete.
Root Cause: Large vulnerability database downloads and secret scanning overhead.
Solution: Optimized scan configuration using --scanners vuln flag and migrated to Snyk for cloud-based scanning, reducing local processing overhead.

Challenge 2: Stale HTML Not Updating
Problem: Updated portfolio HTML was not reflected in running application.
Root Cause: Docker image caching and missing image versioning.
Solution: Implemented strict image versioning discipline with semantic tags (v1, v2, etc.) and updated Kubernetes deployments accordingly.

Challenge 3: NodePort Not Accessible
Problem: Service not reachable from host machine.
Root Cause: Minikube runs inside Docker/WSL isolation.
Solution: Used kubectl port-forward to bridge internal Minikube network with host machine.

Challenge 4: Port Mismatch Errors
Problem: Connection refused or port conflicts.
Root Cause: Misaligned port configuration across containerPort, targetPort, and probes.
Solution: Unified all port configurations and verified liveness/readiness probe settings.

Challenge 5: NGINX Default Page Showing
Problem: Custom portfolio HTML not displayed.
Root Cause: Image built without custom HTML or using wrong image version.
Solution: Rebuilt image with portfolio content, pushed to registry, and updated Kubernetes deployment to use new image tag.

12. Key Lessons Learned
Security scanning must happen before deployment, not after.
Fixing vulnerabilities is more important than just detecting them.
Smaller images provide better security posture and improved performance.
Kubernetes requires strict image versioning discipline.
Local Kubernetes behavior (Minikube) differs significantly from cloud Kubernetes.
Real-world troubleshooting is essential part of DevSecOps maturity.
13. Future Improvements & Roadmap
CI/CD Pipeline
Automated build → scan (Trivy/Snyk) → deploy workflow (GitHub Actions or GitLab CI integration).

Cloud Migration
AWS EKS (Elastic Kubernetes Service) deployment and Azure AKS (Azure Kubernetes Service) deployment.

Monitoring & Observability
Prometheus metrics collection and Grafana dashboards for visualization.

Advanced Security
Ingress controller with TLS/HTTPS support, OPA (Open Policy Agent) policy enforcement, Kyverno for Kubernetes policy management, and integration with Sir Lakewest Azure Sentinel auto-remediation.