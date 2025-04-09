#!/bin/bash

set -e  # Exit immediately on error

echo "Stopping and removing containers, but keep data volume"
docker-compose down

echo "Pull the latest image with updated migrations"
docker-compose pull

echo "Start db container"
docker-compose up -d db

echo "Wait for DB to become ready..."
sleep 3

echo "Run Flyway migrations (incremental)"
docker-compose run --rm flyway

echo "Update complete. Latest images are running."

echo "Migration is completed"