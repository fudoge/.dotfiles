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

# install fast-syntax-highlighting plugin
FZH_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting"
if [[ ! -d "$FZH_DIR" ]]; then
    log "Cloning fast-syntax-highlighting..."
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
else 
    log "zsh-syntax-highlighting already present"
fi

# install zsh-autosuggestions
ZAS_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
if [[ ! -d "$ZAS_DIR" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
    log "zsh-autosuggestions already present"
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

# install eza
if ! command -v eza > /dev/null 2>&1; then
    if [[ "$OS" == "Darwin" ]]; then
        brew install eza
    elif [[ "$OS" == "Linux" ]]; then
        case "$DISTRO" in
            arch|archlinux)
                log "Installing eza via pacman..."
                pacman -S eza
                ;;
            ubuntu|debian)
                log "Installing eza via apt..."
                sudo apt update
                sudo apt install -y gpg
                sudo mkdir -p /etc/apt/keyrings
                wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
                echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
                sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
                sudo apt update
                sudo apt install -y eza
                ;;
            fedora)
                log "Installing eza via dnf..."
                sudo dnf install -y eza
                ;;
            *)
                warn "No known package manager for '$DISTRO'. Skipping eza."
                ;;
        esac
    fi
else
    log "eza already installed"
fi

# install starship
if ! command -v starship > /dev/null 2>&1; then
    if [[ "$OS" == "Darwin" ]]; then
        brew install starship
    elif [[ "$OS" == "Linux" ]]; then
        case "$DISTRO" in
            arch|archlinux)
                log "Installing starship via pacman..."
                pacman -S starship
                ;;
            ubuntu|debian)
                log "Installing starship via apt..."
                apt install -y starship
                ;;
            fedora)
                log "Installing starship via dnf..."
                dnf install -y starship
                ;;
            *)
                warn "No known package manager for '$DISTRO'. Skipping starship."
                ;;
        esac
    fi
else
    log "starship prompt already installed"
fi

# insatll tree-sitter-cli
if ! command -v tree-sitter > /dev/null 2>&1; then
    log "Installing tree-sitter-cli via cargo..."
    cargo install tree-sitter-cli
else
    log "tree-sitter-cli already installed"
fi

# install gh-cli
if ! command -v gh > /dev/null 2>&1; then
    if [[ "$OS" == Darwin ]]; then
        log "Installing github-cli via homebrew"
        brew install gh
    elif [[ "$OS" == "Linux" ]]; then
        case "$DISTRO" in
            arch|archlinux)
                log "Installing github-cli via pacman"
                pacman -S github-cli
        esac
    fi
else
    log "Github-cli already exists"
fi

# install fastfetch
if ! command -v fastfetch > /dev/null 2>&1; then
    if [[ "$OS" == Darwin ]]; then
        log "Installing fastfetch via homebrew"
        brew install fastfetch 
    elif [[ "$OS" == "Linux" ]]; then
        case "$DISTRO" in
            arch|archlinux)
                log "Installing fastfetch via pacman"
                pacman -S fastfetch
        esac
    fi
else
    log "Fastfetch already exists"
fi

# install nitch
if ! command -v nitch > /dev/null 2>&1; then
    if [[ "$OS" == Darwin ]]; then
        log "There's no nitch support for MacOS yet."
    elif [[ "$OS" == "Linux" ]]; then
        case "$DISTRO" in
            arch|archlinux)
                log "Installing nitch via paru"
                paru -S nitch
        esac
    fi
else
    log "Nitch already exists"
fi

log "Bootstrap finished. Link your dotfiles next."
