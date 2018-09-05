# .bash_profile: executed by ~/.bashrc
# Source the bash files that do the heavy lifting
# ~/.bash_private can be used for other settings you don’t want to commit

# Source the bash files:
for file in ~/.bash/.bash_{sensible,prompt,exports,aliases,functions,project,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Source the private bash file:
if [ -f ~/.bash_private ]; then
	source ~/.bash_private
fi
