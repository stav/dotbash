# .bash_functions: executed by .bash_profile
# Functions allow for more complex script

# Re-source bash files
function sbp ()
{
	# seealso:: reload from bash_it
	# TODO: check if in venv and deactivate/activate
	deactivate
	source ~/.bash/.bash_profile
}

# Repeat a character: `repeat - 10`
function repeat ()
{
	# printf "{$1}%.0s" {1..{$2}}
    # seq  -f "$1" -s '' $2; echo
    yes $1 | head -$2 | paste -s -d '' -
}

# Git rebase head [ num-prev-commits ]
function git_rebase_head ()
{
	git rebase -i HEAD~$1
}

# Git dashboard with status and stuff
function git_dash ()
{
	# Ignore errors https://github.com/pypa/pipenv/issues/2753
	yes '' 2>/dev/null | sed 9q  # print blank lines
	repeat . 100 2>/dev/null  # print 100 dots as a section separator
	gb
	repeat . 100 2>/dev/null  # print 100 dots as a section separator
	gs
	repeat . 100 2>/dev/null  # print 100 dots as a section separator
	gl
}
