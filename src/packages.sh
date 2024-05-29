apt_install() {
	# Avoid marking installed packages as manual by only installing missing ones
	local pkg=
	local pkgs=()
	local ok
	for pkg in "$@"; do
		# shellcheck disable=SC1083
		ok=$(dpkg-query --showformat=\${Status} --show "$pkg" | grep "^install ok installed" 2>/dev/null || true)
		if [[ -z "$ok" ]]; then pkgs+=("$pkg"); fi
	done
	if (("${#pkgs[@]}")); then
		sudo DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install "${pkgs[@]}"
	fi
}

sudo apt-get update
sudo apt-get -y upgrade

# base packages
apt_install \
	build-essential \
	linux-headers-$(uname -r) \
	software-properties-common \
	cmake \
	dkms \
	suckless-tools \
	bash-completion \
	apt-transport-https \
	lsb-release \
	linux-base \
	git \
	gnupg \
	gnupg2 \
	dbus \
	dbus-broker \
	man-db \
	manpages

# build packages
apt_install \
	make \
	cmake \
	automake \
	autotools-dev \
	meson \
	ninja-build

# utility packages
apt_install \
	nano \
	ufw \
	scdoc \
	nvme-cli \
	ethtool \
	xdotool \
	parted \
	wine \
	zip \
	p7zip \
	gzip \
	unrar-free \
	ripgrep \
	ffmpegthumbnailer \
	mediainfo \
	usbutils \
	udevil \
    scdaemon \
	xclip \
	trash-cli \
	pinentry-tty \
	pass \
	keychain \
	hstr \
	fd-find \
	xdg-user-dirs \
	xdg-user-dirs-gtk \
	xdg-utils \
	desktop-file-utils \
	stow \
	ncdu \
	parallel \
	fzf \
	bc \
	scrot \
	diodon \
	picom \
	feh

# network packages
apt_install \
	openssh-server \
	net-tools \
	wpasupplicant \
	network-manager \
	wireless-tools \
	ca-certificates \
	curl \
	wget \
	nmap

# power packages
apt_install \
	acpi \
	tlp

# display packages
apt_install \
	xbindkeys \
	xorg \
	xinit \
	light \
	lxappearance \
	screen \
	redshift-gtk \
	imagemagick

# audio packages
apt_install \
	wireplumber \
	pipewire-pulse

# application packages
apt_install \
	vim \
    flatpak \
	libreoffice-base \
	gparted \
	firefox \
	qbittorrent \
	sxiv \
	wine \
	blueman \
	zathura

# rice packages
apt_install \
	i3 \
	i3lock \
	polybar \
	rofi \
	xautolock \
	dunst \
	dconf-cli \
	dconf-editor \
	pasystray

# dev packages (more in dev.sh)
apt_install \
	python3 \
	python3-venv \
	python3-pip \
	clangd \
	enchant-2
	jq \
	yq \
	yamllint

# android packages
apt_install \
	adb \
	fastboot \
	heimdall-flash

# clean up lingering packages
sudo DEBIAN_FRONTEND=noninteractive apt-get -y autoremove
