# project.bash: executed by profile.bash
# ======================================
#
# Project Context Switching System
# ===============================
#
# This script provides a unified interface for switching between different
# development projects with automatic virtual environment activation and
# directory navigation.
#
# OVERVIEW
# --------
# The 'sw' function allows you to quickly switch between projects by:
# 1. Deactivating the current virtual environment (if any)
# 2. Changing to the project's working directory
# 3. Activating the project's virtual environment
# 4. Sourcing any project-specific bash scripts
#
# CONFIGURATION
# -------------
# Projects are defined in ~/.bash_projects using the following format:
#
#   declare -A projects=(
#       [project_id]="venv_name working_directory"
#       [myproject]="myvenv Work/myproject"
#       [webapp]="PIPENV Work/webapp"
#       [api]="- Work/api"
#   )
#
# Where:
#   - project_id: Short identifier for the project (used with 'sw project_id')
#   - venv_name: Virtual environment name or special value
#   - working_directory: Path relative to $HOME
#
# VIRTUAL ENVIRONMENT TYPES
# -------------------------
# The script supports multiple virtual environment managers:
#
#   - "PIPENV": Uses pipenv shell (requires pipenv to be installed)
#   - "venv_name": Uses workon (virtualenvwrapper) or conda activate
#   - "-": No virtual environment (just changes directory)
#   - "": Empty string (no virtual environment)
#
# The script will try these activation methods in order:
#   1. workon (virtualenvwrapper)
#   2. conda activate
#   3. Direct source of ~/.virtualenvs/venv_name/bin/activate
#   4. Local ./venv/bin/activate
#
# PROJECT-SPECIFIC SCRIPTS
# ------------------------
# You can create project-specific initialization scripts at:
#   ~/.bash_project.{project_id}
#
# These scripts are sourced when switching to a project and can set up:
#   - Environment variables
#   - Aliases
#   - PATH modifications
#   - Any other project-specific configuration
#
# USAGE
# -----
#   sw                    # List all available projects
#   sw project_id        # Switch to specific project
#   sw --help            # Show detailed help
#   sw -h                # Show detailed help
#
# EXAMPLES
# --------
#   sw                   # Shows project list and available environments
#   sw myproject         # Switches to 'myproject'
#   sw webapp            # Switches to 'webapp' using pipenv
#   sw api               # Switches to 'api' without virtual environment
#
# FEATURES
# --------
# - Tab completion for project names
# - Comprehensive error handling and validation
# - Support for multiple virtual environment managers
# - Automatic directory validation
# - Informative status messages
# - Help system with usage examples
#
# DEPENDENCIES
# ------------
# - bash 4.0+ (for associative arrays)
# - One or more of: virtualenvwrapper, conda, pipenv
# - ~/.bash_projects file with project definitions
#
# ERROR HANDLING
# --------------
# The script validates:
# - Project existence before switching
# - Working directory existence
# - Virtual environment tool availability
# - Proper deactivation of current environments
#
# AUTHOR
# ------
# Enhanced version with improved error handling, multiple venv support,
# and better user experience.

declare -A projects

[ -r ~/.bash_projects ] && source ~/.bash_projects

