#!/usr/bin/env bash
# Grimshield — pacman backend (Arch Linux)

pkg_install() {
    local pkg="$1"
    sudo pacman -S --noconfirm --needed "$pkg" >/dev/null 2>&1
}

pkg_is_installed() {
    pacman -Qi "$1" >/dev/null 2>&1
}

pkg_update_index() {
    sudo pacman -Sy --noconfirm >/dev/null 2>&1
}

pkg_enable_auto_updates() {
    info "Arch Linux has no official unattended-upgrade tool by default."
    info "Consider setting up 'pacman -Syu' via a cron job or timer if desired."
}
