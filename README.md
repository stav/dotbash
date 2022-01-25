# README

Bash scripts used for interactive user

## Install

	$ git clone git@github.com:stav/dotbash.git ~/.bash

	$ mv ~/.bashrc ~/.bashrc.bak

	$ cp ~/.bash/.bashrc ~

# Also copy .bash-it.bash to your home directory to use Bash-It

	$ cp ~/.bash/.bash-it.bash ~

## Scripts

* `~/.bashrc`                - Source `~/.bash/src/profile.bash`
* `~/.bash/src/profile.bash` - Source the rest of the files
* `~/.bash_projects`         - User-defined, see `~/.bash/.bash_projects`
* `~/.bash_private`          - User-defined, settings you don’t want to commit
* `~/.bash-it.bash`          - https://github.com/Bash-it/bash-it

## Startup Files

http://www.gnu.org/software/bash/manual/bashref.html#Bash-Startup-Files

### Login

1. `/etc/profile`
2. `~/.bash_profile`
3. `~/.bash_login`
4. `~/.profile`

### Shell

1. `/etc/bash.bashrc`
2. `~/.bashrc`
