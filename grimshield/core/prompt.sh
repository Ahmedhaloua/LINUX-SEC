#!/usr/bin/env bash
# Grimshield — shared prompt helper
# Every module must use ask_yes_no before making ANY system change.

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
GRAY='\033[0;90m'
NC_P='\033[0m'

# ask_yes_no "Question text" "Why this matters (1-2 lines)"
# Returns 0 (true) if user said yes, 1 (false) if no.
ask_yes_no() {
    local question="$1"
    local reason="$2"
    local answer

    echo -e "${YELLOW}?${NC_P} ${question}"
    if [ -n "$reason" ]; then
        echo -e "  ${GRAY}${reason}${NC_P}"
    fi

    while true; do
        read -r -p "  Apply this? [y/N]: " answer
        case "$answer" in
            [Yy]|[Yy][Ee][Ss]) return 0 ;;
            [Nn]|[Nn][Oo]|"")  return 1 ;;
            *) echo "  Please answer y or n." ;;
        esac
    done
}

info()  { echo -e "${GRAY}  -> $1${NC_P}"; }
ok()    { echo -e "${GREEN}  [applied] $1${NC_P}"; }
skip()  { echo -e "${GRAY}  [skipped] $1${NC_P}"; }
