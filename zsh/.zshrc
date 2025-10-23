# ==============================================================================
# Zsh Options
# ==============================================================================

# History options
setopt HIST_IGNORE_ALL_DUPS
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

# ==============================================================================
# Main Configurations and Sources
# ==============================================================================

[ -f "$HOME/.config/zsh/env.zsh" ] && source "$HOME/.config/zsh/env.zsh"
[ -f "$HOME/.config/zsh/aliases.zsh" ] && source "$HOME/.config/zsh/aliases.zsh"
[ -f "$HOME/.config/zsh/functions.zsh" ] && source "$HOME/.config/zsh/functions.zsh"
[ -f "$HOME/.config/zsh/keymap.zsh" ] && source "$HOME/.config/zsh/keymap.zsh"
[ -f "$HOME/.config/zsh/tools.zsh" ] && source "$HOME/.config/zsh/tools.zsh"
