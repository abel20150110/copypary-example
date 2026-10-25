#!/usr/bin/env bash
# Start FTP only (no HTTP/WebDAV listener).
# Usage: ./startFtpOnly.sh
# Default: 127.0.0.1:2121 plus TCP passive ports 12000-12099.
# FTP credentials and share ACL are in accounts.conf and ftp-only.conf.
# FTP sends credentials and file data without encryption. Keep the loopback
# bind unless you have a trusted LAN; for LAN access, change ftp-i in
# ftp-only.conf to the server's LAN address, then allow TCP 2121 and 12000-12099
# in the firewall. Behind NAT, also configure ftp-nat with the public address.
# rw permits read/list and upload; m and d separately grant rename/move and
# permanent deletion. Do not expose plaintext FTP to an untrusted network.
# Runs in the foreground; press Ctrl-C to stop it.

set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

exec python3 "${SCRIPT_DIR}/copyparty-sfx.py" \
  -c "${SCRIPT_DIR}/accounts.conf" \
  -c "${SCRIPT_DIR}/ftp-only.conf"
