# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# include .xprofile if it exists
if [ -f "$HOME/.xprofile" ]; then
    . "$HOME/.xprofile"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Source Cargo environment if available
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

# If your default shell is zsh, ensure .profile is sourced
if [ -n "$ZSH_VERSION" ]; then
    # Ensure compatibility by sourcing .profile in .zshrc if needed
    if [ -f "$HOME/.profile" ]; then
        source "$HOME/.profile"
    fi
fi
