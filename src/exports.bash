# exports.bash: executed by profile.bash

# Virtual Environment Setup
# http://virtualenvwrapper.readthedocs.org/en/latest/install.html#shell-startup-file
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Work
source /usr/share/virtualenvwrapper/virtualenvwrapper.sh

# Slack Ubuntu 16.04 : make non-OSD notifications use notify-send
# Also in /usr/share/applications/slack.desktop
# export ELECTRON_USE_UBUNTU_NOTIFIER=1

# Bash_It overrides this so we add it to extra.bash
# export GREP_COLOR='1;32'

# Add `~/bin` to the `$PATH` : this is double dipping from ~/.profile
# export PATH="$HOME/bin:$PATH";

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=100000
HISTIGNORE="$HISTIGNORE:h:l:ll:reset"

# Poetry Python management https://poetry.eustace.io/
if [ -d $HOME/.poetry/bin ]; then
	export PATH="$HOME/.poetry/bin:$PATH"
fi

# Pyenv Python version management https://github.com/pyenv/pyenv
if [ -d $HOME/.pyenv/bin ]; then
	export PATH="$HOME/.pyenv/bin:$PATH"
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
fi
