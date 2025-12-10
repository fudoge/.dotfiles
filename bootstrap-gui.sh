#!/bin/bash

set -euo pipefail

#---helpers-------
log() { printf "\033[1;32m[+]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[!]\033[0m %s\n" "$*"; }
err() { printf "\033[1;31m[x]\033[0m %s\n" "$*" >&2; }

OS="$(uname -s)"
DISTRO="MacOS"

# vivaldi
if ! command -v vivaldi > /dev/null 2>&1; then
    log "Installing vivaldi.."
    pacman -S vivaldi
else
    log "Vivaldi already exists. skipping..."
fi

# Hyprland
if ! command -v hyprland > /dev/null 2>&1; then
    log "Installing hyprland.."
    pacman -S hyprland
else
    log "Hyprland already exists. skipping..."
fi

# Hyprpanel
if ! command -v hyprpanel > /dev/null 2>&1; then
    log "Installing Hyprpanel"...
    paru -S --needed aylurs-gtk-shell-git wireplumber libgtop bluez bluez-utils btop networkmanager dart-sass wl-clipboard brightnessctl swww python upower pacman-contrib power-profiles-daemon gvfs gtksourceview3 libsoup3 grimblast-git wf-recorder-git hyprpicker matugen-bin python-gpustat hyprsunset-git
    paru -S ags-hyprpanel-git
else
    log "Hyprpanel already exists. skipping..."
fi

# jetbrains-mono-nf
if fc-list | grep -qi "JetBrains"; then
    log "Jetbrains Mono NF already exists. skipping..."
else
    log "Installing Jetbrains Mono NF..."
    paru -S ttf-jetbrains-mono-nerd
fi

# MesloLSG NF
if fc-list | grep -qi "MesloLGS"; then
    log "MesloLGS NF already exists. skipping..."
else
    log "Installing MesloLGS NF..."
    paru -S ttf-meslo-nerd
fi
