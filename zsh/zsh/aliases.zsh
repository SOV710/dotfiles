# System
alias c='clear'
alias :q='exit'
alias q='exit'
alias e='exit'
alias ls='eza'
alias ll='eza -l --icons'
alias la='eza -la --icons'

# Git
alias ga='git add'
alias gc='git commit -m'
alias gitls='
git ls-files |
grep -Ev "\.(mp3|png|jpg|jpeg|gif|svg|woff2|mmdb|ico|csv|json|toml|lock|ini|md)$" |
grep -Ev "(^LICENSE$|\.gitignore$)" |
xargs wc -l
'

# Gadget
alias fd='fdfind'
