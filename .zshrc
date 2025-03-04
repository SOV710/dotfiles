# ==============================================================================
# Powerlevel10k Instant Prompt Configuration
# ==============================================================================

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==============================================================================
# Zsh Options
# ==============================================================================

# History options
setopt HIST_IGNORE_ALL_DUPS
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# ==============================================================================
# Environment Variables
# ==============================================================================

# Color setting for themes
export TERM="xterm-256color"

# Remove duplicate entries from PATH
export PATH=$(echo $PATH | tr ':' '\n' | sort -u | tr '\n' ':')

# ==============================================================================
# Custom Configurations and Sources
# ==============================================================================

# Source environment variable
source ~/.zshenv

# Custom zsh configurations
[ -f "$HOME/.config/zsh/custom.zsh" ] && source "$HOME/.config/zsh/custom.zsh"

# Aliases
[ -f "$HOME/.config/zsh/aliases.zsh" ] && source "$HOME/.config/zsh/aliases.zsh"

# Work scripts
[ -f "$HOME/.config/zsh/work.zsh" ] && source "$HOME/.config/zsh/work.zsh"

# Prompt customization
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ==============================================================================
# Key Bindings
# ==============================================================================

# Auto-suggestions accept
bindkey '^ ' autosuggest-accept

# ==============================================================================
# NVM Configuration
# ==============================================================================

# Node Version Manager
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
