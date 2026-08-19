#!/usr/bin/env bash
# Grimshield — zypper backend (openSUSE)

pkg_install() {
    local pkg="$1"
    sudo zypper --non-interactive install "$pkg" >/dev/null 2>&1
}

pkg_is_installed() {
    rpm -q "$1" >/dev/null 2>&1
}

pkg_update_index() {
    sudo zypper --non-interactive refresh >/dev/null 2>&1
}

pkg_enable_auto_updates() {
    pkg_install yast2-online-update-configuration
    sudo systemctl enable --now yast2-online-update-configuration >/dev/null 2>&1
}
