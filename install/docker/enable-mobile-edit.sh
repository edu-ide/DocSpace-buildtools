#!/bin/bash
# UGOTOFFICE - Enable mobile editing in ONLYOFFICE DocumentServer
# This script patches the license check to enable mobile web editing

set -e

echo "🔧 UGOTOFFICE: Enabling mobile editing..."

# DocumentServer app.js 파일 경로
APP_PATHS=(
    "/var/www/onlyoffice/documentserver/web-apps/apps/documenteditor/mobile/app.js"
    "/var/www/onlyoffice/documentserver/web-apps/apps/spreadsheeteditor/mobile/app.js"
    "/var/www/onlyoffice/documentserver/web-apps/apps/presentationeditor/mobile/app.js"
)

PATTERN='isSupportEditFeature=function(){return!1}'
REPLACEMENT='isSupportEditFeature=function(){return 1}'

for APP_PATH in "${APP_PATHS[@]}"; do
    if [ -f "$APP_PATH" ]; then
        echo "  ✓ Patching: $APP_PATH"
        sed -i "s/${PATTERN}/${REPLACEMENT}/g" "$APP_PATH"
    else
        echo "  ⚠ Warning: File not found - $APP_PATH"
    fi
done

echo "✅ Mobile editing enabled successfully!"
