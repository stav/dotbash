# Project File Encryption System

This system allows you to store your `.bash_project.*.sh` files encrypted in your public repository, keeping your private code secure while maintaining a public repository.

## Overview

- **Project files**: Stored in `projects/` directory (both encrypted and unencrypted)
- **Manual decryption**: Use `./encrypt_project.sh decrypt-all` to decrypt all projects
- **Git integration**: Only `.enc` files are committed to the repository
- **Bulk operations**: Encrypt/decrypt all projects at once

## Setup

### 1. Install GPG

Make sure you have GPG installed and configured:

```bash
# Install GPG (if not already installed)
# On Ubuntu/Debian:
sudo apt-get install gnupg

# On macOS:
brew install gnupg

# On Arch/Manjaro:
sudo pacman -S gnupg
```

### 2. Set up Encryption Passphrase

Create a passphrase file (this will be ignored by git):

```bash
echo "your-secret-passphrase" > .encrypt_passphrase
```

**Important**: Choose a strong passphrase and keep the `.encrypt_passphrase` file secure. This file is automatically ignored by git.

### 3. Test the System

```bash
# Test the help
./encrypt_project.sh help
```

## Usage

### Creating Encrypted Project Files

1. **Create your project file** in `projects/`:
   ```bash
   # Create your project file
   cat > projects/.bash_project.myproject.sh << 'EOF'
   #!/bin/bash
   echo "Switching to my private project"
   export PROJECT_ID="MyPrivateProject"
   cd ~/Projects/MyPrivateProject
   # Your private setup commands here
   EOF
   ```

2. **Encrypt the file**:
   ```bash
   ./encrypt_project.sh encrypt myproject
   ```

3. **Commit the encrypted file**:
   ```bash
   git add projects/.bash_project.myproject.sh.enc
   git commit -m "Add encrypted project file"
   git push
   ```

### Using Projects

The `sw` command works with decrypted project files:

```bash
# First, decrypt all projects
./encrypt_project.sh decrypt-all

# List all projects
sw

# Switch to a project
sw myproject
```

### Bulk Operations

The new system supports bulk operations for managing all projects at once:

```bash
# Encrypt all project files
./encrypt_project.sh encrypt-all

# Decrypt all project files
./encrypt_project.sh decrypt-all

# List all project files (encrypted and decrypted)
./encrypt_project.sh list

# Clean up all decrypted files
./encrypt_project.sh clean

# Encrypt all and commit to git
./encrypt_project.sh commit
```

### Managing Project Files

```bash
# List all project files (encrypted and decrypted)
./encrypt_project.sh list

# Individual operations
./encrypt_project.sh encrypt myproject     # Encrypt a specific project
./encrypt_project.sh decrypt myproject     # Decrypt a specific project

# Bulk operations
./encrypt_project.sh encrypt-all           # Encrypt all projects
./encrypt_project.sh decrypt-all           # Decrypt all projects
./encrypt_project.sh clean                 # Remove all decrypted files
./encrypt_project.sh commit                # Encrypt all and commit to git
```

## File Structure

```
.bash/
├── encrypt_project.sh              # Encryption utility
├── projects/                       # Directory for all project files
│   ├── .bash_project.*.sh        # Your project files (ignored by git)
│   └── .bash_project.*.sh.enc     # Your encrypted project files (committed)
├── src/
│   └── project.bash               # Modified to handle encryption
└── .gitignore                     # Updated to ignore non-encrypted files
```

## Security Notes

- **Never commit decrypted files**: The `.gitignore` is configured to prevent this
- **Keep your GPG key secure**: Your GPG key is required to decrypt files
- **Backup your GPG key**: If you lose your GPG key, you'll lose access to encrypted files
- **Use strong passphrases**: When creating your GPG key, use a strong passphrase

## Workflow

### For New Projects

1. **Create project file** in `projects/` folder:
   ```bash
   # Create your project file
   cat > projects/.bash_project.myproject.sh << 'EOF'
   #!/bin/bash
   echo "Switching to my project"
   export PROJECT_ID="MyProject"
   cd ~/Projects/MyProject
   # Your setup commands here
   EOF
   ```

2. **Test the project**:
   ```bash
   sw myproject
   ```

3. **Encrypt all projects**:
   ```bash
   ./encrypt_project.sh encrypt-all
   ```

4. **Commit to repository**:
   ```bash
   ./encrypt_project.sh commit
   ```

### For Existing Projects

1. **Move existing project files** to `projects/` folder:
   ```bash
   mv ~/.bash_project.*.sh projects/
   ```

2. **Encrypt all projects**:
   ```bash
   ./encrypt_project.sh encrypt-all
   ```

3. **Commit to repository**:
   ```bash
   ./encrypt_project.sh commit
   ```

### For Team Members

1. **Clone the repository**
2. **Set up GPG** (if not already done):
   ```bash
   gpg --gen-key
   ```
3. **Decrypt all projects**:
   ```bash
   ./encrypt_project.sh decrypt-all
   ```
4. **Use projects normally**:
   ```bash
   sw <project_id>  # Works with decrypted files
   ```

## Troubleshooting

### GPG Issues

```bash
# Check if GPG is working
gpg --list-secret-keys

# Test encryption/decryption
echo "test" | gpg --symmetric --cipher-algo AES256
```

### Decryption Fails

- Ensure your GPG key is available: `gpg --list-secret-keys`
- Check if the encrypted file exists: `ls projects/*.enc`
- Try manual decryption: `gpg --decrypt projects/.bash_project.*.sh.enc`
- List all projects: `./encrypt_project.sh list`

## Advanced Usage

### Multiple GPG Keys

If you have multiple GPG keys, you can specify which one to use:

```bash
# List your keys
gpg --list-secret-keys

# Use a specific key (modify the encrypt_project.sh script)
gpg --local-user "your-key-id" --symmetric ...
```

### Manual Decryption

You need to manually decrypt files before using them:

```bash
# Decrypt all encrypted projects
./encrypt_project.sh decrypt-all

# Or decrypt individual projects
./encrypt_project.sh decrypt myproject
```

## Integration with Existing Workflow

This system is designed to work seamlessly with your existing bash configuration:

- No changes needed to your existing project files
- The `sw` command works exactly the same
- Manual decryption when needed
- All existing functionality is preserved
