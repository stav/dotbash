# project.bash: executed by profile.bash
# Project context switching using Python virtual environments

declare -A projekts

[ -r ~/.bash_projects ] && source ~/.bash_projects

function sw ()
{
	if [ ${#projekts[@]} -gt 0 ]; then # We have projects
		# echo " ${#projekts[@]} projects"

		if [ -n "$1" ]; then # We have a command argument
			# echo " Looking @ $1: (${projekts[$1]})"

			if [ -n "${projekts[$1]}" ]; then # We have a valid project
				# Partition project data line
				project=(${projekts[$1]})
				venv=${project[0]} # virtualenv
				vdir=${project[1]} # working directory
				# echo " Working on ($venv) in ($vdir)"

				# Change to working directory
				[ -n "$vdir" ] && cd "$HOME/$vdir"

				# Deactivate any current environment
				if [ -n "$VIRTUAL_ENV" ]; then # We have a venv activated
					deactivate
				fi

				# Activate environment
				if [ "$venv" == "-" ]; then
					pipenv shell
				else
					workon $venv
				fi
			else
				return 1
			fi

		else
			# List projects
			echo
			echo 'PROJECTS'
			echo
			for p in "${!projekts[@]}";do
				echo " $p : ${projekts[$p]}"
			done
			echo
			echo 'ENVIRONMENTS'
			echo
			workon
			return 0
		fi
	fi
}
