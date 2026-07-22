#!/bin/bash

set -e

apt update -y

# Install Docker
apt install -y docker.io

systemctl enable docker
systemctl start docker

# Install Docker Compose V2
apt install -y docker-compose-v2

# Verify Docker Compose installation
docker compose version

# Allow ubuntu user to use Docker
usermod -aG docker ubuntu

# Create deployment directory
mkdir -p /opt/profile-app

# Make ubuntu the owner of the directory
chown ubuntu:ubuntu /opt/profile-app

# Create docker-compose.prod.yml
cat <<EOF >/opt/profile-app/docker-compose.prod.yml

services:
  app:
    image: ghcr.io/geevfted/user-profile-cloud-app:latest

    container_name: profile-app

    restart: unless-stopped

    ports:
      - "3000:3000"

    env_file:
      - .env.production
EOF