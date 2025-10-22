# ==============================================================================
# Cross-Desktop Directory Specifications
# ==============================================================================

# XDG Base directory specification
export XDG_CONFIG_HOME="$HOME/.config"     # Config files
export XDG_CACHE_HOME="$HOME/.cache"       # Cache files
export XDG_DATA_HOME="$HOME/.local/share"  # Application data
export XDG_STATE_HOME="$HOME/.local/state" # Logs and state files

# Locale settings
export LANG="en_US.UTF-8"     # Sets default locale for all categories
export LC_ALL="en_US.UTF-8"   # Overrides all other locale settings
export LC_CTYPE="en_US.UTF-8" # Controls character classification and case conversion

# ==============================================================================
# THEMES
# ==============================================================================

# Color setting for themes
export TERM="xterm-256color"

# Themes
export TMUX_THEME="onedark"
export NVIM_THEME="onedark"
export STARSHIP_THEME="onedark"

# ==============================================================================
# PATH Related
# ==============================================================================

if [ -d "/usr/local/bin" ]; then
    case ":$PATH:" in
    *":/usr/local/bin:"*) ;;
    *) export PATH="$PATH:/usr/local/bin" ;;
    esac
fi

if [ -d "$HOME/.local/bin" ]; then
    case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) export PATH="$HOME/.local/bin:$PATH" ;;
    esac
fi

if [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then
    case ":$PATH:" in
    *":/home/linuxbrew/.linuxbrew/bin:"*) ;;
    *) export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH" ;;
    esac
fi

# ==============================================================================
# Other Environment Variables
# ==============================================================================

[ -f "$HOME/.env" ] && source "$HOME/.env"

# Gentoo Qemu
export ISO=install-amd64-minimal-20250831T170358Z.iso
export DISK=gentoo.qcow2
export OVMF_CODE=/usr/share/OVMF/OVMF_CODE_4M.fd
export OVMF_VARS=OVMF_VARS_gentoo.fd
