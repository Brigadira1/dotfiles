#!/usr/bin/env bash

# WSL User Setup Script
# Creates a new user, installs sudo, and configures sudoers
# Must be run as root (default WSL user)

WSL_USER="brigadira"

echo "========================================="
echo "WSL User Setup Script"
echo "========================================="
echo

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "ERROR: This script must be run as root"
    echo "Please run as the default root user in WSL"
    exit 1
fi

echo "Installing sudo..."
if ! command -v sudo &>/dev/null; then
    pacman -Sy --needed --noconfirm sudo
    echo "✓ sudo installed"
else
    echo "✓ sudo is already installed"
fi

echo

# Check if wheel group exists, create if not
if ! getent group wheel &>/dev/null; then
    echo "Creating wheel group..."
    groupadd wheel
    echo "✓ wheel group created"
else
    echo "✓ wheel group already exists"
fi

echo

# Configure sudoers for wheel group
echo "Configuring sudoers to allow wheel group..."
if ! grep -q "^%wheel ALL=(ALL:ALL) ALL" /etc/sudoers; then
    # Use sed to uncomment the wheel line or add it if not present
    if grep -q "^# %wheel ALL=(ALL:ALL) ALL" /etc/sudoers; then
        sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
        echo "✓ Uncommented wheel group in sudoers"
    else
        echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers
        echo "✓ Added wheel group to sudoers"
    fi
else
    echo "✓ wheel group already configured in sudoers"
fi

echo

# Create user if doesn't exist
if id "$WSL_USER" &>/dev/null; then
    echo "✓ User $WSL_USER already exists"

    # Ensure user is in wheel group
    if ! groups "$WSL_USER" | grep -q wheel; then
        echo "Adding $WSL_USER to wheel group..."
        usermod -aG wheel "$WSL_USER"
        echo "✓ $WSL_USER added to wheel group"
    else
        echo "✓ $WSL_USER is already in wheel group"
    fi
else
    echo "Creating user: $WSL_USER"
    useradd -m -G wheel -s /bin/bash "$WSL_USER"
    echo "✓ User $WSL_USER created and added to wheel group"
    echo

    # Set password for the user
    echo "Please set a password for $WSL_USER:"
    passwd "$WSL_USER"
fi

echo
echo "========================================="
echo "Setup Complete!"
echo "========================================="
echo
echo "Next steps:"
echo "1. To set $WSL_USER as default WSL user, run in PowerShell/CMD:"
echo "   wsl -d <DistroName> -u $WSL_USER"
echo
echo "2. To set $WSL_USER as permanent default, run in PowerShell/CMD:"
echo "   <DistroName> config --default-user $WSL_USER"
echo "   (Replace <DistroName> with your Arch WSL distro name)"
echo
echo "3. To switch to $WSL_USER now, run:"
echo "   su - $WSL_USER"
echo
echo "========================================="
