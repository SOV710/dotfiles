#!/usr/bin/env sh
set -eu

# ANSI color codes
C_RESET='\033[0m'
C_GREEN='\033[32m'
C_YELLOW='\033[33m'
C_GRAY='\033[90m'

# Directories
SRC_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"
HOME_DIR="$HOME"
ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# Simple logging helpers
log_step() { printf "${C_YELLOW}==>%s${C_RESET}\n" " $*"; }
log_info() { printf "${C_GRAY}%s${C_RESET}\n" "  $*"; }
log_done() { printf "${C_GREEN}%s${C_RESET}\n" "$*"; }

# Copy with backup
copy_file() {
	src="$1"
	dst="$2"
	if [ -e "$dst" ]; then
		mv -f "$dst" "$dst.bak.$(date +%Y%m%d%H%M%S)"
		log_info "backup: $(basename "$dst")"
	fi
	cp -pf "$src" "$dst"
	log_info "copy:   $(basename "$src") -> $(dirname "$dst")"
}

# 1) Ensure zsh config directory exists
log_step "Creating directory $ZDOTDIR"
mkdir -p "$ZDOTDIR"

# 2) Copy dotfiles to $HOME
log_step "Installing dotfiles to $HOME_DIR"
for f in .zprofile .zshenv .zshrc; do
	if [ -f "$SRC_DIR/$f" ]; then
		copy_file "$SRC_DIR/$f" "$HOME_DIR/$f"
	fi
done

# 3) Copy zsh subdirectory to $ZDOTDIR
if [ -d "$SRC_DIR/zsh" ]; then
	log_step "Installing zsh configs to $ZDOTDIR"
	(
		cd "$SRC_DIR/zsh"
		find . -mindepth 1 -print | while IFS= read -r path; do
			src="$SRC_DIR/zsh/$path"
			dst="$ZDOTDIR/$path"
			if [ -d "$src" ]; then
				mkdir -p "$dst"
				log_info "mkdir: $dst"
			else
				mkdir -p "$(dirname "$dst")"
				if [ -e "$dst" ]; then
					mv -f "$dst" "$dst.bak.$(date +%Y%m%d%H%M%S)"
					log_info "backup: $dst"
				fi
				cp -pf "$src" "$dst"
				log_info "copy:   $src -> $dst"
			fi
		done
	)
fi

log_done "Install complete: dotfiles -> $HOME_DIR , zsh configs -> $ZDOTDIR"
