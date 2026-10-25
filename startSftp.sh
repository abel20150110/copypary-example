#!/usr/bin/env bash
# Start SFTP only (SSH File Transfer Protocol; not FTPS, and no HTTP listener).
# Usage: ./startSftp.sh
# Default endpoint: 127.0.0.1:2222. Password authentication is enabled for
# accounts.conf. For stronger protection, configure a user public key with
# sftp-key in sftp-only.conf and disable sftp-pw after confirming key login.
# For LAN use, change sftp-i from 127.0.0.1 to a trusted interface address and
# allow TCP 2222 in the firewall. Do not use the anonymous sftp option.
# Share permissions are in sftp-only.conf; rw permits list/download/upload,
# m permits move/rename, and d permits permanent deletion.
# Runs in the foreground; press Ctrl-C to stop it.

set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

exec python3 "${SCRIPT_DIR}/copyparty-sfx.py" \
  -c "${SCRIPT_DIR}/accounts.conf" \
  -c "${SCRIPT_DIR}/sftp-only.conf"
