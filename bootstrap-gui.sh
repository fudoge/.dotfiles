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
