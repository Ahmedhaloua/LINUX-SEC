#!/usr/bin/env bash
# Grimshield module: firewall

run_firewall_module() {
    echo -e "\n\033[1m[2] Firewall\033[0m"

    local fw_tool=""
    if [ "$PKG_MANAGER" = "apt" ]; then
        fw_tool="ufw"
    else
        fw_tool="firewalld"
    fi

    if ask_yes_no "Install and enable ${fw_tool} with a default-deny inbound policy?" \
        "Blocks all inbound traffic except SSH and any ports you explicitly allow."; then

        pkg_install "$fw_tool"

        if [ "$fw_tool" = "ufw" ]; then
            sudo ufw default deny incoming >/dev/null 2>&1
            sudo ufw default allow outgoing >/dev/null 2>&1
            sudo ufw allow OpenSSH >/dev/null 2>&1
            sudo ufw --force enable >/dev/null 2>&1
        else
            sudo systemctl enable --now firewalld >/dev/null 2>&1
            sudo firewall-cmd --permanent --add-service=ssh >/dev/null 2>&1
            sudo firewall-cmd --reload >/dev/null 2>&1
        fi

        ok "${fw_tool} enabled, default-deny inbound, SSH allowed"
        log_report "Firewall" "Enable ${fw_tool}, default-deny inbound" "applied" "SSH access preserved"
    else
        skip "Firewall setup"
        log_report "Firewall" "Enable ${fw_tool}, default-deny inbound" "skipped" "User declined"
    fi
}