function sw() {
    local usage="Usage: sw [project_id] [-h|--help]
    
Switch to a project context with virtual environment activation.

Arguments:
  project_id    Name/ID of the project to switch to
  
Options:
  -h, --help    Show this help message
  
Examples:
  sw            List all available projects
  sw myproject  Switch to 'myproject'
  sw --help     Show this help message"

    # Show help if requested
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "$usage"
        return 0
    fi

    # Check if projects array is populated
    if [[ ${#projects[@]} -eq 0 ]]; then
        echo "No projects configured. Create ~/.bash_projects file with project definitions."
        echo "Format: declare -A projects=([project_id]=\"venv_name working_directory\")"
        return 1
    fi

    if [[ -n "$1" ]]; then
        local project_id="$1"
        
        # Check if project exists
        if [[ -z "${projects[$project_id]}" ]]; then
            echo "Error: Project '$project_id' not found."
            echo "Available projects:"
            for p in "${!projects[@]}"; do
                echo "  $p"
            done
            return 1
        fi

        # Parse project data
        local project_data=(${projects[$project_id]})
        local venv_name="${project_data[0]}"
        local work_dir="${project_data[1]}"
        
        echo "Switching to project: $project_id"
        echo "  Virtual environment: $venv_name"
        echo "  Working directory: $work_dir"

        # Deactivate current virtual environment if active
        if [[ -n "$VIRTUAL_ENV" ]]; then
            echo "Deactivating current environment: $VIRTUAL_ENV"
            deactivate 2>/dev/null || true
        fi

        # Change to working directory
        if [[ -n "$work_dir" ]]; then
            local full_path="$HOME/$work_dir"
            if [[ ! -d "$full_path" ]]; then
                echo "Error: Working directory does not exist: $full_path"
                return 1
            fi
            cd "$full_path" || {
                echo "Error: Failed to change to directory: $full_path"
                return 1
            }
            echo "Changed to directory: $full_path"
        fi

        # Source project-specific script if it exists
        local project_script="$HOME/.bash_project.$project_id"
        if [[ -f "$project_script" ]]; then
            echo "Sourcing project script: $project_script"
            source "$project_script"
        fi

        # Activate virtual environment
        if [[ "$venv_name" == "PIPENV" ]]; then
            if ! command -v pipenv >/dev/null 2>&1; then
                echo "Error: pipenv is not installed or not in PATH"
                return 1
            fi
            echo "Activating pipenv environment..."
            pipenv shell
        elif [[ "$venv_name" != "-" && -n "$venv_name" ]]; then
            # Try different virtual environment managers
            if command -v workon >/dev/null 2>&1; then
                echo "Activating virtualenv: $venv_name"
                workon "$venv_name"
            elif command -v conda >/dev/null 2>&1; then
                echo "Activating conda environment: $venv_name"
                conda activate "$venv_name"
            elif [[ -f "$HOME/.virtualenvs/$venv_name/bin/activate" ]]; then
                echo "Activating virtualenv: $venv_name"
                source "$HOME/.virtualenvs/$venv_name/bin/activate"
            elif [[ -f "./venv/bin/activate" ]]; then
                echo "Activating local venv"
                source "./venv/bin/activate"
            else
                echo "Warning: Could not activate virtual environment '$venv_name'"
                echo "Supported: virtualenv (workon), conda, or local venv"
            fi
        fi

        echo "Successfully switched to project: $project_id"
        return 0

    else
        # List all projects
        echo
        echo "Available Projects:"
        echo "=================="
        # Use eval to get array keys (more compatible)
        local project_keys
        eval "project_keys=(\${!projects[@]})"
        for project_id in "${project_keys[@]}"; do
            local project_data=(${projects[$project_id]})
            local venv_name="${project_data[0]}"
            local work_dir="${project_data[1]}"
            printf "  %-15s | venv: %-15s | dir: %s\n" "$project_id" "$venv_name" "$work_dir"
        done
        echo
        
        # Show available virtual environments
        echo "Available Virtual Environments:"
        echo "=============================="
        if command -v workon >/dev/null 2>&1; then
            workon 2>/dev/null || echo "  No virtualenv environments found"
        elif command -v conda >/dev/null 2>&1; then
            conda env list 2>/dev/null || echo "  No conda environments found"
        else
            echo "  No virtual environment manager detected"
        fi
        echo
        
        echo "Use 'sw <project_id>' to switch to a project"
        echo "Use 'sw --help' for more information"
        return 0
    fi
}

# Bash completion for project names
_sw_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local projects_list=""
    
    # Get list of project names
    local project_keys
    eval "project_keys=(\${!projects[@]})"
    for project in "${project_keys[@]}"; do
        projects_list="$projects_list $project"
    done
    
    COMPREPLY=( $(compgen -W "$projects_list --help -h" -- "$cur") )
}

complete -F _sw_completion sw
