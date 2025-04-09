#!/bin/bash

set -e  # Exit immediately on error

echo "Stopping and removing containers..."
docker-compose down -v

docker rmi -f fuel50_flyway
docker rmi -f postgres

echo "Starting containers in detached mode..."
docker-compose up --build -d

echo "Update complete. Latest images are running."
