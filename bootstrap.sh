#!/bin/bash

set -euo pipefail

#---helpers-------
log() { printf "\033[1;32m[+]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[!]\033[0m %s\n" "$*"; }
err() { printf "\033[1;31m[x]\033[0m %s\n" "$*" >&2; }

OS="$(uname -s)"
DISTRO="MacOS"

if [[ "$OS" == "Linux" ]]; then 
    if [[ -r /etc/os-release ]]; then
        . /etc/os-release
        DISTRO="${ID:-linux}"
    else
        warn "/etc/os-release not found; set DISTRO=linux"
        DISTRO="linux"
    fi
fi

# dependencies
if ! command -v git > /dev/null 2>&1; then
    if [[ "$OS" == "Darwin" ]]; then
        warn "git not found; installing Command Line Tools..."
        xcode-select --install || true
    else 
        err "git is required. Install git first."; exit 1
    fi
fi

log "Bootstrapping on ${OS}, ${DISTRO}"

# install oh-my-zsh
ZSH_DIR="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$ZSH_DIR/custom}"

if [[ ! -d "$ZSH_DIR" ]]; then
    log "Installing oh-my-zsh (non-interactive)..."
    export RUNZSH=no CHSH=no KEEP_ZSHRC=no
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    log "oh-my-zsh already installed at: $ZSH_DIR"
fi

if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
    log "Backing up existing ~/.zshrc -> ~/.zshrc.bak"
    mv -f "$HOME/.zshrc" "$HOME/.zshrc.bak"
fi

# install spaceship-prompt.sh
if [[ ! -d "$ZSH_CUSTOM_DIR/themes/spaceship-prompt" ]]; then
    log "Cloning spaceship-prompt..."
    git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM_DIR/themes/spaceship-prompt" --depth=1
    ln -s "$ZSH_CUSTOM_DIR/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM_DIR/themes/spaceship.zsh-theme"
else 
    log "spaceship-prompt already present"
fi

# install zsh-syntax-highlighting plugin
if [[ ! -d "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting" ]]; then
    log "Cloning zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting
else 
    log "zsh-syntax-highlighting already present"
fi

# install zsh-autocomplete
if [[ ! -d "$ZSH_CUSTOM_DIR/plugins/zsh-autocomplete" ]]; then
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM_DIR/plugins/zsh-autocomplete
else
    log "zsh-autocomplete already present"
fi

# install zoxide
if ! command -v zoxide >/dev/null 2>&1; then
    if [[ "$OS" == "Darwin" ]]; then
        if ! command -v brew >/dev/null 2>&1; then
            warn "Homebrew not found; installing.."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || true
            eval "$(/usr/local/bin/brew shellenv)" 2>/dev/null || true
        fi
        log "Installing zoxide via Homebrew..."
        brew install zoxide
    elif [[ "$OS" == "Linux" ]]; then
        case "$DISTRO" in
            arch|archlinux)
                log "Installing zoxide via pacman..."
                pacman -S zoxide
                ;;
            ubuntu|debian)
                log "Installing zoxide via apt..."
                curl -fsSL https://apt.cli.rs/pubkey.asc | sudo tee -a /usr/share/keyrings/rust-tools.asc
                curl -fsSL https://apt.cli.rs/rust-tools.list | sudo tee /etc/apt/sources.list.d/rust-tools.list
                sudo apt update
                apt show ripgrep
                apt install -y zoxide
                ;;
            fedora)
                log "Installing zoxide via dnf..."
                dnf install -y zoxide
                ;;
            *)
                warn "No known package manager for '$DISTRO'. Skipping zoxide."
                ;;
        esac
    fi
else 
    log "zoxide already installed."
fi

# install lsd
if ! command -v lsd > /dev/null 2>&1; then
    if [[ "$OS" == "Darwin" ]]; then
        brew instal lsd
    elif [[ "$OS" == Linux ]]; then
        case "$DISTRO" in
            arch|archlinux)
                log "Installing lsd via pacman..."
                pacman -S lsd
                ;;
            ubuntu|debian)
                log "Installing lsd via apt..."
                apt install -y lsd
                ;;
            fedora)
                log "Installing zoxide via dnf..."
                dnf install -y lsd
                ;;
            *)
                warn "No known package manager for '$DISTRO'. Skipping zoxide."
                ;;
        esac
    fi
else
    log "lsd already installed"
fi

log "Bootstrap finished. Link your dotfiles next."
