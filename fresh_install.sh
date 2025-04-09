#!/bin/bash

set -e

echo "Stop and remove containers, networks, and volumes"
docker-compose down -v

echo "Remove the 'data' directory if it exists"
rm -rf data

echo "Remove images if they exist, no error if not found"
docker rmi -f fuel50_flyway || true
docker rmi -f postgres || true

echo "Rebuild and bring up the containers in detached mode"
docker-compose up --build -d
echo "Update complete. Latest images are running."

