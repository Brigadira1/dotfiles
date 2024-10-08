#!/usr/bin/env bash

# Redirect stdout to log.out
exec > >(tee -a log.out)

# Redirect stderr to log.err
exec 2> >(tee -a log.err >&2)

ARCH_PACKAGES_SCRIPT=add_arch_packages.sh
CUSTOM_CONF_SCRIPT=custom_apps_config.sh
STOW_SCRIPT=stow-dotfiles-script.sh
NVIDIA_MADNESS=nvidia_madness.sh
CURRENT_DIR=$(pwd)
echo "Trying to source $ARCH_PACKAGES_SCRIPT, $CUSTOM_CONF_SCRIPT, $DOT_OS_CONFIGS and $NVIDIA_MADNESS"

if [[ -f ./"${ARCH_PACKAGES_SCRIPT}"  &&  -x ./"${ARCH_PACKAGES_SCRIPT}" && -f ./"${STOW_SCRIPT}"  &&  -x ./"${STOW_SCRIPT}" && -f ./"${CUSTOM_CONF_SCRIPT}" && -x ./"${CUSTOM_CONF_SCRIPT}" && -f ./"${NVIDIA_MADNESS}" && -x ./"${NVIDIA_MADNESS}" ]]; then 
    . ./"${ARCH_PACKAGES_SCRIPT}" && . ./"${STOW_SCRIPT}" && . ./"${CUSTOM_CONF_SCRIPT}" && . ./"${NVIDIA_MADNESS}"
fi
sudo shutdown -h now
