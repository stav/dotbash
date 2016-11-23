# ~/.bash_aliases: executed by ~/.bash_profile
# examples taken from https://github.com/mathiasbynens/dotfiles

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	alias dir='dir --color=auto'
	alias vdir='vdir --color=auto'
	alias grep='grep --color=auto'
	alias egrep='egrep --color=auto'
	alias fgrep='fgrep --color=auto'
fi
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Listing
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Easier navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Change directory
alias dm="cd ~/Documents"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias wo="cd ~/Work"

# Common
alias h="history"

# Tree
alias t="tree -lpguh"
alias t1="tree -L 1 -lpguh"
alias t2="tree -L 2 -lpguh"
alias t3="tree -L 3 -lpguh"
alias t4="tree -L 4 -lpguh"

# Git
alias g="git"
alias ga='git commit --all'
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias gdm='git diff --name-status master'
alias gl='git lg '
alias go='git checkout '
alias gob='git checkout -b '
alias gom='git checkout master'
alias gos='git checkout staging'
alias gr='git rebase -i staging'
alias grs='git rebase -i staging'
alias grm='git rebase -i master'
# alias grh='git rebase -i HEAD~$1' # see functions
alias grc='git rebase --continue'
alias gs='git status '
alias gt='git mergetool '
alias gq='echo ...........; gb; echo ...........; gs; echo ...........; gl'

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Get week number
alias week='date +%V'

# Workflow
alias pf='pip freeze'
alias pup='pip install --upgrade pip'
