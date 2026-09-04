#!/bin/bash
set -e

source /project/.env

SITE_DIR="/var/www/html"
COMPOSER_JSON="$SITE_DIR/composer.json"
VENDOR_DIR="$SITE_DIR/core/vendor"

echo "[Step 4] Installing Composer dependencies..."

if [ ! -f "$COMPOSER_JSON" ]; then
    echo "[Step 4] Skipped: no composer.json found"
    exit 0
fi

if [ -d "$VENDOR_DIR" ]; then
    echo "[Step 4] Skipped: vendor directory already exists"
    exit 0
fi

cd "$SITE_DIR"
composer install --no-interaction --no-dev
echo "[Step 4] Composer dependencies installed"
