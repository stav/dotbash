# extra.bash: executed by profile.bash

# Less
# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Completion
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

# Fuzzy find
# https://github.com/junegunn/fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Bash-it
[ -f ~/.bash-it.bash ] && source ~/.bash-it.bash

# https://github.com/pypa/pipenv
if [ -x "$(command -v pipenv)" ]; then
	eval "$(pipenv --completion)"
fi

# nvm
# https://github.com/creationix/nvm
NVM_DIR="$HOME/.nvm"
if [ -d "$NVM_DIR" ]; then
	export NVM_DIR
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
else
	unset NVM_DIR
fi

# Deno
# deno completions bash > /usr/local/etc/bash_completion.d/deno.bash
source /usr/local/etc/bash_completion.d/deno.bash

# Rust
source "$HOME/.cargo/env"

# Ruby rbenv
eval "$(rbenv init - bash)"

# Python Conda initialize
__conda_setup="$('/home/stav/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/stav/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/stav/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/stav/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
