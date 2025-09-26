# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# Copy this file to your home directory (replace the current one)

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	  *) return;;
esac

# Just source profile.bash which starts everything
if [ -f ~/.bash/src/profile.bash ]; then
	source ~/.bash/src/profile.bash;
fi
