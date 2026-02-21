# FastAPI CI/CD on AWS (Production-Grade DevOps Project)

## Overview

This project demonstrates a production-grade CI/CD pipeline that automatically builds, tests, containerizes, and deploys a FastAPI application to AWS using Jenkins and Terraform.

The pipeline deploys the application to **Amazon ECS Fargate** behind an **Application Load Balancer** with zero manual intervention.

---

## Architecture

![Architecture](architecture.png)

**Flow:**

1. Developer pushes code to GitHub
2. Jenkins pipeline triggers
3. Run tests (pytest)
4. Build Docker image
5. Push image to Amazon ECR
6. Update ECS service
7. ECS pulls latest image and deploys automatically
8. Application served via ALB

---

## Technologies Used

* Python (FastAPI)
* Docker
* Jenkins
* Terraform
* AWS ECR
* AWS ECS Fargate
* Application Load Balancer
* VPC (public + private subnets)
* IAM

---

## Infrastructure (Terraform)

Terraform provisions:

* VPC with public and private subnets
* Internet Gateway
* Application Load Balancer
* Target Group
* ECS Cluster
* ECS Service (Fargate)
* ECR Repository
* IAM Roles and Policies

---

## CI/CD Pipeline (Jenkins)

Pipeline stages:

1. Install dependencies
2. Run tests
3. Build Docker image
4. Authenticate to ECR
5. Push image
6. Deploy to ECS (force new deployment)

---

## Application Endpoints

* `/` – Main endpoint
* `/health` – Health check for ALB

---

## How to Deploy

### 1. Provision Infrastructure

```
cd terraform
terraform init
terraform apply
```

### 2. Configure Jenkins

* Add GitHub repository
* Configure pipeline: **Pipeline script from SCM**
* Script path: `Jenkinsfile`

### 3. Push Code

Any push to `main` will trigger automatic deployment.

---

## Key DevOps Features

* Infrastructure as Code
* Immutable Docker deployments
* Automated testing
* Automated container build and deployment
* Zero-downtime rolling updates
* Private ECS networking
* Health-check based traffic routing

