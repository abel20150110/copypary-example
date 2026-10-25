#!/usr/bin/env bash
# Compatibility entry point; starts the isolated FTP service.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
exec "${SCRIPT_DIR}/startFtpOnly.sh" "$@"
