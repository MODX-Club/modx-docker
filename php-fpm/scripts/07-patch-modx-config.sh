#!/bin/bash
set -e

source /project/.env

SITE_DIR="/var/www/html"
CONFIG_FILE="$SITE_DIR/core/config/config.inc.php"

echo "[Step 7] Patching MODX config..."

if [ ! -f "$CONFIG_FILE" ]; then
    echo "[Step 7] Error: config file not found at $CONFIG_FILE"
    exit 1
fi

# Check if already patched
if grep -q "getenv('MYSQL_HOST')" "$CONFIG_FILE"; then
    echo "[Step 7] Skipped: config already patched"
    exit 0
fi

# Patch database_server to use getenv
sed -i "s/\$database_server = '\([^']*\)';/\$database_server = getenv('MYSQL_HOST') ?: '\1';/" "$CONFIG_FILE"

# Patch database_user to use getenv
sed -i "s/\$database_user = '\([^']*\)';/\$database_user = getenv('MYSQL_USER') ?: '\1';/" "$CONFIG_FILE"

# Patch database_password to use getenv
sed -i "s/\$database_password = '\([^']*\)';/\$database_password = getenv('MYSQL_PASSWORD') ?: '\1';/" "$CONFIG_FILE"

echo "[Step 7] Config patched with getenv() for database credentials"
