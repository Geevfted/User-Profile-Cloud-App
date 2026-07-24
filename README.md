# Cloud Profile App

**Version:** v1.1.0
**Status:** Active Development

A cloud-native profile management application built with **Node.js**, **AWS**, **Terraform**, **Docker**, and **GitHub Actions** to demonstrate modern Cloud Engineering and DevOps practices.

---

## Overview

Cloud Profile App is a full-stack cloud project that demonstrates how to provision infrastructure, deploy applications, and integrate managed cloud services using AWS.

The project provisions AWS infrastructure with Terraform, deploys a Dockerized Node.js application to Amazon EC2 through GitHub Actions, stores user profile information in MongoDB Atlas, and manages profile images in Amazon S3.

---

## Features

* User profile management
* Upload profile images to Amazon S3
* Retrieve profile images from Amazon S3
* Store user data in MongoDB Atlas
* Automated deployment with GitHub Actions
* Infrastructure provisioned with Terraform
* Dockerized application
* IAM Role authentication (no hardcoded AWS credentials)

---

## Technology Stack

### Backend

* Node.js
* Express.js
* MongoDB Driver

### Cloud Services

* Amazon EC2
* Amazon S3
* IAM Roles
* VPC
* Security Groups

### DevOps

* Terraform
* Docker
* Docker Compose
* GitHub Actions
* GitHub Container Registry (GHCR)

### Database

* MongoDB Atlas

---

## Project Structure

```text
.
├── .github/
│   └── workflows/
├── terraform/
├── scripts/
├── images/
├── server.js
├── s3.js
├── package.json
├── docker-compose.yml
├── docker-compose.prod.yml
├── Dockerfile
└── README.md
```

---

## Deployment Architecture

```text
Developer
     │
     ▼
GitHub Repository
     │
     ▼
GitHub Actions
     │
     ▼
GitHub Container Registry (GHCR)
     │
     ▼
Amazon EC2 (Docker)
     │
     ├────────► MongoDB Atlas
     │
     └────────► Amazon S3
```

---

## Infrastructure

Provisioned using Terraform:

* Amazon VPC
* Public Subnet
* Internet Gateway
* Route Table
* Security Group
* EC2 Instance
* IAM Role
* IAM Instance Profile
* IAM Policies
* Amazon S3 Bucket

---

## CI/CD Pipeline

The deployment pipeline automatically performs the following:

1. Push code to GitHub.
2. Build the Docker image.
3. Push the image to GitHub Container Registry.
4. Connect securely to the EC2 instance using SSH.
5. Pull the latest Docker image.
6. Restart the application with Docker Compose.

---

## Environment Variables

The application uses the following environment variables:

```env
PORT=
DATABASE=
MONGO_URL=
AWS_REGION=
S3_BUCKET=
```

Production values are securely stored using GitHub Secrets.

---

## Current Progress

* [x] Dockerized application
* [x] Infrastructure as Code with Terraform
* [x] GitHub Actions CI
* [x] GitHub Actions CD
* [x] Amazon EC2 deployment
* [x] MongoDB Atlas integration
* [x] Amazon S3 integration
* [x] IAM Role authentication
* [x] Automatic deployments

---

## Roadmap

Upcoming improvements:

* Reverse Proxy with Nginx
* HTTPS with Let's Encrypt
* Custom Domain
* AWS CloudWatch Monitoring
* Secrets Manager / Parameter Store
* Application Load Balancer
* Auto Scaling
* Amazon ECS
* Amazon ECR
* AWS Fargate
* Infrastructure Monitoring
* Production Hardening

---

## Author

**JAY**

Cloud Engineer | AWS | Terraform | Docker | GitHub Actions
