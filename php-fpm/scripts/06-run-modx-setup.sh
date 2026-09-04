#!/bin/bash
set -e

source /project/.env

SITE_DIR="/var/www/html"
SETUP_DIR="$SITE_DIR/setup"
CONFIG_FILE="$SITE_DIR/core/config/config.inc.php"

echo "[Step 6] Running MODX setup..."

if [ ! -d "$SETUP_DIR" ]; then
    echo "[Step 6] Skipped: no setup directory"
    exit 0
fi

if [ -f "$CONFIG_FILE" ]; then
    echo "[Step 6] Skipped: MODX already configured"
    exit 0
fi

# Create config.xml
cat > "$SETUP_DIR/config.xml" <<EOF
<modx>
    <database_type>mysql</database_type>
    <database_server>$MYSQL_HOST</database_server>
    <database>$MYSQL_DATABASE</database>
    <database_user>$MYSQL_USER</database_user>
    <database_password>$MYSQL_PASSWORD</database_password>
    <database_connection_charset>utf8mb4</database_connection_charset>
    <database_charset>utf8mb4</database_charset>
    <database_collation>utf8mb4_general_ci</database_collation>
    <table_prefix>$MYSQL_TABLE_PREFIX</table_prefix>
    <https_port>443</https_port>
    <http_host>$SITE_DOMAIN</http_host>
    <cache_disabled>0</cache_disabled>

    <inplace>1</inplace>
    <unpacked>0</unpacked>
    <language>en</language>

    <cmsadmin>$MODX_ADMIN_USER</cmsadmin>
    <cmspassword>$MODX_ADMIN_PASSWORD</cmspassword>
    <cmsadminemail>$MODX_ADMIN_EMAIL</cmsadminemail>

    <core_path>$SITE_DIR/core/</core_path>
    <context_mgr_path>$SITE_DIR/manager/</context_mgr_path>
    <context_mgr_url>/manager/</context_mgr_url>
    <context_connectors_path>$SITE_DIR/connectors/</context_connectors_path>
    <context_connectors_url>/connectors/</context_connectors_url>
    <context_web_path>$SITE_DIR/</context_web_path>
    <context_web_url>/</context_web_url>

    <remove_setup_directory>1</remove_setup_directory>
</modx>
EOF

cd "$SITE_DIR"
php setup/index.php --installmode=new
echo "[Step 6] MODX setup completed"
