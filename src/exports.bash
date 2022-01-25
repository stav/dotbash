# exports.bash: executed by profile.bash

# # Virtual Environment Setup
# # http://virtualenvwrapper.readthedocs.org/en/latest/install.html#shell-startup-file
# export PROJECT_HOME=$HOME/Work
# export WORKON_HOME=$HOME/.virtualenvs
# source /usr/share/virtualenvwrapper/virtualenvwrapper.sh

# Bash_It overrides this so we add it to extra.bash
# export GREP_COLOR='1;32'

# Add `~/bin` to the `$PATH` : this is double dipping from ~/.profile
# export PATH="$HOME/bin:$PATH";

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=100000
HISTIGNORE="$HISTIGNORE:h:l:ll:reset"

# # Poetry Python management https://poetry.eustace.io/
# if [ -d $HOME/.poetry/bin ]; then
# 	export PATH="$HOME/.poetry/bin:$PATH"
# fi

# # Pyenv Python version management https://github.com/pyenv/pyenv
# if [ -d $HOME/.pyenv/bin ]; then
# 	export PATH="$HOME/.pyenv/bin:$PATH"
# 	eval "$(pyenv init -)"
# 	eval "$(pyenv virtualenv-init -)"
# fi

# Deno
export DENO_INSTALL="/home/stav/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# Solana
export PATH="/home/stav/.local/share/solana/install/active_release/bin:$PATH"
