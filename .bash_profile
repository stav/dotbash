# ~/.bash_profile: executed by ~/.bashrc
# Source the bash files that do the heavy lifting
# .bash_extra can be used for other settings you don’t want to commit

# Load the shell dotfiles, and then some:
for file in ~/.bash_{path,prompt,exports,aliases,functions,sensible,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Bash Completion

# http://www.linuxjournal.com/content/more-using-bash-complete-command
# seealso: https://github.com/scrapy/scrapy/blob/master/extras/scrapy_bash_completion
# function _mycomplete_()
# {
#     local cmd="${1##*/}"
#     local word=${COMP_WORDS[COMP_CWORD]}
#     local line=${COMP_LINE}
#     local xpat
#     COMPREPLY=($(compgen -f -X "$xpat" -- "${word}"))
# }
# complete -d -X '.[^./]*' -F _mycomplete_ myfoo mybar

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi
