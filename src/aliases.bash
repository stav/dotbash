# aliases.bash: executed by profile.bash
# examples taken from https://github.com/mathiasbynens/dotfiles

# Change directory and list contents
alias wo="cd ~/Work && ls"
cl() { cd "$1" && ls; }

# Common
alias c="clear"
alias h="history"

# Tree
alias t="tree -lpguh"
alias t1="tree -L 1 -lpguh"
alias t2="tree -L 2 -lpguh"
alias t3="tree -L 3 -lpguh"
alias t4="tree -L 4 -lpguh"

# Git
alias gq=git_dash  # see functions

# Enable aliases to be sudo'ed
alias sudo='sudo '

# Get week number
alias week='date +%V'

# Network
alias xip='dig @resolver1.opendns.com ANY myip.opendns.com +short'
