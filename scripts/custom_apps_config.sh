#!/usr/bin/env bash

echo "Configuring ./config directory ...."

CURRENT_DIR=$HOME/dotfiles/scripts/
CURRENT_CONFIG_DIR=$HOME/.config
CONFIG_DIR_APPS="alacritty nvim rofi picom qtile starship wallpapers bat btop ncdu nitrogen gtk-3.0 gtk-4.0 qt5ct tmux"
IS_BACKUP_TAKEN=false

configure_apps_dir() {

    handle_app_configs backup
    handle_app_configs delete
    handle_app_configs copy

}

backup_app_config() {

    local app_folder=$1

    if [ ! -d $CURRENT_CONFIG_DIR/backup ]; then
        echo "Backup directory doesn't exist ..."
        echo "Creating backup directory in $CURRENT_CONFIG_DIR/backup ..."
        mkdir -p "$CURRENT_CONFIG_DIR/backup"
        echo 
    fi

    if [[ -d $CURRENT_CONFIG_DIR/$app_folder && $IS_BACKUP_TAKEN == "false" ]]; then
        echo "Backing up $CURRENT_CONFIG_DIR/$app_folder ..."
        cp -rf "$CURRENT_CONFIG_DIR/$app_folder" "$CURRENT_CONFIG_DIR/backup"
        echo 
    fi

}

delete_old_config() {

    local app_folder=$1
    backup_app_config $app_folder

    if [ -d $CURRENT_CONFIG_DIR/$app_folder ]; then
        echo "Deleting $CURRENT_CONFIG_DIR/$app_folder ..."
        rm -rf $CURRENT_CONFIG_DIR/$app_folder
        echo 
    fi

}

copy_new_config() {

    local app_folder=$1

    delete_old_config app_folder
    (
        cd ..
        echo "Copying from $(pwd)/$app_folder to $CURRENT_CONFIG_DIR"
        cp -rf "./$app_folder" "$CURRENT_CONFIG_DIR"
        echo 
    )

}

handle_app_configs() {

    local action="$1"
    for app in $CONFIG_DIR_APPS; do
        if [[ $action == "backup" ]]; then
            backup_app_config $app
        elif [[ $action == "delete" ]]; then
            delete_old_config $app
        elif [[ $action == "copy" ]]; then
            copy_new_config $app
        else
            echo "The only possible actions are: backup, delete or copy"
            echo "You've specified invalid action: $action "
            echo 
        fi
    done
    IS_BACKUP_TAKEN=true
}

handle_qt5ct_env() {

    local xsession_folder="/etc/X11/Xsession.d"

    if [ ! -d "$xsession_folder" ]; then
        echo
        echo "Setting up Qt5ct. $xsession_folder folder is not present. Creating it..."
        sudo mkdir -p "$xsession_folder"
    else
        echo "'$xsession_folder' already exists.Nothing to do..."
        echo 
    fi
    if [ ! -f "$xsession_folder"/100-qt5ct ]; then
        echo "File 100-qt5ct doesn't exist. Creating it..."
        sudo touch "$xsession_folder/100-qt5ct"
        echo 
    else
        echo "'$xsession_folder/100-qt5ct' already exists. Nothing to do..."
        echo 
    fi
    if ! sudo grep -Fxq "export QT_QPA_PLATFORMTHEME=qt5ct" "$xsession_folder/100-qt5ct"; then
        echo "Setting up 'export QT_QPA_PLATFORMTHEME=qt5ct' in '$xsession_folder/100-qt5ct'"
        echo "export QT_QPA_PLATFORMTHEME=qt5ct" | sudo tee -a "$xsession_folder/100-qt5ct" >/dev/null
        echo 
    else
        echo "'export QT_QPA_PLATFORMTHEME=qt5ct' is already setup.Nothing to do..."
        echo 
    fi

}

