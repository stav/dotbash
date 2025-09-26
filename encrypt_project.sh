#!/bin/bash
# encrypt_project.sh - Manage encrypted project files in projects/ folder
# ===================================================================
#
# This script manages your .bash_project.*.sh files in the projects/ folder.
# It can encrypt/decrypt individual files or all files at once.
#
# USAGE:
#   ./encrypt_project.sh encrypt <project_id>    # Encrypt a specific project
#   ./encrypt_project.sh decrypt <project_id>    # Decrypt a specific project
#   ./encrypt_project.sh encrypt-all             # Encrypt all projects
#   ./encrypt_project.sh decrypt-all             # Decrypt all projects
#   ./encrypt_project.sh list                     # List all projects
#   ./encrypt_project.sh clean                   # Remove all decrypted files
#   ./encrypt_project.sh commit                  # Encrypt all and commit to git
#
# REQUIREMENTS:
#   - GPG installed and configured
#   - Your GPG key set up for encryption

set -euo pipefail

# Configuration
PROJECTS_DIR="projects"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PASSPHRASE_FILE="$SCRIPT_DIR/.encrypt_passphrase"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if GPG is available
check_gpg() {
    if ! command -v gpg >/dev/null 2>&1; then
        log_error "GPG is not installed. Please install GPG first."
        exit 1
    fi
}

