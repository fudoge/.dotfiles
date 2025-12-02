#!/bin/bash

set -euo pipefail

#---helpers-------
log() { printf "\033[1;32m[+]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[!]\033[0m %s\n" "$*"; }
err() { printf "\033[1;31m[x]\033[0m %s\n" "$*" >&2; }

OS="$(uname -s)"
DISTRO="MacOS"

# vivaldi
log "Installing vivaldi.."
pacman -S vivaldi
