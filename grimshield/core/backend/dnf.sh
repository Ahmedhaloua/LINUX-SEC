#!/usr/bin/env bash
# Grimshield — dnf backend (Fedora, RHEL, CentOS)

pkg_install() {
    local pkg="$1"
    sudo dnf install -y "$pkg" >/dev/null 2>&1
}

pkg_is_installed() {
    rpm -q "$1" >/dev/null 2>&1
}

pkg_update_index() {
    sudo dnf makecache >/dev/null 2>&1
}

pkg_enable_auto_updates() {
    pkg_install dnf-automatic
    sudo systemctl enable --now dnf-automatic.timer >/dev/null 2>&1
}
