#!/usr/bin/env bash
# Start FTPS only (FTP over TLS; no HTTP listener).
# Usage:
#   COPYPARTY_TLS_CERT=/path/to/fullchain.pem \
#   COPYPARTY_TLS_KEY=/path/to/private-key.pem ./startFtps.sh
# This script intentionally requires an explicit certificate and key instead
# of allowing copyparty's insecure fallback certificate. It also checks that
# PyOpenSSL is installed. Until both prerequisites are met, the service exits.
# Default bind is 127.0.0.1:2121 with TCP passive ports 12000-12099.
# For LAN access, change ftp-i in ftps-only.conf and open the control/passive
# TCP ports in the firewall. Protect the private key from other local users.
# Runs in the foreground; press Ctrl-C to stop it.

set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

: "${COPYPARTY_TLS_CERT:?Set COPYPARTY_TLS_CERT to the trusted certificate chain file}"
: "${COPYPARTY_TLS_KEY:?Set COPYPARTY_TLS_KEY to the matching private key file}"

if ! python3 -c 'import OpenSSL' >/dev/null 2>&1; then
  printf '%s\n' 'FTPS requires PyOpenSSL in the Python environment used by python3.' >&2
  exit 1
fi

if [[ ! -r "${COPYPARTY_TLS_CERT}" || ! -r "${COPYPARTY_TLS_KEY}" ]]; then
  printf '%s\n' 'The configured FTPS certificate or private key is not readable.' >&2
  exit 1
fi

exec python3 "${SCRIPT_DIR}/copyparty-sfx.py" \
  -c "${SCRIPT_DIR}/accounts.conf" \
  -c "${SCRIPT_DIR}/ftps-only.conf" \
  --cert "${COPYPARTY_TLS_CERT}" \
  --certkey "${COPYPARTY_TLS_KEY}"
