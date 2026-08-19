#!/usr/bin/env bash
# Grimshield — startup banner
# Shown every time the tool is run.
# Original ASCII wordmark; no copyrighted characters or artwork used.

RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

print_banner() {
cat << "EOF"

██████╗ ██████╗ ██╗███╗   ███╗███████╗██╗  ██╗██╗███████╗██╗     ██████╗
██╔════╝ ██╔══██╗██║████╗ ████║██╔════╝██║  ██║██║██╔════╝██║     ██╔══██╗
██║  ███╗██████╔╝██║██╔████╔██║███████╗███████║██║█████╗  ██║     ██║  ██║
██║   ██║██╔══██╗██║██║╚██╔╝██║╚════██║██╔══██║██║██╔══╝  ██║     ██║  ██║
╚██████╔╝██║  ██║██║██║ ╚═╝ ██║███████║██║  ██║██║███████╗███████╗██████╔╝
 ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝╚═╝╚══════╝╚══════╝╚═════╝

     it already knows every unpatched port.
        it already knows every weak config.
      it will ask before it touches anything —
           but it will not let them slide.

EOF
}

show_banner() {
    echo -e "${RED}"
    print_banner
    echo -e "${NC}${BOLD}Something is watching this machine now.${NC}"
    echo -e "It has already mapped every crack you left open."
    echo -e "It will walk you through every fix, step by step, and ask before it changes anything."
    echo
}
