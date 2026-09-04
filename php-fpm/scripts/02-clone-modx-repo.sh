#!/bin/bash
set -e

source /project/.env

SITE_DIR="/var/www/html"

echo "[Step 2] Cloning MODX repository..."

if [ -d "$SITE_DIR/.git" ]; then
    echo "[Step 2] Skipped: MODX already cloned (found .git directory)"
    exit 0
fi

if [ "$(ls -A $SITE_DIR 2>/dev/null)" ]; then
    echo "[Step 2] Skipped: directory $SITE_DIR is not empty"
    exit 0
fi

git clone --branch "$MODX_GIT_BRANCH" --depth 1 "$MODX_GIT_REPO" "$SITE_DIR"
echo "[Step 2] Cloned $MODX_GIT_REPO ($MODX_GIT_BRANCH) to $SITE_DIR"
