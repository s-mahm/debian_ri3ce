apt_install() {
    # Avoid marking installed packages as manual by only installing missing ones
    local pkg=
    local pkgs=()
    local ok
    for pkg in "$@"; do
        # shellcheck disable=SC1083
        ok=$(dpkg-query --showformat=\${Version} --show "$pkg" 2>/dev/null || true)
        if [[ -z "$ok" ]]; then pkgs+=( "$pkg" ); fi
    done
    if (("${#pkgs[@]}")); then
        sudo DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install "${pkgs[@]}"
    fi
}

# Add non-free and contrib to debian sources
sudo tee /etc/apt/sources.list >/dev/null <<EOF
deb http://deb.debian.org/debian/ unstable main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ unstable main contrib non-free non-free-firmware
EOF

sudo apt-get update
sudo apt-get -y upgrade

# base packages
apt_install \
     build-essential \
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
    nvme-cli \
    ethtool \
    xdotool \
    parted \
    wine \
    zip \
    p7zip \
    unrar-free \
    ripgrep \
    ffmpegthumbnailer \
    mediainfo \
    usbutils \
    udevil \
    xclip \
    trash-cli \
    pass \
    keychain \
    hstr \
    fd-find \
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
    curl \
    wget \
    nmap

# power packages
apt_install \
    acpi \
    xfce4-power-manager \
    tlp

# display packages
apt_install \
    xbindkeys \
    xorg \
    xinit \
    light \
    lxappearance \
    xdg-user-dirs \
    xdg-user-dirs-gtk \
    xdg-utils \
    screen \
    imagemagick

# audio packages
apt_install \
    pulseaudio-utils \
    pavucontrol \
    pipewire

# application packages
apt_install \
    libreoffice-base \
    gparted \
    firefox \
    qbittorrent \
    alacritty \
    dconf-cli \
    dconf-editor \
    sxiv \
    redshift-gtk \
    pasystray \
    gnome-keyring \
    seahorse \
    xautolock \
    blueman \
    polybar \
    dunst \
    zathura

# markup packages
apt_install \
    jq \
    yq \
    yamllint

# android packages
apt_install \
    adb \
    fastboot \
    heimdall-flash

# font packages
apt_install \
    fonts-cantarell \
    fonts-dejavu \
    fonts-noto \
    fonts-noto-cjk \
    fonts-noto-cjk-extra \
    fonts-noto-color-emoji \
    fonts-noto-extra \
    fonts-noto-hinted \
    fonts-noto-mono \
    fonts-noto-unhinted \
    fonts-roboto \
    fonts-ubuntu \
    fonts-ubuntu-console \
    fonts-font-awesome \
    fonts-lato \
    fonts-opensymbol \
    fonts-liberation

sudo apt-get -y autoremove
