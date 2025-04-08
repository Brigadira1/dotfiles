#!/bin/bash

# Directory containing your dotfiles
DOTFILES_DIR="$HOME/dotfiles"
# Backup directory
BACKUP_DIR="$HOME/backup"

# List of packages to stow
PACKAGES_TO_STOW=(
    alacritty
    arch
    bat
    btop
    gtk-2.0
    gtk-3.0
    gtk-4.0
    ncdu
    nitrogen
    nvim
    picom
    qt5ct
    qtile
    rofi
    starship
    tmux
    wallpapers
    vifm
    yazi
    kitty
)

# List of folders to ignore
IGNORE_LIST=(
    .git
    NvChad_experiments
    scripts
    X11
    xorgxrdp
    ubuntu
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
    echo "Starting dotfiles management..."
    
    # Create backup directory
    mkdir -p "$BACKUP_DIR"
    echo "Backup directory created at $BACKUP_DIR"
    
    # Backup specific dotfiles
    backup_specific_dotfiles
    
    create_stow_local_ignore
    stow_all_packages
    
    echo "Dotfiles management complete"
    echo "Backups stored in $BACKUP_DIR"
}

# Invoke the main function
manage_dotfiles
