#!/usr/bin/env bash
# Grimshield module: fail2ban

run_fail2ban_module() {
    echo -e "\n\033[1m[4] Brute-Force Protection (fail2ban)\033[0m"

    if ask_yes_no "Install and enable fail2ban for SSH?" \
        "Automatically bans IPs after repeated failed SSH login attempts."; then
        pkg_install fail2ban
        sudo systemctl enable --now fail2ban >/dev/null 2>&1
        ok "fail2ban installed and enabled for SSH"
        log_report "Fail2ban" "Install and enable for SSH" "applied" ""
    else
        skip "fail2ban"
        log_report "Fail2ban" "Install and enable for SSH" "skipped" "User declined"
    fi
}
