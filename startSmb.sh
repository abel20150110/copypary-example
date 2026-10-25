#!/usr/bin/env bash
# Start SMB/CIFS only (read-only; no HTTP listener).
# DANGER: this copyparty version warns SMB is dangerous/buggy and must never
# be exposed to the internet. This script uses loopback only by default.
# SMB also requires the explicit --hack-me-bro risk-acceptance switch.
# Do not enable smbw in smb-only.conf. Default TCP port is 1445; SMB clients
# may expect 445, requiring separate firewall/NAT port mapping if needed.
# For LAN use, change smb-i only to a trusted interface address and firewall
# the service to that LAN. The shared ACL is read-only for zml.
# Runs in the foreground; press Ctrl-C to stop it.

set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ "${COPYPARTY_I_ACCEPT_SMB_RISK:-}" != "1" ]]; then
  printf '%s\\n' 'SMB is disabled by default. Review smb-only.conf and export COPYPARTY_I_ACCEPT_SMB_RISK=1 only on an isolated trusted LAN.' >&2
  exit 1
fi

exec python3 "${SCRIPT_DIR}/copyparty-sfx.py" \
  -c "${SCRIPT_DIR}/accounts.conf" \
  -c "${SCRIPT_DIR}/smb-only.conf" \
  --hack-me-bro
