DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"

export NODE_OPTIONS="--openssl-legacy-provider"

# PATH
PATH_DIR="$HOME/.dotfiles/zsh/path.zsh"
[ -f "$PATH_DIR" ] && source "$PATH_DIR"

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# zsh plugins
plugins=(git zsh-autosuggestions fast-syntax-highlighting zoxide)

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# zoxide
eval "$(zoxide init zsh)"

# History settings
HISTFILE=$HOME/.zhistory
SAVEHIST=2000
HISTSIZE=2000
setopt share_history hist_expire_dups_first hist_ignore_dups hist_verify

# Key bindings
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# Aliases
ALIAS_PATH="$HOME/.dotfiles/zsh/alias.zsh"
[ -f "$ALIAS_PATH" ] && source "$ALIAS_PATH"

# Etc config
CONFIG_PATH="$HOME/.dotfiles/zsh/config.zsh"
[ -f "$CONFIG_PATH" ] && source "$CONFIG_PATH"

# starship
eval "$(starship init zsh)"

# Smarter completion initialization
autoload -Uz compinit
if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
    compinit
else
    compinit -C
fi

