#!/bin/bash
set -e

source /project/.env

echo "[Step 3] Creating database..."
echo "[Step 3] MYSQL_HOST=$MYSQL_HOST, MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD"

# Wait for MySQL to be ready
echo "[Step 3] Waiting for MySQL to be ready..."
MYSQL_OPTS="--skip-ssl"

for i in {1..30}; do
    if mysql $MYSQL_OPTS -h"$MYSQL_HOST" -uroot -p"$MYSQL_ROOT_PASSWORD" -e "SELECT 1" >/dev/null 2>&1; then
        echo "[Step 3] MySQL is ready"
        break
    fi
    echo "[Step 3] Waiting for MySQL... ($i/30)"
    sleep 2
done

# Check if database exists
DB_EXISTS=$(mysql $MYSQL_OPTS -h"$MYSQL_HOST" -uroot -p"$MYSQL_ROOT_PASSWORD" -e "SHOW DATABASES LIKE '$MYSQL_DATABASE';" | grep -c "$MYSQL_DATABASE" || true)

if [ "$DB_EXISTS" -gt 0 ]; then
    echo "[Step 3] Skipped: database $MYSQL_DATABASE already exists"
    exit 0
fi

mysql $MYSQL_OPTS -h"$MYSQL_HOST" -uroot -p"$MYSQL_ROOT_PASSWORD" <<EOF
CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
EOF

echo "[Step 3] Database $MYSQL_DATABASE and user $MYSQL_USER created"
