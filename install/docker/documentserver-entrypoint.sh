#!/bin/bash
# UGOTOFFICE - Custom DocumentServer entrypoint
# Enables mobile editing before starting the server

set -e

echo "🚀 UGOTOFFICE DocumentServer starting..."

# Enable mobile editing if app.js files exist
if [ -f "/var/www/onlyoffice/documentserver/web-apps/apps/documenteditor/mobile/app.js" ]; then
    /usr/local/bin/enable-mobile-edit.sh
else
    echo "⏳ Waiting for DocumentServer files to be ready..."
    sleep 5
    if [ -f "/var/www/onlyoffice/documentserver/web-apps/apps/documenteditor/mobile/app.js" ]; then
        /usr/local/bin/enable-mobile-edit.sh
    else
        echo "⚠️  Warning: DocumentServer files not found. Mobile editing may not be enabled."
    fi
fi

# Execute original entrypoint or CMD
exec "$@"
