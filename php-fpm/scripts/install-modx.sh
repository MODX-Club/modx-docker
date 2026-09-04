#!/bin/bash
set -e

SCRIPTS_DIR="$(dirname "$0")"

echo "=========================================="
echo "Starting MODX installation..."
echo "=========================================="

run_as_appuser() {
    if [ "$(id -u)" = "0" ] && id appuser >/dev/null 2>&1; then
        gosu appuser "$@"
    else
        "$@"
    fi
}

# Step 1-2: File operations - run as appuser
run_as_appuser $SCRIPTS_DIR/01-create-site-directory.sh
run_as_appuser $SCRIPTS_DIR/02-clone-modx-repo.sh

# Step 3: Database - needs root for mysql client
$SCRIPTS_DIR/03-create-database.sh

# Step 4-7: PHP/file operations - run as appuser
run_as_appuser $SCRIPTS_DIR/04-install-composer-deps.sh
run_as_appuser $SCRIPTS_DIR/05-build-core-transport.sh
run_as_appuser $SCRIPTS_DIR/06-run-modx-setup.sh
run_as_appuser $SCRIPTS_DIR/07-patch-modx-config.sh

echo "=========================================="
echo "MODX installation completed!"
echo "=========================================="
