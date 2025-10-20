# Use Neovim as default editor
export EDITOR="nvim"
export VISUAL="nvim"

# Hide computer name in terminal
# export DEFAULT_USER="$(whoami)"

# Cargo
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Homebrew
if command -v brew >/dev/null; then
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
    export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
    export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
fi

# Pnpm
if [ -d "$HOME/.local/share/pnpm" ]; then
    export PNPM_HOME="$HOME/.local/share/pnpm"
    case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PATH:$PNPM_HOME" ;;
    esac
fi

# Node Version Manager
if [ -d "$XDG_CONFIG_HOME/nvm/" ]; then
    export NVM_DIR="$HOME/.config/nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"                   # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion" # This loads nvm bash_completion
fi

# zsh-syntax-highlighting (brew)
[ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] &&
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Disable underline
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# zsh-autosuggestions (brew)
[ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] &&
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Conda
if command -v conda &>/dev/null; then
    __conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
            . "/opt/miniconda3/etc/profile.d/conda.sh"
        else
            export PATH="$PATH:/opt/miniconda3/bin"
        fi
    fi
    unset __conda_setup
    export CONDA_CHANGEPS1=false
fi

# Starship
if command -v starship &>/dev/null; then
    export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
    starship config palette $STARSHIP_THEME
    # Check that the function `starship_zle-keymap-select()` is defined.
    # xref: https://github.com/starship/starship/issues/3418
    type starship_zle-keymap-select >/dev/null ||
        {
            eval "$(starship init zsh)"
        }
    export RUST_BACKTRACE=1
fi

# Zoxide
eval "$(zoxide init zsh)"

# Yazi
if command -v yazi &>/dev/null; then
    function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        IFS= read -r -d '' cwd <"$tmp"
        [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
        rm -f -- "$tmp"
    }
fi

# Doom Emacs
if command -v emacs &>/dev/null &&
    [ -d "$HOME/.config/emacs/bin/" ] &&
    [ -f "$HOME/.config/emacs/bin/doom" ]; then
    export PATH=$PATH:/home/chris/.config/emacs/bin
    export EMACSDIR="~/.config/emacs/"
fi

