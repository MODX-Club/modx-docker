#!/bin/bash
set -e

source /project/.env

SITE_DIR="/var/www/html"
BUILD_DIR="$SITE_DIR/_build"
CORE_TRANSPORT="$SITE_DIR/core/packages/core.transport.zip"

echo "[Step 5] Building core transport package..."

if [ ! -d "$BUILD_DIR" ]; then
    echo "[Step 5] Skipped: no _build directory"
    exit 0
fi

if [ -f "$CORE_TRANSPORT" ]; then
    echo "[Step 5] Skipped: core.transport.zip already exists"
    exit 0
fi

# Create build.config.php
cat > "$BUILD_DIR/build.config.php" <<EOF
<?php
define('MODX_CORE_PATH', dirname(__DIR__) . '/core/');
define('MODX_CONFIG_KEY', 'config');
define('XPDO_DSN', 'mysql:host=$MYSQL_HOST;dbname=$MYSQL_DATABASE;charset=utf8');
define('XPDO_DB_USER', '$MYSQL_USER');
define('XPDO_DB_PASS', '$MYSQL_PASSWORD');
define('XPDO_TABLE_PREFIX', '$MYSQL_TABLE_PREFIX');
EOF

# Create build.properties.php
cat > "$BUILD_DIR/build.properties.php" <<'EOF'
<?php
use xPDO\xPDO;
$properties['cache_path'] = MODX_CORE_PATH . '/' . (MODX_CONFIG_KEY === 'config' ? '' : MODX_CONFIG_KEY . '/') . 'cache/';
$properties['mysql_string_dsn_test'] = XPDO_DSN;
$properties['mysql_string_dsn_nodb'] = preg_replace('/dbname=[^;]+;?/', '', XPDO_DSN);
$properties['mysql_string_dsn_error'] = 'mysql:host=nonesuchhost;dbname=nonesuchdb';
$properties['mysql_string_username'] = XPDO_DB_USER;
$properties['mysql_string_password'] = XPDO_DB_PASS;
$properties['mysql_array_options'] = [
    xPDO::OPT_CACHE_PATH => $properties['cache_path'],
    xPDO::OPT_HYDRATE_FIELDS => true,
    xPDO::OPT_HYDRATE_RELATED_OBJECTS => true,
    xPDO::OPT_HYDRATE_ADHOC_FIELDS => true,
];
$properties['mysql_array_driverOptions'] = [\PDO::ATTR_ERRMODE => \PDO::ERRMODE_SILENT];
$properties['xpdo_driver'] = 'mysql';
$properties['logLevel'] = xPDO::LOG_LEVEL_INFO;
EOF

cd "$BUILD_DIR"
php transport.core.php
echo "[Step 5] Core transport package built"
