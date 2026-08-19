#!/usr/bin/env bash
# Grimshield module: Mandatory Access Control (AppArmor / SELinux)

run_mac_module() {
    echo -e "\n\033[1m[10] Mandatory Access Control\033[0m"

    if command -v apparmor_status >/dev/null 2>&1; then
        info "AppArmor detected"
        if sudo apparmor_status --enabled >/dev/null 2>&1; then
            info "AppArmor is already enabled"
            log_report "MAC" "AppArmor status" "applied" "Already enabled"
        else
            if ask_yes_no "AppArmor is installed but not enabled. Enable it now?" \
                "Restricts what each program can do, limiting damage even if it's compromised."; then
                sudo systemctl enable --now apparmor >/dev/null 2>&1
                ok "AppArmor enabled"
                log_report "MAC" "Enable AppArmor" "applied" ""
            else
                skip "Enabling AppArmor"
                log_report "MAC" "Enable AppArmor" "skipped" "User declined"
            fi
        fi
    elif command -v getenforce >/dev/null 2>&1; then
        info "SELinux detected"
        local mode
        mode=$(getenforce 2>/dev/null)
        if [ "$mode" = "Enforcing" ]; then
            info "SELinux is already Enforcing"
            log_report "MAC" "SELinux status" "applied" "Already Enforcing"
        else
            info "SELinux is currently: ${mode}"
            if ask_yes_no "Set SELinux to Enforcing mode?" \
                "Enforcing mode actually blocks disallowed actions instead of just logging them."; then
                sudo setenforce 1 >/dev/null 2>&1
                sudo sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config 2>/dev/null
                ok "SELinux set to Enforcing"
                log_report "MAC" "Set SELinux Enforcing" "applied" ""
            else
                skip "Setting SELinux to Enforcing"
                log_report "MAC" "Set SELinux Enforcing" "skipped" "User declined"
            fi
        fi
    else
        info "No AppArmor or SELinux found on this system"
        log_report "MAC" "AppArmor/SELinux check" "skipped" "Neither present on this system"
    fi
}