# Read passphrase from file
get_passphrase() {
    if [[ ! -f "$PASSPHRASE_FILE" ]]; then
        log_error "Passphrase file not found: $PASSPHRASE_FILE"
        log_info "Create the file with your encryption passphrase:"
        log_info "echo 'your-passphrase' > $PASSPHRASE_FILE"
        exit 1
    fi
    
    # Read passphrase from file (trim whitespace)
    local passphrase
    passphrase=$(cat "$PASSPHRASE_FILE" | tr -d '\n\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    
    if [[ -z "$passphrase" ]]; then
        log_error "Passphrase file is empty: $PASSPHRASE_FILE"
        log_info "Add your encryption passphrase to the file"
        exit 1
    fi
    
    echo "$passphrase"
}

# Create projects directory if it doesn't exist
ensure_projects_dir() {
    if [[ ! -d "$SCRIPT_DIR/$PROJECTS_DIR" ]]; then
        mkdir -p "$SCRIPT_DIR/$PROJECTS_DIR"
        log_info "Created projects directory: $PROJECTS_DIR"
    fi
}

# Encrypt a single project file
encrypt_project() {
    local project_id="$1"
    local source_file="$SCRIPT_DIR/$PROJECTS_DIR/.bash_project.$project_id.sh"
    local encrypted_file="$SCRIPT_DIR/$PROJECTS_DIR/.bash_project.$project_id.sh.enc"
    
    if [[ ! -f "$source_file" ]]; then
        log_error "Source file not found: $source_file"
        log_info "Create your project file first in the projects/ folder."
        exit 1
    fi
    
    log_info "Encrypting $source_file..."
    
    local passphrase
    passphrase=$(get_passphrase)
    
    if gpg --batch --yes --passphrase "$passphrase" --symmetric --cipher-algo AES256 --output "$encrypted_file" "$source_file"; then
        log_success "Encrypted to: $encrypted_file"
        log_info "You can now commit the encrypted file to your repository."
    else
        log_error "Encryption failed"
        exit 1
    fi
}

# Decrypt a single project file
decrypt_project() {
    local project_id="$1"
    local encrypted_file="$SCRIPT_DIR/$PROJECTS_DIR/.bash_project.$project_id.sh.enc"
    local target_file="$SCRIPT_DIR/$PROJECTS_DIR/.bash_project.$project_id.sh"
    
    if [[ ! -f "$encrypted_file" ]]; then
        log_error "Encrypted file not found: $encrypted_file"
        exit 1
    fi
    
    # Check if decrypted file already exists
    if [[ -f "$target_file" ]]; then
        log_warning "Decrypted file already exists: $target_file"
        log_info "Comparing with encrypted version..."
        
        # Create temporary file to decrypt into
        local temp_decrypted
        temp_decrypted=$(mktemp)
        
        # Decrypt encrypted file to temporary location
        local passphrase
        passphrase=$(get_passphrase)
        
        if gpg --batch --yes --passphrase "$passphrase" --decrypt --output "$temp_decrypted" "$encrypted_file" 2>/dev/null; then
            # Compare the files
            if diff -q "$target_file" "$temp_decrypted" >/dev/null 2>&1; then
                log_success "Files are identical - decrypted file is up to date"
            else
                log_warning "Files differ - decrypted file has been modified since encryption"
                log_info "Current decrypted file is newer than encrypted version"
            fi
        else
            log_error "Failed to decrypt for comparison"
            rm -f "$temp_decrypted"
            return 1
        fi
        
        # Clean up temporary file
        rm -f "$temp_decrypted"
        log_info "Skipping decryption (preserving existing file)"
        log_info "You can use: sw $project_id"
        return 0
    fi
    
    log_info "Decrypting $encrypted_file..."
    
    local passphrase
    passphrase=$(get_passphrase)
    
    if gpg --batch --yes --passphrase "$passphrase" --decrypt --output "$target_file" "$encrypted_file"; then
        log_success "Decrypted to: $target_file"
        log_info "You can now use: sw $project_id"
    else
        log_error "Decryption failed"
        exit 1
    fi
}

# Encrypt all project files
encrypt_all() {
    log_info "Encrypting all project files..."
    local encrypted_count=0
    local skipped_count=0
    
    # Find all .sh files in projects directory
    while IFS= read -r -d '' file; do
        if [[ -f "$file" ]]; then
            local basename_file
            basename_file="$(basename "$file")"
            local project_id
            project_id="${basename_file#.bash_project.}"
            project_id="${project_id%.sh}"
            
            # Skip if already encrypted
            if [[ -f "$SCRIPT_DIR/$PROJECTS_DIR/.bash_project.$project_id.sh.enc" ]]; then
                log_warning "Skipping $project_id (already encrypted)"
                ((skipped_count++))
                continue
            fi
            
            log_info "Encrypting $project_id..."
            local passphrase
            passphrase=$(get_passphrase)
            
            if gpg --batch --yes --passphrase "$passphrase" --symmetric --cipher-algo AES256 --output "$SCRIPT_DIR/$PROJECTS_DIR/.bash_project.$project_id.sh.enc" "$file"; then
                log_success "Encrypted: $project_id"
                ((encrypted_count++))
            else
                log_error "Failed to encrypt: $project_id"
            fi
        fi
    done < <(find "$SCRIPT_DIR/$PROJECTS_DIR" -name ".bash_project.*.sh" -not -name "*.enc" -print0 2>/dev/null)
    
    log_success "Encrypted $encrypted_count file(s), skipped $skipped_count file(s)."
}

# Decrypt all project files
decrypt_all() {
    log_info "Decrypting all encrypted project files..."
    local decrypted_count=0
    local skipped_count=0
    
    # Find all .enc files in projects directory
    while IFS= read -r -d '' file; do
        if [[ -f "$file" ]]; then
            local basename_file
            basename_file="$(basename "$file")"
            local project_id
            project_id="${basename_file#.bash_project.}"
            project_id="${project_id%.sh.enc}"
            
            # Check if already decrypted and compare
            if [[ -f "$SCRIPT_DIR/$PROJECTS_DIR/.bash_project.$project_id.sh" ]]; then
                log_warning "Skipping $project_id (decrypted file already exists)"
                log_info "Comparing with encrypted version..."
                
                # Create temporary file to decrypt into
                local temp_decrypted
                temp_decrypted=$(mktemp)
                
                # Decrypt encrypted file to temporary location
                local passphrase
                passphrase=$(get_passphrase)
                
                if gpg --batch --yes --passphrase "$passphrase" --decrypt --output "$temp_decrypted" "$file" 2>/dev/null; then
                    # Compare the files
                    if diff -q "$SCRIPT_DIR/$PROJECTS_DIR/.bash_project.$project_id.sh" "$temp_decrypted" >/dev/null 2>&1; then
                        log_success "$project_id: Files are identical - up to date"
                    else
                        log_warning "$project_id: Files differ - decrypted file has been modified"
                    fi
                else
                    log_error "$project_id: Failed to decrypt for comparison"
                fi
                
                # Clean up temporary file
                rm -f "$temp_decrypted"
                ((skipped_count++))
                continue
            fi
            
            log_info "Decrypting $project_id..."
            local passphrase
            passphrase=$(get_passphrase)
            
            if gpg --batch --yes --passphrase "$passphrase" --decrypt --output "$SCRIPT_DIR/$PROJECTS_DIR/.bash_project.$project_id.sh" "$file"; then
                log_success "Decrypted: $project_id"
                ((decrypted_count++))
            else
                log_error "Failed to decrypt: $project_id"
            fi
        fi
    done < <(find "$SCRIPT_DIR/$PROJECTS_DIR" -name "*.enc" -print0 2>/dev/null)
    
    log_success "Decrypted $decrypted_count file(s), skipped $skipped_count file(s)."
}

# List all project files
list_projects() {
    log_info "Project files in $PROJECTS_DIR/:"
    echo
    
    # List decrypted files
    local decrypted_files=()
    while IFS= read -r -d '' file; do
        decrypted_files+=("$file")
    done < <(find "$SCRIPT_DIR/$PROJECTS_DIR" -name ".bash_project.*.sh" -not -name "*.enc" -print0 2>/dev/null)
    
    if [[ ${#decrypted_files[@]} -gt 0 ]]; then
        echo "Decrypted files:"
        for file in "${decrypted_files[@]}"; do
            local basename_file
            basename_file="$(basename "$file")"
            local project_id
            project_id="${basename_file#.bash_project.}"
            project_id="${project_id%.sh}"
            echo "  - $project_id (decrypted)"
        done
        echo
    fi
    
    # List encrypted files
    local encrypted_files=()
    while IFS= read -r -d '' file; do
        encrypted_files+=("$file")
    done < <(find "$SCRIPT_DIR/$PROJECTS_DIR" -name "*.enc" -print0 2>/dev/null)
    
    if [[ ${#encrypted_files[@]} -gt 0 ]]; then
        echo "Encrypted files:"
        for file in "${encrypted_files[@]}"; do
            local basename_file
            basename_file="$(basename "$file")"
            local project_id
            project_id="${basename_file#.bash_project.}"
            project_id="${project_id%.sh.enc}"
            echo "  - $project_id (encrypted)"
        done
        echo
    fi
    
    if [[ ${#decrypted_files[@]} -eq 0 && ${#encrypted_files[@]} -eq 0 ]]; then
        log_info "No project files found in $PROJECTS_DIR/"
    fi
}


# Compare decrypted files with their encrypted counterparts
compare_files() {
    log_info "Comparing decrypted files with their encrypted counterparts..."
    local out_of_sync=0
    local in_sync=0
    local missing_decrypted=0
    local missing_encrypted=0
    
    # Find all project files (both encrypted and decrypted)
    local all_files=()
    while IFS= read -r -d '' file; do
        all_files+=("$file")
    done < <(find "$SCRIPT_DIR/$PROJECTS_DIR" -name ".bash_project.*.sh*" -print0 2>/dev/null)
    
    # Extract unique project IDs
    local project_ids=()
    for file in "${all_files[@]}"; do
        local basename_file
        basename_file="$(basename "$file")"
        local project_id
        if [[ "$basename_file" == *.enc ]]; then
            project_id="${basename_file#.bash_project.}"
            project_id="${project_id%.sh.enc}"
        else
            project_id="${basename_file#.bash_project.}"
            project_id="${project_id%.sh}"
        fi
        project_ids+=("$project_id")
    done
    
    # Remove duplicates
    local unique_ids
    unique_ids=($(printf "%s\n" "${project_ids[@]}" | sort -u))
    
    if [[ ${#unique_ids[@]} -eq 0 ]]; then
        log_info "No project files found to compare."
        return 0
    fi
    
    echo "Project Comparison Results:"
    echo "=========================="
    
    for project_id in "${unique_ids[@]}"; do
        local decrypted_file="$SCRIPT_DIR/$PROJECTS_DIR/.bash_project.$project_id.sh"
        local encrypted_file="$SCRIPT_DIR/$PROJECTS_DIR/.bash_project.$project_id.sh.enc"
        
        if [[ ! -f "$decrypted_file" && ! -f "$encrypted_file" ]]; then
            continue
        elif [[ ! -f "$decrypted_file" ]]; then
            log_warning "$project_id: Missing decrypted file (encrypted exists)"
            ((missing_decrypted++))
        elif [[ ! -f "$encrypted_file" ]]; then
            log_warning "$project_id: Missing encrypted file (decrypted exists)"
            ((missing_encrypted++))
        else
            # Both files exist, compare them
            local temp_decrypted
            temp_decrypted=$(mktemp)
            
            # Decrypt the encrypted file to a temporary location
            local passphrase
            passphrase=$(get_passphrase)
            
            if gpg --batch --yes --passphrase "$passphrase" --decrypt --output "$temp_decrypted" "$encrypted_file" 2>/dev/null; then
                # Compare the decrypted content with the current decrypted file
                if diff -q "$decrypted_file" "$temp_decrypted" >/dev/null 2>&1; then
                    log_success "$project_id: Files are in sync"
                    ((in_sync++))
                else
                    log_warning "$project_id: Files are out of sync (decrypted file has been modified)"
                    ((out_of_sync++))
                fi
            else
                log_error "$project_id: Failed to decrypt for comparison"
                ((out_of_sync++))
            fi
            
            # Clean up temporary file
            rm -f "$temp_decrypted"
        fi
    done
    
    echo
    echo "Summary:"
    echo "--------"
    echo "In sync: $in_sync"
    echo "Out of sync: $out_of_sync"
    echo "Missing decrypted: $missing_decrypted"
    echo "Missing encrypted: $missing_encrypted"
    
    if [[ $out_of_sync -gt 0 || $missing_decrypted -gt 0 || $missing_encrypted -gt 0 ]]; then
        echo
        log_info "Recommendations:"
        if [[ $out_of_sync -gt 0 ]]; then
            echo "  - Run './encrypt_project.sh encrypt-all' to sync modified files"
        fi
        if [[ $missing_decrypted -gt 0 ]]; then
            echo "  - Run './encrypt_project.sh decrypt-all' to create missing decrypted files"
        fi
        if [[ $missing_encrypted -gt 0 ]]; then
            echo "  - Run './encrypt_project.sh encrypt-all' to create missing encrypted files"
        fi
    else
        log_success "All files are in sync!"
    fi
}

# Encrypt all and commit to git
commit_encrypted() {
    log_info "Encrypting all projects and committing to git..."
    
    # First encrypt all files
    encrypt_all
    
    # Add encrypted files to git
    log_info "Adding encrypted files to git..."
    git add "$SCRIPT_DIR/$PROJECTS_DIR/*.enc"
    
    # Commit
    log_info "Committing encrypted files..."
    git commit -m "Update encrypted project files"
    
    log_success "Encrypted files committed to git."
    log_info "You can now push with: git push"
}

# Show usage
show_usage() {
    cat << EOF
Usage: $0 <command> [project_id]

Commands:
  encrypt <project_id>    Encrypt .bash_project.<id>.sh in projects/
  decrypt <project_id>    Decrypt .bash_project.<id>.sh.enc in projects/
  encrypt-all             Encrypt all project files
  decrypt-all             Decrypt all project files
  list                    List all project files
  compare                 Compare decrypted files with encrypted counterparts
  commit                  Encrypt all and commit to git
  help                    Show this help message

Examples:
  $0 encrypt myproject     # Encrypt projects/.bash_project.myproject.sh
  $0 decrypt myproject     # Decrypt projects/.bash_project.myproject.sh.enc
  $0 encrypt-all           # Encrypt all projects
  $0 decrypt-all           # Decrypt all projects
  $0 list                  # Show all project files
  $0 compare               # Compare files for sync status
  $0 commit                # Encrypt all and commit to git

Notes:
  - Project files are stored in: $PROJECTS_DIR/
  - Only .enc files are committed to git
  - Use 'sw <project_id>' to switch to projects
EOF
}

# Main function
main() {
    check_gpg
    ensure_projects_dir
    
    case "${1:-}" in
        encrypt)
            if [[ -z "${2:-}" ]]; then
                log_error "Project ID required for encryption"
                show_usage
                exit 1
            fi
            encrypt_project "$2"
            ;;
        decrypt)
            if [[ -z "${2:-}" ]]; then
                log_error "Project ID required for decryption"
                show_usage
                exit 1
            fi
            decrypt_project "$2"
            ;;
        encrypt-all)
            encrypt_all
            ;;
        decrypt-all)
            decrypt_all
            ;;
        list)
            list_projects
            ;;
        compare)
            compare_files
            ;;
        commit)
            commit_encrypted
            ;;
        help|--help|-h)
            show_usage
            ;;
        *)
            log_error "Unknown command: ${1:-}"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
