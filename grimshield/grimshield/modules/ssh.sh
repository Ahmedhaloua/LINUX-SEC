#!/usr/bin/env bash
# Grimshield module: SSH hardening

run_ssh_module() {
    echo -e "\n\033[1m[3] SSH Hardening\033[0m"

    local sshd_config="/etc/ssh/sshd_config"
    if [ ! -f "$sshd_config" ]; then
        info "No sshd_config found, skipping SSH module"
        log_report "SSH" "SSH hardening" "skipped" "sshd not installed"
        return
    fi

    if ask_yes_no "Disable SSH root login?" \
        "Forces attackers to guess both a valid username AND a password/key, not just root's."; then
        sudo cp "$sshd_config" "${sshd_config}.grimshield.bak"
        sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' "$sshd_config"
        ok "Root login disabled"
        log_report "SSH" "Disable root login" "applied" "Backup saved as sshd_config.grimshield.bak"
    else
        skip "Disable root login"
        log_report "SSH" "Disable root login" "skipped" "User declined"
    fi

    if ask_yes_no "Disable SSH password authentication (key-only login)?" \
        "WARNING: make sure you already have a working SSH key set up, or you WILL be locked out."; then
        sudo cp "$sshd_config" "${sshd_config}.grimshield.bak2"
        sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' "$sshd_config"
        ok "Password authentication disabled (key-only)"
        log_report "SSH" "Disable password authentication" "applied" "Backup saved as sshd_config.grimshield.bak2"
    else
        skip "Disable password authentication"
        log_report "SSH" "Disable password authentication" "skipped" "User declined"
    fi

    if ask_yes_no "Restart SSH service to apply these changes now?" \
        "Required for changes to take effect. Keep this terminal open until you confirm a new session works."; then
        sudo systemctl restart sshd >/dev/null 2>&1 || sudo systemctl restart ssh >/dev/null 2>&1
        ok "SSH service restarted"
        log_report "SSH" "Restart SSH service" "applied" ""
    else
        skip "SSH service restart (changes saved but not yet active)"
        log_report "SSH" "Restart SSH service" "skipped" "User declined, changes not yet active"
    fi
}
