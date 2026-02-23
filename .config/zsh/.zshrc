# -----------------------------------
# Environment
# -----------------------------------
# zmodload zsh/zprof
export EDITOR=nvim
export PATH="$HOME/.cargo/bin:$PATH"

setopt AUTO_CD
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# -----------------------------------
# History
# -----------------------------------
HISTFILE=$HOME/.config/zsh/.zsh_history
HISTSIZE=20000
SAVEHIST=20000

bindkey "^[[A" up-line-or-history
bindkey "^[[B" down-line-or-history

# ------------------------------------------------------------------------------
# ⚡ Ultra-Optimized Completion System
# ------------------------------------------------------------------------------

# Cache location (XDG compliant)
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
ZSH_COMPDUMP="$ZSH_CACHE_DIR/zcompdump"

mkdir -p "$ZSH_CACHE_DIR"

# Load completion system
autoload -Uz compinit

# If dump file doesn't exist, build it once
if [[ ! -f "$ZSH_COMPDUMP" ]]; then
  compinit -d "$ZSH_COMPDUMP"
else
  # Fast path: skip security checks
  compinit -C -d "$ZSH_COMPDUMP"
fi

# Precompile dump file for faster loading
if [[ -f "$ZSH_COMPDUMP" && ! -f "$ZSH_COMPDUMP.zwc" ]]; then
  zcompile "$ZSH_COMPDUMP"
fi

# ------------------------------------------------------------------------------
# Smart Completion Settings (Performance-Focused)
# ------------------------------------------------------------------------------

# Allow dotfile matching
_comp_options+=(globdots)

# Faster matching strategy
zstyle ':completion:*' matcher-list \
  'm:{a-z}={A-Za-z}' \
  'r:|[._-]=* r:|=*'

# Use caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR"

# Keep UI minimal but usable
zstyle ':completion:*' menu select
zstyle ':completion:*' list-dirs-first true

# Avoid heavy verbose formatting
zstyle ':completion:*' verbose no

# ------------------------------------------------------------------------------
# Performance Tweaks
# ------------------------------------------------------------------------------

unsetopt HASH_LIST_ALL   # Prevent full PATH hashing on startup
unsetopt AUTO_LIST       # Avoid automatic list rendering

# -----------------------------------
# Rust Tools
# -----------------------------------

# Starship (fast Rust prompt)
eval "$(starship init zsh)"

# Zoxide (smart cd)
eval "$(zoxide init zsh)"
source /usr/share/fzf/key-bindings.zsh

# fastfetch

# -----------------------------------
# Aliases (Rust replacements)
# -----------------------------------
alias ls="eza --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first"
alias cat="bat"
alias grep="rg"
alias find="fd"
alias cd="z"
alias ztime="time zsh -i -c exit"
alias topdf="libreoffice --headless --convert-to pdf"

# -----------------------------------
# Plugins Loading
# -----------------------------------
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zprof

# -----------------------------------
# Disable all zsh beeps
# -----------------------------------

unsetopt BEEP
setopt NO_BEEP

# Disable completion error beep
zstyle ':completion:*' beep false

# Override bell widget
zle -N beep
beep() { :; }
