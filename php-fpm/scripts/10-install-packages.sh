#!/bin/bash
set -e

source /project/.env

SITE_DIR="/var/www/html"
LOCK_FILE="$SITE_DIR/core/cache/.packages-installed"

echo "[Step 10] Installing packages..."

if [ -f "$LOCK_FILE" ]; then
    echo "[Step 10] Skipped: packages already installed"
    exit 0
fi

if [ ! -f "$SITE_DIR/core/config/config.inc.php" ]; then
    echo "[Step 10] Error: MODX not installed. Run step 6 first."
    exit 1
fi

cd "$SITE_DIR"

php -r '
define("MODX_API_MODE", true);
require_once "index.php";

$modx->getService("error", "error.modError");
$modx->setLogLevel(modX::LOG_LEVEL_INFO);
$modx->setLogTarget("ECHO");

$packagesDir = MODX_CORE_PATH . "packages/";
$packages = ["pdotools", "vuetools", "minishop3"];

foreach ($packages as $packageName) {
    echo "Installing $packageName...\n";
    
    // Find transport file
    $files = glob($packagesDir . $packageName . "-*.transport.zip");
    if (empty($files)) {
        echo "ERROR: Package file not found for $packageName\n";
        continue;
    }
    
    $file = basename(end($files));
    $signature = str_replace(".transport.zip", "", $file);
    
    // Check if already installed
    $installed = $modx->getObject("transport.modTransportPackage", [
        "signature" => $signature
    ]);
    
    if ($installed) {
        echo "$packageName already installed, skipping\n";
        continue;
    }
    
    // Parse signature
    $sig = explode("-", $signature);
    $packageNameParsed = $sig[0];
    $versionParts = isset($sig[1]) ? explode(".", $sig[1]) : [0, 0, 0];
    
    // Create package record
    $package = $modx->newObject("transport.modTransportPackage");
    $package->set("signature", $signature);
    $package->set("source", $file);
    $package->set("package_name", $packageNameParsed);
    $package->set("version_major", $versionParts[0] ?? 0);
    $package->set("version_minor", $versionParts[1] ?? 0);
    $package->set("version_patch", $versionParts[2] ?? 0);
    $package->set("workspace", 1);
    $package->set("created", date("Y-m-d H:i:s"));
    $package->set("provider", 0);
    
    if (isset($sig[2])) {
        $r = preg_split("/([0-9]+)/", $sig[2], -1, PREG_SPLIT_DELIM_CAPTURE);
        if (is_array($r) && !empty($r)) {
            $package->set("release", $r[0]);
            $package->set("release_index", isset($r[1]) ? $r[1] : 0);
        }
    }
    
    if (!$package->save()) {
        echo "ERROR: Could not save package record for $packageName\n";
        continue;
    }
    
    // Install package
    $installed = $package->install();
    if ($installed) {
        echo "$packageName installed successfully\n";
    } else {
        echo "ERROR: Failed to install $packageName\n";
    }
}

echo "Package installation complete\n";
'

touch "$LOCK_FILE"
echo "[Step 10] All packages installed"
