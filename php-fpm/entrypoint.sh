#!/bin/bash
set -e

# Run full MODX installation (idempotent - skips completed steps)
/scripts/install-modx.sh || echo "MODX installation failed or skipped"

# Run php-fpm
exec php-fpm
