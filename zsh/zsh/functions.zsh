# touchp: touch --parent
touchp() {
    mkdir -p "$(dirname "$1")" && touch "$1"
}

# ppath: path manager
source "$HOME/.config/zsh/functions/ppath.zsh"
