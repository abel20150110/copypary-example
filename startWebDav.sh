#!/usr/bin/env bash
# Start the HTTP + WebDAV service only.
# Usage: ./startWebDav.sh
# Default endpoint: http://<server-address>:3923/
# The service shares the /home/ftpuser directory. Its permissions are in
# webdav.conf; rw allows list/download/upload but not move or delete.
# To allow rename/move or delete, add m or d to that volume's permission,
# for example rwmd: zml. Grant only the permissions users actually need.
# HTTP is plaintext: use only on a trusted network or put it behind HTTPS.
# This script runs in the foreground; press Ctrl-C to stop it.

set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

exec python3 "${SCRIPT_DIR}/copyparty-sfx.py" \
  -c "${SCRIPT_DIR}/accounts.conf" \
  -c "${SCRIPT_DIR}/webdav.conf"
