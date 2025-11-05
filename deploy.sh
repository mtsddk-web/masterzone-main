#!/bin/bash

# Deployment script for masterzone.edu.pl to Zenbox hosting
# Usage: ./deploy.sh

set -e

echo "🚀 MasterZone.edu.pl Deployment Script"
echo "======================================"
echo ""

# Load FTP credentials from .env file if exists
if [ -f ".env.deploy" ]; then
    echo "📋 Loading credentials from .env.deploy..."
    source .env.deploy
fi

# Ask for FTP credentials if not set
if [ -z "$FTP_HOST" ]; then
    echo -n "FTP Host (np. ftp.zenbox.pl): "
    read FTP_HOST
fi

if [ -z "$FTP_USER" ]; then
    echo -n "FTP User: "
    read FTP_USER
fi

if [ -z "$FTP_PASS" ]; then
    echo -n "FTP Password: "
    read -s FTP_PASS
    echo ""
fi

if [ -z "$FTP_PATH" ]; then
    echo -n "FTP Path (np. /public_html lub /domains/masterzone.edu.pl/public_html): "
    read FTP_PATH
fi

# Ask if user wants to save credentials
if [ ! -f ".env.deploy" ]; then
    echo ""
    echo -n "💾 Zapisać dane FTP do .env.deploy? (y/n): "
    read SAVE_CREDS
    if [ "$SAVE_CREDS" = "y" ]; then
        cat > .env.deploy << EOF
FTP_HOST="$FTP_HOST"
FTP_USER="$FTP_USER"
FTP_PASS="$FTP_PASS"
FTP_PATH="$FTP_PATH"
EOF
        echo "✅ Zapisano dane w .env.deploy (plik jest w .gitignore)"
    fi
fi

echo ""
echo "📤 Uploading files to $FTP_HOST..."
echo ""

# Check if lftp is available
if command -v lftp &> /dev/null; then
    echo "Using lftp..."
    lftp -u "$FTP_USER","$FTP_PASS" "$FTP_HOST" << EOF
set ssl:verify-certificate no
cd $FTP_PATH
put index.html
put stats.json
put favicon.ico
put favicon-16x16.png
put favicon-32x32.png
put apple-touch-icon.png
bye
EOF
else
    # Fallback to curl
    echo "Using curl (lftp not found)..."

    for file in index.html stats.json favicon.ico favicon-16x16.png favicon-32x32.png apple-touch-icon.png; do
        if [ -f "$file" ]; then
            echo "Uploading $file..."
            curl -T "$file" "ftp://$FTP_HOST$FTP_PATH/" --user "$FTP_USER:$FTP_PASS" --ssl -k
        fi
    done
fi

echo ""
echo "✅ Deployment completed!"
echo ""
echo "🌐 Check: https://masterzone.edu.pl"
echo ""
