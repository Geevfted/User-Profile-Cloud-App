#!/bin/bash

set -e

apt update -y

# Install Docker
apt install -y docker.io

# Start Docker
systemctl enable docker
systemctl start docker

# Install Git
apt install -y git

# Install Docker Compose
apt install -y docker-compose-plugin

cd /home/ubuntu

# Clone only if it doesn't exist
if [ ! -d "mongo-test-project" ]; then
    git clone --branch main https://github.com/geevfted/mongo-test-project.git
fi

cd /home/ubuntu/mongo-test-project

git pull --ff-only origin main

# Always pull the latest image
echo "Updating application..."
docker compose -f docker-compose.prod.yml pull

# Start or update the containers
echo "Starting containers..."
docker compose -f docker-compose.prod.yml up -d

# Remove old unused images
echo "Cleaning old Docker images..."
docker image prune -f

echo "Deployment completed successfully."