#!/usr/bin/env bash
# GenexaTech - ship the website to the server.
# Used by the GitHub Actions workflow on every push to main, and by hand:
#
#   bash deploy/release.sh ubuntu@13.233.12.191 ~/.ssh/firqui_admin
#
# Sends exactly what is committed (uncommitted edits are left out) and replaces
# the contents of /var/www/genexatech with it.

set -euo pipefail

TARGET="${1:?Usage: bash deploy/release.sh <user@host> [ssh-key-file]}"
KEY="${2:-}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SSH=(ssh -o BatchMode=yes -o ConnectTimeout=20)
[ -n "$KEY" ] && SSH+=(-i "$KEY")

SITE_FILES=(index.html style.css script.js assets)

echo "==> Releasing commit $(git -C "$ROOT" rev-parse --short HEAD) to $TARGET"
if [ -n "$(git -C "$ROOT" status --porcelain -- "${SITE_FILES[@]}")" ]; then
    echo "    (uncommitted changes in this checkout are NOT included)"
fi

git -C "$ROOT" archive --format=tar HEAD "${SITE_FILES[@]}" \
  | "${SSH[@]}" "$TARGET" '
        set -e
        rm -rf ~/genexatech_release && mkdir -p ~/genexatech_release
        tar xf - -C ~/genexatech_release
        rsync -a --delete ~/genexatech_release/ /var/www/genexatech/
        rm -rf ~/genexatech_release
    '
echo "==> Release finished"
