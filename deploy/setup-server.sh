#!/usr/bin/env bash
# GenexaTech - one-time setup on the existing Firqui EC2 server.
# Creates the website folder and installs the Nginx site for the given host names.
#
# Usage:  sudo bash deploy/setup-server.sh <host names...>
#   e.g.  sudo bash deploy/setup-server.sh genexatech.13-233-12-191.sslip.io
#   later sudo bash deploy/setup-server.sh genexatech.com www.genexatech.com
#
# Safe to run again: it rewrites only the GenexaTech Nginx site and leaves the
# Firqui site, its files and its settings alone.

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

echo "==> Installing Nginx site for: $*"
sed "s/__SERVER_NAMES__/$*/" "$DEPLOY_DIR/nginx.conf" > "$NGINX_SITE"
ln -sf "$NGINX_SITE" /etc/nginx/sites-enabled/genexatech
nginx -t
systemctl reload nginx

echo
echo "Setup finished. Next: bash deploy/release.sh ubuntu@<server> [ssh-key-file]"
echo "HTTPS once the names resolve to this server:"
echo "  sudo certbot --nginx $(printf -- '-d %s ' "$@")--redirect"
