#!/bin/bash
# .bash_project.example.sh
# Example project file that demonstrates the project switching system
# This file shows how to set up a project environment

echo "Switching to example project (home directory)"

# Set project-specific environment variables
export PROJECT_ID="Example"
export PROJECT_DIR="$HOME"

# Print a banner
if command -v print_sw_banner >/dev/null 2>&1; then
    print_sw_banner "$PROJECT_ID"
else
    echo "=========================================="
    echo "  Project: $PROJECT_ID"
    echo "=========================================="
fi

# Enter the project directory
cd "$PROJECT_DIR"

# Run any project-specific setup commands
echo "Project setup complete!"
echo "Current directory: $(pwd)"
echo "Project ID: $PROJECT_ID"

# You can add more project-specific commands here:
# - Start development servers
# - Set up environment variables
# - Run database migrations
# - etc.
