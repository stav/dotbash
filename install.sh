#!/bin/bash
# install.sh: Install script
# Requires basename

dir=`pwd`
echo "$dir"

for file in "$dir"/.bash*; do
	name=$(basename $file)
	if [ -e ~/"$name" ]; then  # Check if file exists in home dir
		echo "$name exists, Moving from" ~/"$name" to ~/"$name"~
		mv ~/"$name" ~/"$name"~  # make backup
	fi
	echo 'Linking' "$dir/$name" to ~/"$name"
	ln -s "$dir/$name" ~/"$name"  # make symlink
done;
