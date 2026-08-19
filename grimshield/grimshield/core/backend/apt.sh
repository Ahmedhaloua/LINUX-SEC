#!/usr/bin/env bash
# Grimshield — apt backend (Debian, Ubuntu, Kali)

pkg_install() {
    local pkg="$1"
    sudo apt-get install -y "$pkg" >/dev/null 2>&1
}

pkg_is_installed() {
    dpkg -s "$1" >/dev/null 2>&1
}

pkg_update_index() {
    sudo apt-get update -y >/dev/null 2>&1
}

pkg_enable_auto_updates() {
    pkg_install unattended-upgrades
    sudo dpkg-reconfigure -f noninteractive unattended-upgrades >/dev/null 2>&1
}
