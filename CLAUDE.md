# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a cross-platform dotfiles repository managing configuration files for Linux (Arch-based) and Windows environments using GNU Stow for symlink management.

## Core Architecture

### Platform Structure
- **Linux configurations**: `arch/`, `qtile/`, `picom/`, `X11/`, `xorgxrdp/`
- **Windows configurations**: `Windows/PowerShell_Profile/`, `Windows/GlazeWM/`, `Windows/komorebi/`, `Windows/YASB/`
- **Cross-platform tools**: `nvim/`, `yazi/`, `tmux/`, `alacritty/`, `kitty/`, `starship/`, `bat/`, `vifm/`
- **Scripts**: `scripts/` - installation and setup scripts for Linux
- **Experiments**: `NvChad_experiments/` - experimental Neovim configurations (not stowed by default)

### Dotfile Organization Pattern
Each tool's configuration follows the structure: `<tool>/.config/<tool>/config-file`. This allows GNU Stow to create symlinks from `$HOME` to the repository, maintaining the proper `.config` directory structure.

Special case: `arch/` contains root-level dotfiles (`.bashrc`, `.bash_profile`, `.xinitrc`, `.Xresources`, `.xprofile`) that are directly symlinked to `$HOME`.

### Stow Management
The repository uses `.stow-local-ignore` to exclude directories from the stow process:
- `.git`, `NvChad_experiments`, `scripts`, `X11`, `xorgxrdp`, `ubuntu`
- `tmux/.config/tmux/plugins` (managed by TPM)

Packages stowed by default (see `scripts/stow-dotfiles-script.sh`):
`alacritty`, `arch`, `bat`, `btop`, `gtk-2.0`, `gtk-3.0`, `gtk-4.0`, `ncdu`, `nitrogen`, `nvim`, `picom`, `qt5ct`, `qtile`, `rofi`, `starship`, `tmux`, `wallpapers`, `vifm`, `yazi`, `kitty`

## Setup Scripts

### Linux Installation (`scripts/`)
- **`main.sh`**: Master orchestration script that runs all setup scripts in sequence, then shuts down the system
- **`add_arch_packages.sh`**: Installs Arch Linux packages (base-devel, xorg, qtile, nvidia, development tools, essential applications)
- **`custom_apps_config.sh`**: Performs custom application configurations
- **`stow-dotfiles-script.sh`**: Main stow script that:
  - Creates backups in `$HOME/backup`
  - Removes existing config directories
  - Stows all packages from the defined list
  - Creates `.stow-local-ignore` automatically
- **`nvidia_madness.sh`**: NVIDIA driver configuration

### Windows Setup
PowerShell profiles are located at `Windows/PowerShell_Profile/`:
- **`Microsoft.PowerShell_profile_home.ps1`**: Home environment with komorebi window manager support
- **`Microsoft.PowerShell_profile_work.ps1`**: Work environment with fastfetch on startup

Both profiles use caching for faster loading:
- Zoxide and Starship initialization scripts are cached in `$PROFILE/../Cache/`
- First run generates cached scripts, subsequent runs source them directly
- Yazi shell wrapper function `y` for directory navigation
- Eza replaces `ls` and `dir` commands

## Key Tools Configuration

### Window Managers
- **Linux**: Qtile (`qtile/.config/qtile/config.py`)
  - Mod key: Super (mod4)
  - Terminal: kitty
  - Browser: brave
  - File manager: yazi
  - Launcher: rofi
- **Windows**:
  - GlazeWM config: `Windows/GlazeWM/config.yaml`
  - Komorebi configs: `Windows/komorebi/komorebi.json`, `Windows/komorebi/whkdrc`

### Shell & Prompt
- **Starship**: `starship/.config/starship/starship.toml` - Git-aware prompt with language version display
- **PowerShell**: Both profiles implement identical optimization patterns with environment-specific tweaks

### File Management
- **Yazi**: `yazi/.config/yazi/yazi.toml`
  - Custom openers for PDF (zathura), Office docs (libreoffice), images (nsxiv), video (vlc)
  - Plugins: archivemount, bookmarks, smart-enter, what-size
  - Windows-specific plugins in `yazi/.config/yazi/win/`
  - Flavors: tokyo-night theme

### Terminal Multiplexer
- **Tmux**: `tmux/.config/tmux/tmux.conf`
  - Prefix: `Ctrl+a` (instead of default `Ctrl+b`)
  - Plugins via TPM: vim-tmux-navigator, tmux-themepack, tmux-yank, tmux-resurrect, tmux-continuum, tmux-tokyo-night, tmux-sessionx
  - Sessions persist in `~/tmux-sessions`
  - Auto-restore enabled via tmux-continuum

### Text Editor
- **Neovim**: `nvim/.config/nvim/` - Has its own CLAUDE.md for detailed guidance
  - Entry point: `init.lua`
  - Uses lazy.nvim for plugin management

## Common Workflows

### Stowing Dotfiles on Linux
```bash
cd ~/dotfiles
./scripts/stow-dotfiles-script.sh
```
This backs up existing configs to `$HOME/backup` before stowing.

### Full Linux System Setup
```bash
cd ~/dotfiles/scripts
chmod +x *.sh
./main.sh
```
Warning: This runs all installation scripts and shuts down the system afterward.

### Installing a Single Package with Stow
```bash
cd ~/dotfiles
stow -d . -t $HOME <package-name>
```

### Unstowing a Package
```bash
cd ~/dotfiles
stow -D -d . -t $HOME <package-name>
```

### Restowing (update symlinks after file changes)
```bash
cd ~/dotfiles
stow -R -d . -t $HOME <package-name>
```

### Windows Profile Installation
Copy the appropriate profile to PowerShell profile location:
```powershell
$PROFILE  # Shows profile path
# Copy Microsoft.PowerShell_profile_home.ps1 or _work.ps1 to that location
```

## Important Notes

- Git ignores generated files: log files (`scripts/log.out`, `scripts/log.err`), plugin directories (`tmux/plugins`), cache files (`btop.conf`, `nitrogen/*.cfg`, `vifminfo.json`), and lock files (`lazy-lock.json`)
- The `arch/` directory contains root-level dotfiles that must be stowed separately to `$HOME` (not `$HOME/.config`)
- Tmux plugins are managed by TPM (Tmux Plugin Manager), not Stow
- PowerShell profiles create a `Cache/` directory automatically for performance optimization
- NVIDIA configurations are in `X11/gpu-accelerated/` and handled by `nvidia_madness.sh`
- Neovim configuration is managed separately - refer to `nvim/.config/nvim/CLAUDE.md` for details
