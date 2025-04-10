#!/bin/bash

set -e  # Exit immediately on error

echo "Stopping and removing containers, but keep data volume for project fuel50"
docker-compose --project-name fuel50 down  # Stop and remove containers, but keep data volume for fuel50 project

echo "Pull the latest image with updated migrations for project fuel50"
docker-compose --project-name fuel50 pull  # Pull the latest images for fuel50 project

echo "Start db container for project fuel50"
docker-compose --project-name fuel50 up -d db  # Start db container for the fuel50 project

echo "Wait for DB to become ready..."
sleep 3

echo "Run Flyway migrations (incremental) for project fuel50"
docker-compose --project-name fuel50 run --rm flyway  # Run Flyway migrations for fuel50 project

echo "Update complete. Latest images are running for project fuel50."

echo "Migration is completed"
