#!/bin/bash

set -euo pipefail

# --- helpers -------
log() { printf "\033[1;32m[+]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[!]\033[0m %s\n" "$*"; }
err() { printf "\033[1;31m[x]\033[0m %s\n" "$*" >&2; }

DOTFILES_DIR="$(cd "$(dirname "{BASH_SOURCE[0]")" && pwd)"
OS="$(uname -s)"

# Ghostty config path
if [[ "$OS" == "Darwin" ]]; then
    GHOSTTY_SRC="$DOTFILES_DIR/ghostty/mac.config"
    GHOSTTY_DST="$HOME/Library/Application Support/com.mitchellh.ghostty/config"
else
    GHOSTTY_SRC="$DOTFILES_DIR/ghostty/linux.config"
    GHOSTTY_DST="$HOME/.config/ghostty/config"
fi

# Ghostty shaders path
GHOSTTY_SHADERS_SRC="$DOTFILES_DIR/ghostty/shaders"
GHOSTTY_SHADERS_DST="$(dirname "$GHOSTTY_DST")/shaders"

# --- links ----------
LINKS=(
    "$DOTFILES_DIR/zsh/.zshrc:$HOME/.zshrc"
    "$DOTFILES_DIR/tmux/.tmux.conf:$HOME/.tmux.conf"
    "$DOTFILES_DIR/nvim:$HOME/.config/nvim"
    "${GHOSTTY_SRC}:${GHOSTTY_DST}"
    "${GHOSTTY_SHADERS_SRC}:${GHOSTTY_SHADERS_DST}"
    "$DOTFILES_DIR/starship/starship.toml:$HOME/.config/starship.toml"
)

ensure_parent_dir() {
    local dst="$1"
    mkdir -p "$(dirname "$dst")"
}

link() {
    local src="$1" dst="$2"
    ensure_parent_dir "$dst"
    ln -sfn "$src" "$dst"
}

is_same_link() {
    local src="$1" dst="$2"
    [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]
}

action() {
    local src="$1" dst="$2"
    while true; do
        printf "\n%s\n" "Target exists: $dst"
        read -rp "[o]verwrite, [b]ackup, [s]kip, [d]iff ? (lowercase only)" ans
        case "$ans" in
            o|overwrite)
                rm -rf -- "$dst"
                link "$src" "$dst"
                log "Overwrote -> $dst"
                break
                ;;
            b|backup)
                local ts; ts="$(date +%Y%m%d_%H%M%S)"
                mv -- "$dst" "${dst}.backup_${ts}"
                link "$src" "$dst"
                log "Backed up to ${dst}.backup_${ts} and linked"
                break
                ;;
            s|skip)
                warn "Skipped $dst"
                break
                ;;
            d|diff)
                if command -v diff >/dev/null 2>&1; then
                    diff -ru -- "$dst" "$src" | ${PAGER:-less}
                else
                    warn "diff command not found."
                fi
                ;;
            *)
                warn "Select option: [o]verwrite / [b]ackup / [s]kip / [d]iff."
                ;;
        esac
    done
}


# --- main ------------
log "Start linking..."
log "Your OS: ${OS}"

for pair in "${LINKS[@]}"; do
    IFS=':' read -r src dst <<<"$pair"
    [[ -e "$src" || -L "$src" ]] || { warn "Not found: $src"; continue; } 

    if is_same_link "$src" "$dst"; then
        log "Already linked: $dst"
        continue
    fi

    if [[ -e "$dst" || -L "$dst" ]]; then
        action "$src" "$dst"
    else 
        link "$src" "$dst"
        log "Linked -> $dst"
    fi
done


log "✅ Linking complete! Happy Coding! 😊"
log "Reload .zshrc: source ~/.zshrc"
