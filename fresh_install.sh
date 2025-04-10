#!/bin/bash

set -e

echo "Stop and remove containers, networks, and volumes for project fuel50"
docker-compose --project-name fuel50 down -v  # Stop and remove containers, networks, and volumes for the fuel50 project

echo "Remove the 'data' directory if it exists"
rm -rf data

echo "Pull latest images for project fuel50"
docker-compose --project-name fuel50 pull  # This grabs the latest from GHCR!

echo "Start db container for project fuel50"
docker-compose --project-name fuel50 up -d db  # Start db container for the fuel50 project

echo "Wait for DB to be ready..."
sleep 3

echo "Run Flyway migrations using pulled image for project fuel50"
docker-compose --project-name fuel50 run --rm flyway  # Run Flyway migrations for the fuel50 project

echo "Migration is completed"
