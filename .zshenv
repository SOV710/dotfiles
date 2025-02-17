# set up rust's cargo toolchain
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Secrets
[ -f "$HOME/.env" ] && source "$HOME/.env"

# XDG Base directory specification
export XDG_CONFIG_HOME="$HOME/.config"         # Config files
export XDG_CACHE_HOME="$HOME/.cache"           # Cache files
export XDG_DATA_HOME="$HOME/.local/share"      # Application data
export XDG_STATE_HOME="$HOME/.local/state"     # Logs and state files

# Themes
export TMUX_THEME="onedark"
export NVIM_THEME="onedark"
export STARSHIP_THEME="onedark"

# Locale settings
export LANG="en_US.UTF-8" # Sets default locale for all categories
export LC_ALL="en_US.UTF-8" # Overrides all other locale settings
export LC_CTYPE="en_US.UTF-8" # Controls character classification and case conversion

# Use Neovim as default editor
export EDITOR="nvim"
export VISUAL="nvim"

# Add /usr/local/bin to the beginning of the PATH environment variable.
# This ensures that executables in /usr/local/bin are found before other directories in the PATH.
export PATH="/usr/local/bin:$PATH:/usr/local/go/bin"

# Hide computer name in terminal
export DEFAULT_USER="$(whoami)"

# Proxy settings
export http_proxy="http://127.0.0.1:7897"
export https_proxy="http://127.0.0.1:7897"
