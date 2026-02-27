#!/bin/bash

# WSL-specific dotfiles stow script
# Only stows CLI tool configurations, excludes GUI applications

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Directory containing your dotfiles (parent of scripts directory)
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
# Backup directory
BACKUP_DIR="$HOME/backup"

# List of packages to stow for WSL (CLI tools only)
PACKAGES_TO_STOW=(
    arch          # Core dotfiles (.bashrc, .bash_profile, etc.)
    bat           # Cat replacement with syntax highlighting
    kitty         # Terminal emulator
    ncdu          # Disk usage analyzer
    nvim          # Neovim text editor
    starship      # Shell prompt
    tmux          # Terminal multiplexer
    yazi          # Modern file manager
)

# List of folders to ignore
IGNORE_LIST=(
    .git
    .claude
    NvChad_experiments
    scripts
    X11
    xorgxrdp
    ubuntu
    Windows
    alacritty
    btop
    gtk-2.0
    gtk-3.0
    gtk-4.0
    nitrogen
    picom
    qt5ct
    qtile
    rofi
    vifm
    wallpapers
    tmux/.config/tmux/plugins
)

# Function to backup a file or directory
backup_item() {
    local item=$1
    if [ -e "$item" ]; then
        echo "Backing up: $item to $BACKUP_DIR/$(basename "$item")"
        cp -R "$item" "$BACKUP_DIR/"
    fi
}

# Function to stow a single package
stow_package() {
    local package=$1
    local config_dir="$HOME/.config"
    local package_dir="$config_dir/$package"
    echo "Processing $package..."

    if [ "$package" = "arch" ]; then
        # Handle dotfiles in ~/dotfiles/arch
        for file in "$DOTFILES_DIR/$package"/.*; do
            if [ -f "$file" ] && [ "$(basename "$file")" != "." ] && [ "$(basename "$file")" != ".." ]; then
                local basename=$(basename "$file")
                local home_file="$HOME/$basename"
                if [ -e "$home_file" ]; then
                    backup_item "$home_file"
                    echo "Removing existing $home_file"
                    rm "$home_file"
                fi
            fi
        done
    elif [ -d "$package_dir" ]; then
        # Check if the package has a corresponding folder in ~/.config
        backup_item "$package_dir"
        echo "Removing existing $package_dir"
        rm -rf "$package_dir"
    fi

    # Stow the package
    stow -d "$DOTFILES_DIR" -t "$HOME" "$package"
    echo "$package stowed successfully"
}

# Function to create .stow-local-ignore file
create_stow_local_ignore() {
    local ignore_file="$DOTFILES_DIR/.stow-local-ignore"
    echo "Creating .stow-local-ignore file..."

    # Ensure dotfiles directory exists
    if [ ! -d "$DOTFILES_DIR" ]; then
        echo "Error: Dotfiles directory not found at $DOTFILES_DIR"
        exit 1
    fi

    printf "%s\n" "${IGNORE_LIST[@]}" > "$ignore_file"
    echo ".stow-local-ignore file created at $ignore_file"
}

# Function to stow all specified packages
stow_all_packages() {
    for package in "${PACKAGES_TO_STOW[@]}"; do
        if [ -d "$DOTFILES_DIR/$package" ]; then
            stow_package "$package"
        else
            echo "Warning: $package not found in $DOTFILES_DIR"
        fi
    done
}

# Function to backup specific dotfiles
backup_specific_dotfiles() {
    local dotfiles=(".bashrc" ".bash_profile" ".xinitrc" ".Xresources" ".xprofile")
    for file in "${dotfiles[@]}"; do
        backup_item "$HOME/$file"
    done
}

# Main function to manage dotfiles
manage_dotfiles() {
    echo "========================================="
    echo "WSL Dotfiles Stow Script"
    echo "CLI tool configurations only"
    echo "========================================="
    echo
    echo "Dotfiles directory: $DOTFILES_DIR"
    echo "Backup directory: $BACKUP_DIR"
    echo

    # Verify dotfiles directory exists
    if [ ! -d "$DOTFILES_DIR" ]; then
        echo "Error: Dotfiles directory not found at $DOTFILES_DIR"
        exit 1
    fi

    echo "Starting dotfiles management..."

    # Create backup directory
    mkdir -p "$BACKUP_DIR"
    echo "Backup directory created at $BACKUP_DIR"

    # Backup specific dotfiles
    backup_specific_dotfiles

    create_stow_local_ignore
    stow_all_packages

    echo
    echo "========================================="
    echo "Dotfiles management complete"
    echo "========================================="
    echo
    echo "Backups stored in: $BACKUP_DIR"
    echo
    echo "Stowed packages:"
    for package in "${PACKAGES_TO_STOW[@]}"; do
        echo "  - $package"
    done
    echo "========================================="
}

# Invoke the main function
manage_dotfiles
