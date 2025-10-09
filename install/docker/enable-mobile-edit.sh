#!/bin/bash
# UGOTOFFICE - Enable mobile editing and remove connection limits in ONLYOFFICE DocumentServer
# This script patches the license checks to enable mobile web editing and unlimited connections

set -e

echo "🔧 UGOTOFFICE: Applying customizations..."

# 1. Enable mobile editing
echo "  📱 Enabling mobile editing..."

APP_PATHS=(
    "/var/www/onlyoffice/documentserver/web-apps/apps/documenteditor/mobile/app.js"
    "/var/www/onlyoffice/documentserver/web-apps/apps/spreadsheeteditor/mobile/app.js"
    "/var/www/onlyoffice/documentserver/web-apps/apps/presentationeditor/mobile/app.js"
)

PATTERN='isSupportEditFeature=function(){return!1}'
REPLACEMENT='isSupportEditFeature=function(){return 1}'

for APP_PATH in "${APP_PATHS[@]}"; do
    if [ -f "$APP_PATH" ]; then
        echo "    ✓ Patching: $APP_PATH"
        sed -i "s/${PATTERN}/${REPLACEMENT}/g" "$APP_PATH"
    else
        echo "    ⚠ Warning: File not found - $APP_PATH"
    fi
done

# 2. Remove connection limit
echo "  🔓 Removing connection limit..."

LICENSE_JS="/var/www/onlyoffice/documentserver/server/Common/sources/license.js"

if [ -f "$LICENSE_JS" ]; then
    # Patch 1: Set unlimited connections
    if grep -q "connectionLimit" "$LICENSE_JS" 2>/dev/null; then
        echo "    ✓ Patching connection limit in license.js"
        # Change connection limit check to always return unlimited
        sed -i 's/this\.connections\s*>=\s*this\.connectionLimit/false/g' "$LICENSE_JS"
        sed -i 's/connectionLimit:\s*[0-9]\+/connectionLimit: 999999/g' "$LICENSE_JS"
    fi

    # Patch 2: Set unlimited users
    if grep -q "usersCount" "$LICENSE_JS" 2>/dev/null; then
        echo "    ✓ Patching user limit in license.js"
        sed -i 's/usersCount:\s*[0-9]\+/usersCount: 999999/g' "$LICENSE_JS"
    fi
else
    echo "    ⚠ Warning: license.js not found - $LICENSE_JS"
fi

# 3. Patch license checker (alternative location)
LICENSE_CHECKER="/var/www/onlyoffice/documentserver/server/license/license.js"

if [ -f "$LICENSE_CHECKER" ]; then
    echo "    ✓ Patching license checker"
    sed -i 's/exports\.connections\s*=\s*[0-9]\+/exports.connections = 999999/g' "$LICENSE_CHECKER"
    sed -i 's/this\.maxConnections\s*=\s*[0-9]\+/this.maxConnections = 999999/g' "$LICENSE_CHECKER"
fi

echo "✅ All customizations applied successfully!"
echo "  📱 Mobile editing: Enabled"
echo "  🔓 Connection limit: Removed (999999)"
