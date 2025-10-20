# Auto-suggestions accept
bindkey '^ ' autosuggest-accept

# Vi-mode
bindkey -v
export KEYTIMEOUT=1 # Makes switching modes quicker

# Vi-mode Cursor
zle-line-init() {
    zle -K viins      # initiate 'vi insert' as keymap (can be removed if 'binkey -V has been set elsewhere')
    echo -ne '\e[2 q' # always use block cursor
}
zle -N zle-line-init
echo -ne '\e[2 q' # Use block shape cursor on startup

# # Yank to the system clipboard
# function vi-yank-xclip {
#     zle vi-yank
#     echo "$CUTBUFFER" | wl-copy
# }
#
# zle -N vi-yank-xclip
# bindkey -M vicmd 'y' vi-yank-xclip
