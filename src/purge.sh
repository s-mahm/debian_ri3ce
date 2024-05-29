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
	".bash_logout"
	".bash_profile"
	".bashrc"
	".cache"
	".config"
	".dotfiles"
	".local"
	".mozilla"
	".ssh"
	"apps"
	"dump"
	"media"
	"office"
	"workstation"
    ".hstr_favorites"
    ".var"
)
keep "$HOME" "${keep_home[@]}"

# Remove unwanted $XDG_CONFIG_HOME items
keep_xdg_config=(
	"X11"
	"alacritty"
	"ansible"
	"aws"
	"dconf"
	"dunst"
	"emacs"
	"git"
	"go"
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
	"tutanota-desktop"
	"user-dirs.dirs"
	"vim"
	"wgetrc"
	"zathura"
)
keep "$XDG_CONFIG_HOME" "${keep_xdg_config[@]}"

# Remove unwanted $XDG_STATE_HOME items
keep_xdg_state=(
	"bash"
	"less"
	"vim"
	"node"
	"python"
	"wireplumber"
)
keep "$XDG_STATE_HOME" "${keep_xdg_state[@]}"

# Remove unwanted $XDG_CACHE_HOME items
keep_xdg_cache=(
	"emacs"
)
keep "$XDG_CACHE_HOME" "${keep_xdg_cache[@]}"

# Remove unwanted $XDG_DATA_HOME items
keep_xdg_data=(
	".pki"
	"Trash"
	"applications"
	"gem"
	"gnupg"
	"icons"
	"keyrings"
	"nano"
	"npm"
	"python"
	"qBittorrent"
	"terminfo"
	"themes"
	"vim"
	"wine"
	"xorg"
	"zathura"
    "docker"
    "flatpack"
    "fonts"
    "mega"
)
keep "$XDG_DATA_HOME" "${keep_xdg_data[@]}"

# clean up lingering packages
sudo apt-get -y autoremove && sudo apt-get -y autoclean
