#!/usr/bin/env bash
# GenexaTech - one-time setup on the existing Firqui EC2 server.
# Creates the website folder and installs the Nginx site for the given host names.
#
# Usage:  sudo bash deploy/setup-server.sh <host names...>
#   e.g.  sudo bash deploy/setup-server.sh genexatech.13-233-12-191.sslip.io
#   later sudo bash deploy/setup-server.sh genexatech.com www.genexatech.com
#
# Safe to run again: an existing GenexaTech Nginx site is kept, and the Firqui
# site, its files and its settings are never touched.

set -euo pipefail

[ "$#" -ge 1 ] || { echo "Usage: sudo bash deploy/setup-server.sh <host names...>"; exit 1; }
[ "$(id -u)" -eq 0 ] || { echo "Run with sudo."; exit 1; }

DEPLOY_DIR="$(cd "$(dirname "$0")" && pwd)"
SITE_DIR=/var/www/genexatech
NGINX_SITE=/etc/nginx/sites-available/genexatech
OWNER="${SUDO_USER:-ubuntu}"

echo "==> Creating $SITE_DIR (owned by $OWNER, so releases need no sudo)"
mkdir -p "$SITE_DIR"
chown "$OWNER:$OWNER" "$SITE_DIR"

# Certbot adds the HTTPS settings to the installed file, so an existing site is
# kept unless REPLACE=1 (then run Certbot again afterwards)
if [ ! -f "$NGINX_SITE" ] || [ "${REPLACE:-0}" = "1" ]; then
    echo "==> Installing Nginx site for: $*"
    sed "s/__SERVER_NAMES__/$*/" "$DEPLOY_DIR/nginx.conf" > "$NGINX_SITE"
else
    echo "==> Nginx site already exists, keeping it (REPLACE=1 to rewrite it)"
fi
ln -sf "$NGINX_SITE" /etc/nginx/sites-enabled/genexatech
nginx -t
systemctl reload nginx

echo
echo "Setup finished. Next: bash deploy/release.sh ubuntu@<server> [ssh-key-file]"
echo "HTTPS once the names resolve to this server:"
echo "  sudo certbot --nginx $(printf -- '-d %s ' "$@")--redirect"