handle_gtk_2() {

    local gtkrc=".gtkrc-2.0"
    if [ -f "$HOME/$gtkrc" ]; then
        echo "'$HOME/$gtkrc' exists. Taking a backup..."
        mkdir -p "$CURRENT_CONFIG_DIR/backup"
        cp "$HOME/$gtkrc" "$CURRENT_CONFIG_DIR/backup"
    fi
    (
        cd ..
        echo "Copying '$(pwd)/$gtkrc' to '$HOME/$gtkrc'"
        cp "$(pwd)/$gtkrc" "$HOME/$gtkrc"
        echo 
    )

}

handle_lightdm_greeters() {

    local lightdm_conf="/etc/lightdm/lightdm.conf"
    local web_greeter_conf="/etc/lightdm/web-greeter.yml"
    local nvidia_meta_mode_script="/home/brigadira/repos/conffiles/X11/gpu-accelerated/nvidia_metamode.sh"

    echo "Checking to see whether lightdm display manager is installed on the system..."
    if ! sudo pacman -Qi lightdm &>/dev/null; then
        echo "Lightdm is not installed on the system. Skipping...."
        return 1
    fi
    echo "Lightdm is installed on the system. Web greeter and web-greeter-theme-shikai theme will be configured"
    if [ ! -f "$lightdm_conf" ]; then
        echo "$lightdm_conf doesn't exist. Exiting..."
        return 1
    fi
    echo "Setting up web-greeter to be the default lightdm greeter..."
    replace_line_in_file "#greeter-session=.*" "greeter-session=web-greeter" "$lightdm_conf"
    replace_line_in_file "#display-setup-script=.*" "display-setup-script=$nvidia_meta_mode_script" "$lightdm_conf"

    if [ ! -f "$web_greeter_conf" ]; then
        echo "$web_greeter_conf doesn't exist. Exiting...."
        return 1
    fi
    echo "Setting up web-greeter shikai theme to be used..."
    replace_line_in_file "^[[:space:]]*background_images_dir:[[:space:]].*" "    background_images_dir: /usr/share/web-greeter/themes/shikai/assets/media/wallpapers/" "$web_greeter_conf"
    replace_line_in_file "^[[:space:]]*logo_image:[[:space:]].*" "    logo_image: /usr/share/web-greeter/themes/shikai/assets/media/logos/" "$web_greeter_conf"
    replace_line_in_file "^[[:space:]]*theme:[[:space:]].*" "    theme: shikai" "$web_greeter_conf"

}

removing_grub_delay() {

    local grub_config="/etc/default/grub"

    echo 
    echo "Removing the default GRUB menu during boot up, and changing the waiting time delay from 5 sec. to 0"
    echo "Backing up the original grub config file..."
    if [ -f "$grub_config" ]; then
        echo "Taking backup of $grub_config..."
        sudo cp -f "$grub_config" "${grub_config}.bak"
        echo 
    else
        echo "No grub configuration file found. Exiting...."
        echo 
    fi
    replace_line_in_file "^GRUB_TIMEOUT=.*" "GRUB_TIMEOUT=0" "$grub_config"
    replace_line_in_file "^GRUB_TIMEOUT_STYLE=.*" "GRUB_TIMEOUT_STYLE=hidden" "$grub_config"

}

replace_line_in_file() {

    local original_line="$1"
    local target_line="$2"
    local file="$3"

    echo "Replacing '$1' with '$2' in '$3'"
    sudo sed -i "s@$1@$2@" "$3"

}

handle_bat_theme() {

    echo "Invoking bat cache --build"
    bat cache --build
    echo

}

install_tmux_plugin_manager() {

    echo "Installing the tmux plugin manager..."
    mkdir -p ~/.config/tmux/plugins/tpm
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
    echo 

}

configure_apps_dir
#Dirty quick hack. One needs to invoke bat in order to refresh its theme
handle_bat_theme
handle_qt5ct_env
handle_gtk_2
handle_lightdm_greeters
install_tmux_plugin_manager
removing_grub_delay