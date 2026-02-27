#!/usr/bin/env bash

# WSL-specific Arch Linux package installation script
# Only installs CLI tools, no GUI applications or X server components

PACKAGES=""
INSTALLER_OPTIONS=" --needed --noconfirm"
mkdir -p ~/repos

initialize_packages() {

    # Core development tools (excluding linux-headers for WSL)
    local base_packages="base-devel glibc"

    # CLI tools only - removed GUI tools like pavucontrol, qt5ct
    local tools_packages=" git openssh wget curl rsync btop net-tools tree less pass pacman-contrib figlet"

    # Shell and terminal tools - keeping kitty for terminal emulator
    local shell_packages=" bash-completion starship kitty"

    # Compression utilities
    local compress_packages=" gzip zip fuse-zip unzip unrar"

    # Helper utilities - removed GUI components
    local helper_packages=" reflector man tldr"

    # Python and development
    local python_packages=" python python-uv python-psutil"

    # Neovim and essentials - removed xclip (X11 dependency)
    local neovim_packages=" neovim ripgrep nodejs npm"

    # Vifm file manager - lightweight, keeping helper tools
    local vifm_packages=" docx2txt mp3info w3m"

    # Yazi file manager - keeping poppler for PDF support
    local yazi_packages=" yazi 7zip poppler"

    # Core CLI and terminal tools - keeping tmux for terminal multiplexing
    local core_packages=" tmux"

    # DevOps and CLI productivity tools - keeping all useful tools
    local devops_packages=" stow zoxide eza fd fzf bat jq yq jqp rmlint ncdu speedtest-cli"

    # Essential CLI tools - removed all GUI apps (vlc-git, zathura, nsxiv, libreoffice-fresh, obsidian), kept glow (markdown viewer) and syncthing
    local essential_packages=" syncthing glow"

    PACKAGES+=$base_packages
    PACKAGES+=$tools_packages
    PACKAGES+=$shell_packages
    PACKAGES+=$compress_packages
    PACKAGES+=$helper_packages
    PACKAGES+=$python_packages
    PACKAGES+=$neovim_packages
    PACKAGES+=$vifm_packages
    PACKAGES+=$yazi_packages
    PACKAGES+=$core_packages
    PACKAGES+=$devops_packages
    PACKAGES+=$essential_packages

    echo
    echo -e "WSL packages assembled:\n\n$PACKAGES"
}

install_all_packages() {
    if [ -z "$PACKAGES" ]; then
        echo "The packages list is empty: PACKAGES=$PACKAGES"
        exit 1
    fi

    for s_package in $PACKAGES; do
        install_single_package "$s_package"
    done

}

install_single_package() {

    local package=$1

    if is_official_package $package; then
        echo
        echo "Installing $package with pacman"
        sudo pacman -S $INSTALLER_OPTIONS $package
    else
        if ! command -v yay &>/dev/null; then
            install_yay
        fi
        echo
        echo "Installing $package with yay"
        yay -S $INSTALLER_OPTIONS $package
    fi
}

is_official_package() {

    local package_name="$1"

    if pacman -Si $package_name &>/dev/null; then
        return 0
    else
        return 1
    fi

}

install_yay() {

    # Install base-devel and git if not already installed
    echo "Installing base-devel and git..."
    sudo pacman -S base-devel git $INSTALLER_OPTIONS

    # Create a temporary directory
    (
        temp_dir=$(mktemp -d)
        cd "$temp_dir"

        # Download PKGBUILD
        echo "Downloading yay PKGBUILD..."
        curl -O https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=yay

        # Build and install yay
        echo "Building and installing yay..."
        makepkg -si --noconfirm

        # Clean up
        cd
        rm -rf "$temp_dir"

        echo "yay has been installed successfully!"
    )

}

configure_services() {

    echo
    echo "Enabling sshd service..."
    sudo systemctl enable --now sshd

    echo
    echo "Enabling syncthing service..."
    # Note: Change 'brigadira' to your WSL username
    local wsl_user=$(whoami)
    echo "Setting up syncthing for user: $wsl_user"
    sudo systemctl enable --now syncthing@${wsl_user}.service

}

install_hack_nerd() {

    local fontconfig="$HOME/.config/fontconfig"
    echo "Starting installation of Hack Nerd font family..."
    sudo pacman -S $INSTALLER_OPTIONS ttf-hack-nerd noto-fonts-emoji

    mkdir -p "$fontconfig"
    echo '<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
    <alias>
        <family>Hack Nerd Font</family>
        <prefer>
            <family>Noto Color Emoji</family>
        </prefer>
    </alias>
</fontconfig>' > "$fontconfig/fonts.conf"

    echo "Updating font cache..."
    fc-cache -v

}

install_fzf-git_sh() {

    echo "Installing fzf-git.sh in the ~/repos folder"
    git clone https://github.com/junegunn/fzf-git.sh ~/repos/fzf-git.sh
}

configure_reflector() {

    echo "Configuring reflector for fastest mirrors..."
    # Using worldwide mirrors for better WSL performance
    sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
    echo "Enabling the reflector service..."
    sudo systemctl enable --now reflector.timer

}

upgrade_os() {

    echo
    echo "Upgrading Arch WSL to the latest version."
    sudo pacman -Syu --noconfirm
    echo
    echo "Arch WSL successfully upgraded"

}

echo "========================================="
echo "Arch Linux WSL Package Installation"
echo "CLI tools only - No GUI applications"
echo "========================================="

upgrade_os
configure_reflector
initialize_packages
install_all_packages
install_fzf-git_sh
configure_services
install_hack_nerd

echo
echo "========================================="
echo "Installation complete!"
echo "========================================="
echo
echo "Note: Make sure to configure your shell to use:"
echo "  - starship (prompt)"
echo "  - eza (ls replacement)"
echo "  - zoxide (cd replacement)"
echo "  - fzf (fuzzy finder)"
echo
echo "Add these to your .bashrc or .zshrc"
echo "========================================="
