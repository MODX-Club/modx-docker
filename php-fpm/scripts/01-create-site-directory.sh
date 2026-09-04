#!/bin/bash
set -e

source /project/.env

SITE_DIR="/var/www/html"

echo "[Step 1] Creating site directory..."

if [ -d "$SITE_DIR" ] && [ "$(ls -A $SITE_DIR 2>/dev/null)" ]; then
    echo "[Step 1] Skipped: directory $SITE_DIR already exists and not empty"
    exit 0
fi

mkdir -p "$SITE_DIR"
echo "[Step 1] Created directory $SITE_DIR"
