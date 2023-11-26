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
HISTIGNORE="$HISTIGNORE:c:h:l:ll:reset"

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

# # Solana
# export PATH="$PATH:$HOME/.local/share/solana/install/active_release/bin"

# # RubyGems
# export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
# export PATH="$PATH:$GEM_HOME/bin"

# Deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/home/stav/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Flutter
export CHROME_EXECUTABLE=/var/lib/snapd/snap/bin/chromium
# Gradle
export JAVA_HOME=/home/stav/Applications/android-studio/jbr

# Perl
PATH="/home/stav/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/stav/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/stav/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/stav/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/stav/perl5"; export PERL_MM_OPT;

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH
