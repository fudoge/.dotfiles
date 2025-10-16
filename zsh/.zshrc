export NODE_OPTIONS="--openssl-legacy-provider"

# PATH
PATH_DIR="$HOME/.dotfiles/zsh/path.zsh"
source "$PATH_DIR"

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# zsh plugins
plugins=(git zsh-autocomplete zsh-syntax-highlighting zoxide)

source $ZSH/oh-my-zsh.sh

# zoxide
eval "$(zoxide init zsh)"

# History settings
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history hist_expire_dups_first hist_ignore_dups hist_verify

# Key bindings
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# Aliases
ALIAS_PATH="$HOME/.dotfiles/zsh/alias.zsh"
source "$ALIAS_PATH"

# Etc config
CONFIG_PATH="$HOME/.dotfiles/zsh/config.zsh"

# starship
eval "$(starship init zsh)"
