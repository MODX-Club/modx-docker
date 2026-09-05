#!/bin/bash
set -e

source /project/.env

# Clone packages into MODX directory for building
PACKAGES_SRC_DIR="/var/www/html/_packages"
LOCK_FILE="$PACKAGES_SRC_DIR/.cloned"

echo "[Step 8] Cloning package repositories..."

if [ -f "$LOCK_FILE" ]; then
    echo "[Step 8] Skipped: packages already cloned"
    exit 0
fi

mkdir -p "$PACKAGES_SRC_DIR"
cd "$PACKAGES_SRC_DIR"


# echo "[Step 8] Cloning pdoTools..."
# git clone https://github.com/modx-pro/pdoTools.git pdoTools
# cd pdoTools
# git checkout 613aef7a7ed39b53ff19fa0d256d2c314784658f
# cd ..

echo "[Step 8] Cloning pdoTools (3x-new branch)..."
git clone --depth 1 --branch 3x-new https://github.com/modx-pro/pdoTools.git pdoTools

# echo "[Step 8] Cloning VueTools..."
git clone --depth 1 https://github.com/modx-pro/vueTools.git vueTools

# echo "[Step 8] Cloning MiniShop3..."
git clone --depth 1 https://github.com/modx-pro/MiniShop3.git MiniShop3

touch "$LOCK_FILE"
echo "[Step 8] Package repositories cloned"
