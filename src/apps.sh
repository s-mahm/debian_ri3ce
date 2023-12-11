apps_emacs() {
	emacs_latest=$(
		wget --connect-timeout=5 -qO- http://ftpmirror.gnu.org/emacs/ |
			grep -Po "emacs-\\d\\d\.\\d" |
			tail -1 |
			sed 's/^emacs-//'
	)
	info "Latest emacs version is $emacs_latest"
	emacs_current=$(emacs --version | grep -P "GNU Emacs \d" | grep -Po "\d+\.\d+" || true)
	info "Current emacs version is $emacs_current"

	# install emacs if old or absent
	if [[ "$FORCE" == 1 ]] || ! [ $(version $emacs_current) -ge $(version $emacs_latest) ]; then
		if [[ "$FORCE" == 1 ]]; then
			info "Installing latest emacs version"
		else
			info "Updating emacs from $emacs_current to $emacs_latest"
		fi
		# installed required libraries
		sudo apt install -y autoconf make gcc texinfo libgtk-3-dev libxpm-dev \
			libjpeg-dev libgif-dev libtiff5-dev libgnutls28-dev libncurses-dev \
			libjansson-dev libharfbuzz-dev libharfbuzz-bin imagemagick libmagickwand-dev \
			libgccjit-10-dev libgccjit0 gcc-10 libjansson4 libjansson-dev xaw3dg-dev texinfo libx11-dev

		# get latest emacs repo
		cd /tmp
		emacs_mirror=$(curl -Ls -o /dev/null -w %{url_effective} http://ftpmirror.gnu.org/emacs)
		wget ${emacs_mirror}/emacs-${emacs_latest}.tar.gz -P /tmp/
		tar -xf emacs*.tar.gz
		rm emacs*.tar.gz

		# build and install emacs
		export CC="gcc-10"
		cd emacs*
		./autogen.sh
		./configure --with-native-compilation -with-json --with-modules --with-harfbuzz --with-compress-install \
			--with-threads --with-included-regex --with-x-toolkit=lucid --with-zlib --with-jpeg --with-png \
			--with-imagemagick --with-tiff --with-xpm --with-gnutls --with-xft --with-xml2 --with-mailutils
		make -j 8
		sudo make install
	else
		warn "Not installing emacs"
	fi
}

apps_alacritty() {
    alacritty_latest=$(latest_release alacritty/alacritty)
    info "Latest alacritty version is $alacritty_latest"
    alacritty_current=$(alacritty --version | grep -Po '\d+\.\d+\.\d+' || true)
    info "Current alacritty version is $alacritty_current"
	# install alacritty if old or absent
	if [[ "$FORCE" == 1 ]] || (! [ $(version $alacritty_current) -ge $(version "0.13.0") ] && ! [ $(version $alacritty_latest) -ge $(version $alacritty_current) ]); then
        info "Installing latest alacritty version"
		# installed required libraries
		sudo apt-get -y install pkg-config libfreetype6 libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev

		# build binary
		rm -rf /tmp/alacritty
		git clone https://github.com/alacritty/alacritty.git /tmp/alacritty
		cd /tmp/alacritty
		cargo build --release

		# install terminfo
		if ! infocmp alacritty; then
			sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
		fi

		# install binary and desktop entry
		sudo cp target/release/alacritty /usr/bin
		sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
		sudo desktop-file-install extra/linux/Alacritty.desktop
		sudo update-desktop-database

		# manual page
		sudo mkdir -p /usr/local/share/man/man1
		sudo mkdir -p /usr/local/share/man/man5
		scdoc <extra/man/alacritty.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz >/dev/null
		scdoc <extra/man/alacritty-msg.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz >/dev/null
		scdoc <extra/man/alacritty.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz >/dev/null
		scdoc <extra/man/alacritty-bindings.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz >/dev/null

		# shell completions
		mv extra/completions/alacritty.bash ~/.dotfiles/bash/.local/state/bash/bash_completions/alacritty
    else
        warn "Not installing alacritty"
	fi
}

apps_yubikey() {
    sudo add-apt-repository ppa:yubico/stable -y
    sudo apt-get update
    sudo apt install yubikey-manager
    sudo apt install yubikey-manager-qt
}

apps_tutanota() {
    flatpak install flathub com.tutanota.Tutanota
}

apps_whatsapp() {
    flatpak install flathub io.github.mimbrero.WhatsAppDesktop
}

apps_bitwarden() {
    flatpak install flathub com.bitwarden.desktop
}

apps_obsidian() {
    flatpak install flathub md.obsidian.Obsidian
}

apps_xdgninja() {
    git clone https://github.com/b3nj5m1n/xdg-ninja.git $APPLICATIONS/xdg-ninja
}

if [ $# -gt 0 ]; then
	apps_$1 $@
else
	for cmd in $(function_list_parser apps); do
		apps_$cmd
	done
fi
