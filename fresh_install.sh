#!/bin/bash

set -e

echo "Stop and remove containers, networks, and volumes"
docker-compose down -v

echo "Remove the 'data' directory if it exists"
rm -rf data

echo "Pull latest images"
docker-compose pull  # This grabs the latest from GHCR!

echo "Start db container"
docker-compose up -d db

echo "Wait for DB to be ready..."
sleep 3

echo "Run Flyway migrations using pulled image"
docker-compose run --rm flyway

echo "Migration is completed"