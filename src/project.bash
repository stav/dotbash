# project.bash: executed by profile.bash
# ======================================
#
# Project Context Switching System
# ================================
#
# OVERVIEW
# --------
# This script provides a simple project switching mechanism using per-project
# configuration scripts. It allows you to quickly switch between different
# development environments with custom setup commands.
#
# USAGE
# -----
#   sw <project_id>               # Switch to project identified by <project_id>
#   sw -h, sw --help              # Show help and list available projects
#
# BEHAVIOR
# --------
# 1. Searches for a script named `.bash_project.<project_id>.sh`
# 2. Search order: current directory first, then $HOME
# 3. Sources the first script found
# 4. The script should handle cd and any other project-specific setup
#
# PROJECT SCRIPT FORMAT
# ---------------------
# Create `.bash_project.<project_id>.sh` files with your project setup:
#
#   #!/bin/bash
#   # Example: .bash_project.myapp.sh
#   export PROJECT_ID=MyApp
#   print_sw_banner "$PROJECT_ID"
#   cd ~/Projects/MyApp
#   npm run dev
#
# SEARCH LOCATIONS
# ----------------
# 1. ./bash_project.<project_id>.sh    # Current directory (preferred)
# 2. ~/.bash_project.<project_id>.sh   # Home directory (fallback)
#
# EXAMPLE USAGE
# --------
#   # List available projects
#   sw
#
#   # Switch to the project
#   sw myproject
#
#   # Show help
#   sw --help
#
# INTEGRATION
# -----------
# This script integrates with:
# - print_sw_banner() function for consistent project banners
# - Bash completion for project_id tab-completion
# - Standard bash sourcing mechanism

function sw() {
    local usage="Usage: sw [project_id] [-h|--help]
    
Switch to a new project context with custom setup commands.

Sources .bash_project.<project_id>.sh from current dir, $HOME, or projects/ folder.

Arguments:
  project_id    Name/ID of the project to switch to

Options:
  -h, --help    Show this help message

Examples:
  sw            List all available projects
  sw myproject  Switch to 'myproject'
  sw --help     Show this help message
"


    # Helper to print available tokens
    local _sw_print_tokens
    _sw_print_tokens() {
        declare -A token_to_path=()
        local tokens=()
        shopt -s nullglob
        # Check for regular project files
        for f in "./.bash_project."*.sh "$HOME/.bash_project."*.sh "$HOME/.bash/projects/.bash_project."*.sh; do
            [[ -f "$f" ]] || continue
            local base
            base="$(basename "$f")"
            local t
            t="${base#.bash_project.}"
            t="${t%.sh}"
            # Prefer first occurrence (current dir before $HOME)
            if [[ -z "${token_to_path[$t]}" ]]; then
                local abs
                if command -v readlink >/dev/null 2>&1; then
                    abs="$(readlink -f "$f" 2>/dev/null || true)"
                fi
                if [[ -z "$abs" ]]; then
                    local dir
                    dir="$(cd "$(dirname "$f")" && pwd)"
                    abs="$dir/$(basename "$f")"
                fi
                token_to_path[$t]="$abs"
                tokens+=("$t")
            fi
        done
        
        shopt -u nullglob
        if [[ ${#tokens[@]} -eq 0 ]]; then
            echo "  (none found)"
            return
        fi
        echo "Projects:"
        # Find the maximum length of project IDs for alignment
        local max_len=0
        for tok in "${tokens[@]}"; do
            if [[ ${#tok} -gt $max_len ]]; then
                max_len=${#tok}
            fi
        done
        
        printf "%s\n" "${tokens[@]}" | sort -u | while IFS= read -r tok; do
            printf "  %-${max_len}s | %s\n" "$tok" "${token_to_path[$tok]}"
        done
    }

    if [[ -z "$1" || "$1" == "-h" || "$1" == "--help" ]]; then
        echo "$usage"
        _sw_print_tokens
        return 0
    fi

    local token="$1"
    local script_local="./.bash_project.$token.sh"
    local script_home="$HOME/.bash_project.$token.sh"
    local script_projects="$HOME/.bash/projects/.bash_project.$token.sh"
    local target_script=""

    if [[ -f "$script_local" ]]; then
        target_script="$script_local"
    elif [[ -f "$script_home" ]]; then
        target_script="$script_home"
    elif [[ -f "$script_projects" ]]; then
        target_script="$script_projects"
    else
        echo "Error: script not found: .bash_project.$token.sh (searched ./ and $HOME and projects/)"
        return 1
    fi

    echo "Sourcing project script: $target_script"
    # shellcheck disable=SC1090
    source "$target_script"
}



# Bash completion for sw tokens (based on discovered scripts)
_sw_scripts_completion() {
    local cur
    cur="${COMP_WORDS[COMP_CWORD]}"

    # Collect tokens from ./ and $HOME, preferring local duplicates implicitly
    local tokens=()
    shopt -s nullglob
    # Regular project files
    for f in "./.bash_project."*.sh "$HOME/.bash_project."*.sh "$HOME/.bash/projects/.bash_project."*.sh; do
        [[ -f "$f" ]] || continue
        local base t
        base="$(basename "$f")"
        t="${base#.bash_project.}"
        t="${t%.sh}"
        tokens+=("$t")
    done
    
    shopt -u nullglob

    # Deduplicate and complete
    local uniq
    uniq=$(printf "%s\n" "${tokens[@]}" | sort -u)
    COMPREPLY=( $(compgen -W "$uniq --help -h" -- "$cur") )
}

complete -F _sw_scripts_completion sw
