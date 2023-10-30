function keep {
    shopt -s dotglob
    local location=$1
    shift
    local keep_items=("$@")
    for item in $location/*; do
        item=${item%*/}
        item=${item##*/}

        if [[ ! " ${keep_items[@]} " =~ " $item " ]] && [[ "$item" != "*" ]]; then
            warn "Deleting directory: $location/$item"
            sudo rm -rf "$location/$item"
        fi
    done
}

# Remove unwanted $HOME items
keep_home=(
    "apps"
    ".bash_logout"
    ".bash_profile"
    ".bashrc"
    ".cache"
    ".config"
    ".dotfiles"
    "dump"
    ".local"
    "media"
    ".mozilla"
    "office"
    ".ssh"
    "vault"
    "workstation"
)
keep "$HOME" "${keep_home[@]}"

# Remove unwanted $XDG_CONFIG_HOME items
keep_xdg_config=(
    "alacritty"
    "ansible"
    "aws"
    "dconf"
    "dunst"
    "emacs"
    "git"
    "tutanota-desktop"
    "gtk-2.0"
    "gtk-3.0"
    "htop"
    "i3"
    "java"
    "libreoffice"
    "light"
    "mimeapps.list"
    "npm"
    "picom"
    "polybar"
    "pulse"
    "python"
    "qBittorrent"
    "rofi"
    "systemd"
    "user-dirs.dirs"
    "VirtualBox"
    "wgetrc"
    "X11"
    "zathura"
)
keep "$XDG_CONFIG_HOME" "${keep_xdg_config[@]}"

# Remove unwanted $XDG_STATE_HOME items
keep_xdg_state=(
    "bash"
    "less"
    "node"
    "python"
    "wireplumber"
)
keep "$XDG_STATE_HOME" "${keep_xdg_state[@]}"

# Remove unwanted $XDG_CACHE_HOME items
keep_xdg_cache=(
)
keep "$XDG_CACHE_HOME" "${keep_xdg_cache[@]}"

# Remove unwanted $XDG_DATA_HOME items
keep_xdg_data=(
    "applications"
    "gem"
    "gnupg"
    "keyrings"
    "nano"
    "npm"
    "terminfo"
    ".pki"
    "python"
    "qBittorrent"
    "Trash"
    "wine"
    "xorg"
    "zathura"
)
keep "$XDG_DATA_HOME" "${keep_xdg_data[@]}"

# clean up lingering packages
sudo apt-get -y autoremove && sudo apt-get -y autoclean
