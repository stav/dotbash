# functions.bash: executed by profile.bash
# Functions allow for more complex script

# Re-source bash files
function sbp ()
{
	# TODO: check if in venv and deactivate/activate
	deactivate
	source ~/.bash/src/profile.bash
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
	echo
}

# Print a full-width purple banner with centered white text
function print_sw_banner ()
{
	local text="$1"
	local cols
	cols=${COLUMNS:-$(tput cols 2>/dev/null || echo 80)}
	local purple_bg='\033[48;5;57m\033[38;5;231m'
	local reset='\033[0m'

	# Top bar
	printf "%b%*s%b\n" "$purple_bg" "$cols" "" "$reset"
	# Centered text line
	local pad
	pad=$(( (cols - ${#text}) / 2 ))
	(( pad < 0 )) && pad=0
	printf "%b%*s%s%*s%b\n" "$purple_bg" "$pad" "" "$text" "$pad" "" "$reset"
	# Bottom bar and spacing
	printf "%b%*s%b\n" "$purple_bg" "$cols" "" "$reset"
}
