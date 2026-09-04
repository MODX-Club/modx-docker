#!/bin/bash
set -e

echo "Starting Docker daemon..."
dockerd-entrypoint.sh &

echo "Waiting for Docker daemon to be ready..."
until docker info >/dev/null 2>&1; do
  sleep 1
done

echo "Docker daemon is ready"

cd /project

echo "Building and starting docker-compose services..."
docker-compose build
docker-compose up -d

echo "Services started. Keeping container alive..."
tail -f /dev/null
