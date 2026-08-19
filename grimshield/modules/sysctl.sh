#!/usr/bin/env bash
# Grimshield module: kernel / sysctl hardening

run_sysctl_module() {
    echo -e "\n\033[1m[6] Kernel & Network Hardening\033[0m"

    local sysctl_file="/etc/sysctl.d/99-grimshield.conf"

    if ask_yes_no "Apply recommended sysctl network hardening?" \
        "Disables ICMP redirects, enables SYN cookies, disables IP source routing, etc."; then
        sudo tee "$sysctl_file" >/dev/null << 'EOF'
# Grimshield hardening
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.icmp_echo_ignore_broadcasts = 1
kernel.randomize_va_space = 2
EOF
        sudo sysctl --system >/dev/null 2>&1
        ok "sysctl hardening applied (${sysctl_file})"
        log_report "Sysctl" "Apply network/kernel hardening" "applied" "$sysctl_file"
    else
        skip "sysctl hardening"
        log_report "Sysctl" "Apply network/kernel hardening" "skipped" "User declined"
    fi
}
