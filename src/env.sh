# create fonts folder
sudo mkdir -p /usr/share/fonts

# install feather fonts if absent
if ! fc-list | grep feather; then
    sudo mkdir -p /usr/share/fonts/feather
    rm -rf /tmp/featherfont
    git clone https://github.com/AT-UI/feather-font /tmp/featherfont
    sudo mv /tmp/featherfont/src/fonts/feather.ttf /usr/share/fonts/feather
    fc-cache -f -v &>/dev/null
fi

# install menlo font if absent
if ! fc-list | grep menlo; then
    sudo mkdir -p /usr/share/fonts/menlo
    rm -rf /tmp/featherfont
    git clone https://github.com/hbin/top-programming-fonts.git /tmp/menlo
    sudo mv /tmp/menlo/Menlo-Regular.ttf /usr/share/fonts/menlo
    fc-cache -f -v &>/dev/null
fi

# install papirus icons if absent
if ! ls /usr/share/icons | grep Papirus; then
   wget -qO- https://git.io/papirus-icon-theme-install | sh
fi

# install phinger-cursor if absent
if ! ls /usr/share/icons | grep phinger-cursors; then
    wget -cO- https://github.com/phisch/phinger-cursors/releases/latest/download/phinger-cursors-variants.tar.bz2 | sudo tar -xjf - -C /usr/share/icons/
fi

# install equilix theme if absent
if ! ls /usr/share/themes | grep Equilux; then
    sudo rm -rf /tmp/equilux*
    wget -cO- https://github.com/ddnexus/equilux-theme/archive/refs/tags/equilux-v20181029.tar.gz | sudo tar -xzf - -C /tmp/
    cd /tmp/equilux*
    sudo bash install.sh
fi

# set gtk theme settings
mkdir -p $XDG_CONFIG_HOME/gtk-3.0
tee $XDG_CONFIG_HOME/gtk-3.0/settings.ini >/dev/null <<EOF
[Settings]
gtk-theme-name=Equilix-compact
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Sans 10
gtk-cursor-theme-name=phinger-cursors
gtk-cursor-theme-size=0
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
EOF

# set default wallpaper
if ! [ -z "$TOKEN" ]; then
    wget -q https://i.imgur.com/NEO3Shg.jpg -O $MEDIA/pictures/wallpapers/currentwallpaper.jpg
fi

# change battery start charge threshold
sudo sed -i 's/#START_CHARGE_THRESH_BAT0=[0-9]*/START_CHARGE_THRESH_BAT0=45/' /etc/tlp.conf

# change battery stop charge threshold
sudo sed -i 's/#STOP_CHARGE_THRESH_BAT0=[0-9]*/STOP_CHARGE_THRESH_BAT0=50/' /etc/tlp.conf

# apply new tlp configuration
sudo systemctl enable tlp.service
sudo tlp start

# enable pipewire service
systemctl --user --now enable wireplumber.service

# fix touchpad config
sudo tee /etc/X11/xorg.conf.d/touchpad-tap.conf >/dev/null <<EOF
Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
        Option "Tapping" "on"
        Option "TappingButtonMap" "lrm"
        Option "NaturalScrolling" "off"
        Option "ScrollMethod" "twofinger"
EndSection
EOF

# remove grub timeout
sudo sed -i 's/GRUB_TIMEOUT=[0-9]*/GRUB_TIMEOUT=0/' /etc/default/grub
sudo update-grub

# always restart after an update
sudo sed -i "s/#\$nrconf{restart} = 'i';/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf

# remove ~/.sudo_as_admin_successful from being created
sudo tee /etc/sudoers.d/disable_admin_file_in_home >/dev/null <<EOF
Defaults !admin_flag
EOF
