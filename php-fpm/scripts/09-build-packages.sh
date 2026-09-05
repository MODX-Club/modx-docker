#!/bin/bash
set -e

source /project/.env

# Packages are cloned into MODX directory for building
PACKAGES_SRC_DIR="/var/www/html/_packages"
SITE_DIR="/var/www/html"
PACKAGES_DIR="$SITE_DIR/core/packages"
LOCK_FILE="$PACKAGES_DIR/.packages-built"

echo "[Step 9] Building packages from source..."

if [ -f "$LOCK_FILE" ]; then
    echo "[Step 9] Skipped: packages already built"
    exit 0
fi

if [ ! -d "$PACKAGES_SRC_DIR/pdoTools" ]; then
    echo "[Step 9] Error: package sources not found. Run step 8 first."
    exit 1
fi

mkdir -p "$PACKAGES_DIR"

# MODX 3 moved modPackageBuilder to namespace but deprecated.php doesn't include alias
# We need to add it before running build scripts
MODX_DEPRECATED="$SITE_DIR/core/include/deprecated.php"
if ! grep -q "modPackageBuilder" "$MODX_DEPRECATED" 2>/dev/null; then
    echo "[Step 9] Adding modPackageBuilder alias to deprecated.php..."
    echo "" >> "$MODX_DEPRECATED"
    echo "// Added for package building compatibility" >> "$MODX_DEPRECATED"
    echo "class_alias(\MODX\Revolution\Transport\modPackageBuilder::class, \modPackageBuilder::class);" >> "$MODX_DEPRECATED"
fi

# Build scripts create packages directly in MODX core/packages/ directory
# No need to copy - they're already in the right place

echo "[Step 9] Building pdoTools..."
cd "$PACKAGES_SRC_DIR/pdoTools"
cd core/components/pdotools
composer install --no-dev --quiet
cd ../../..
php _build/build.transport.php
ls -la "$PACKAGES_DIR"/pdotools-*.transport.zip

echo "[Step 9] Building VueTools..."
cd "$PACKAGES_SRC_DIR/vueTools"
npm install --silent
npm run build:all --silent
php _build/build.php
ls -la "$PACKAGES_DIR"/vuetools-*.transport.zip

# echo "[Step 9] Building MiniShop3..."
cd "$PACKAGES_SRC_DIR/MiniShop3"
cd core/components/minishop3
composer install --no-dev --quiet
cd ../../..
cd vueManager
npm install --silent
npm run build --silent
cd ..
php _build/build.php
ls -la "$PACKAGES_DIR"/minishop3-*.transport.zip

touch "$LOCK_FILE"
echo "[Step 9] All packages built successfully"
