#!/usr/bin/env bash
# Grimshield installer
# Usage: git clone <repo> && cd grimshield && ./install.sh

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

chmod +x "$SCRIPT_DIR/grimshield.sh"
chmod +x "$SCRIPT_DIR"/modules/*.sh
chmod +x "$SCRIPT_DIR"/core/*.sh
chmod +x "$SCRIPT_DIR"/core/backend/*.sh
chmod +x "$SCRIPT_DIR"/assets/*.sh

echo "Grimshield installed."
echo "Run it with:"
echo "  ${SCRIPT_DIR}/grimshield.sh"
echo
echo "Optionally, add it to your PATH:"
echo "  sudo ln -s ${SCRIPT_DIR}/grimshield.sh /usr/local/bin/grimshield"
