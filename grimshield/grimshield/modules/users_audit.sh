#!/usr/bin/env bash
# Grimshield module: user & permission audit (read-only findings, then optional fixes)

run_users_audit_module() {
    echo -e "\n\033[1m[5] User & Permission Audit\033[0m"

    info "Scanning for accounts with UID 0 (root-equivalent)..."
    local uid0_users
    uid0_users=$(awk -F: '($3 == 0) {print $1}' /etc/passwd | grep -v '^root$')

    if [ -n "$uid0_users" ]; then
        echo "  Found non-root accounts with UID 0:"
        echo "$uid0_users" | sed 's/^/    - /'
        log_report "Users" "UID 0 account scan" "applied" "Found: $(echo "$uid0_users" | tr '\n' ' ')"
    else
        info "No unexpected UID 0 accounts found"
        log_report "Users" "UID 0 account scan" "applied" "None found"
    fi

    info "Scanning for accounts with empty passwords..."
    local empty_pass_users
    empty_pass_users=$(sudo awk -F: '($2 == "") {print $1}' /etc/shadow 2>/dev/null)

    if [ -n "$empty_pass_users" ]; then
        echo "  Found accounts with empty passwords:"
        echo "$empty_pass_users" | sed 's/^/    - /'
        if ask_yes_no "Lock these accounts to prevent passwordless login?" \
            "Empty passwords let anyone log in as these users without credentials."; then
            for u in $empty_pass_users; do
                sudo passwd -l "$u" >/dev/null 2>&1
            done
            ok "Locked accounts with empty passwords"
            log_report "Users" "Lock empty-password accounts" "applied" "$(echo "$empty_pass_users" | tr '\n' ' ')"
        else
            skip "Locking empty-password accounts"
            log_report "Users" "Lock empty-password accounts" "skipped" "User declined"
        fi
    else
        info "No empty-password accounts found"
        log_report "Users" "Empty password scan" "applied" "None found"
    fi

    info "Scanning for world-writable files in /etc..."
    local ww_files
    ww_files=$(find /etc -xdev -type f -perm -0002 2>/dev/null)
    if [ -n "$ww_files" ]; then
        echo "  Found world-writable files in /etc (review manually):"
        echo "$ww_files" | sed 's/^/    - /'
        log_report "Users" "World-writable /etc scan" "applied" "$(echo "$ww_files" | wc -l) file(s) found, see terminal output"
    else
        info "No world-writable files found in /etc"
        log_report "Users" "World-writable /etc scan" "applied" "None found"
    fi
}
