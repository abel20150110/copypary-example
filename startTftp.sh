#!/usr/bin/env bash
# Start read-only TFTP only (no HTTP listener).
# WARNING: TFTP has no user/password authentication. Every allowed client can
# read the volume; this config grants r: * and never grants anonymous writes.
# Default bind and source-IP restriction are loopback-only (127.0.0.1).
# For a trusted isolated LAN, edit tftp-i and tftp-ipa in tftp-only.conf to
# the intended interface/subnet, then allow UDP 6969 and UDP 12000-12099 in
# the firewall. Do not expose TFTP to the public internet.
# Runs in the foreground; press Ctrl-C to stop it.

set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

exec python3 "${SCRIPT_DIR}/copyparty-sfx.py" \
  -c "${SCRIPT_DIR}/accounts.conf" \
  -c "${SCRIPT_DIR}/tftp-only.conf"
