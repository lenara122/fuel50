#!/bin/bash

set -e  # Exit immediately on error

echo "Stopping and removing containers..."
docker-compose down

echo "Pulling latest Docker images..."
docker-compose pull

echo "Starting containers in detached mode..."
docker-compose up -d

echo "Update complete. Latest images are running."
