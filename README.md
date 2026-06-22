# Wisecow - DevOps Trainee Assessment
Accuknox DevOps Trainee Practical Assessment Submission

## Problem Statement 1: Containerization and Kubernetes Deployment

### Overview
Containerized the Wisecow application and deployed it to a Kubernetes
cluster with an automated CI/CD pipeline and TLS support.

### How to Run Locally (Docker)
1. Build the image:
   docker build -t wisecow:v1 .

2. Run the container:
   docker run -p 4499:4499 wisecow:v1

3. Test it:
   curl http://localhost:4499

### Kubernetes Deployment
1. Apply manifests:
   kubectl apply -f k8s/deployment.yaml
   kubectl apply -f k8s/service.yaml

2. Access the app:
   kubectl port-forward service/wisecow-service 8080:4499
   curl http://localhost:8080

### TLS Setup
Configured TLS using NGINX Ingress Controller and cert-manager
with a self-signed certificate (appropriate for local clusters
without a public domain).

To apply:
   kubectl apply -f k8s/selfsigned-issuer.yaml
   kubectl apply -f k8s/ingress.yaml
   kubectl get certificate

Certificate confirmed issued — kubectl get certificate shows READY: True.

### CI/CD Pipeline
GitHub Actions workflow (.github/workflows/ci-cd.yaml) runs automatically
on every push to main:

- Job 1 (build-and-push):
  Builds the Docker image and pushes it to GitHub Container Registry (ghcr.io)

- Job 2 (deploy):
  Spins up a temporary Kind Kubernetes cluster, applies the manifests,
  updates the deployment with the new image, and verifies the pod is running.

Both jobs confirmed passing (green checkmark in the Actions tab).

---

## Problem Statement 2: Automation Scripts

### Script 1: Log File Analyzer
Location: scripts/log_analyzer.sh

Analyzes web server log files (Apache/Nginx format) and generates
a summarized report showing:
- Total number of requests
- Top 5 most requested pages
- Top 5 IP addresses by request count
- Total number of 404 errors
- Top 5 pages returning 404

Usage:
   sh scripts/log_analyzer.sh <path_to_log_file>

Example:
   sh scripts/log_analyzer.sh /var/log/nginx/access.log

Example output:
   ---- Web Server Log Analysis Report ----
   Total requests: 1500

   Top 5 most requested pages:
   120 /index.html
   95  /about.html
   80  /contact.html

   Top 5 IP addresses:
   45 192.168.1.100
   38 10.0.0.5

   Total 404 errors: 23
   ---- Report Complete ----

### Script 2: Automated Backup Solution
Location: scripts/automated_backup.sh

Backs up a specified directory to a destination folder. Creates a
timestamped .tar.gz archive and logs success or failure to console.

Usage:
   sh scripts/automated_backup.sh <source_directory> <backup_directory>

Example:
   sh scripts/automated_backup.sh /home/user/documents /home/user/backups

Example output:
   ---- Backup Started: 20260622_143000 ----
   SUCCESS: Backup created at /home/user/backups/backup_20260622_143000.tar.gz
   ---- Backup Complete ----

   Failure example:
   ---- Backup Started: 20260622_143000 ----
   FAILED: Backup of /home/user/documents failed
   ---- Backup Complete ----

---

## Repository Structure
wisecow/
├── Dockerfile
├── wisecow.sh
├── k8s/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   └── selfsigned-issuer.yaml
├── .github/
│   └── workflows/
│       └── ci-cd.yaml
├── scripts/
│   ├── log_analyzer.sh
│   └── automated_backup.sh
└── .gitignore