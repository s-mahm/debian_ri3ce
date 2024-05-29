# install Fontawesome fonts if absent
if ! fc-list | grep Fontawesome; then
	mkdir -p $XDG_DATA_HOME/fonts/Fontawesome
	rm -rf /tmp/fontawesome*
	latest_fontawesome=$(curl -sL \
		https://fontawesome.com/versions |
		grep -Po '\d+\.\d+\.*\d*' |
		head -n1)
	wget "https://use.fontawesome.com/releases/v$latest_fontawesome/fontawesome-free-$latest_fontawesome-desktop.zip" -P /tmp
	unzip -j /tmp/fontawesome-*.zip -d $XDG_DATA_HOME/fonts/Fontawesome
	find $XDG_DATA_HOME/fonts/Fontawesome -type f ! -name '*.otf' -delete
	fc-cache -f -v &>/dev/null
fi

# install Feather fonts if absent
if ! fc-list | grep Feather; then
	mkdir -p $XDG_DATA_HOME/fonts/Feather
	rm -rf /tmp/featherfont*
	git clone https://github.com/AT-UI/feather-font /tmp/featherfont
	sudo mv /tmp/featherfont/src/fonts/feather.ttf $XDG_DATA_HOME/fonts/Feather
	fc-cache -f -v &>/dev/null
fi

# install JetBrainsMono Nerd Font if absent
if ! fc-list | grep JetBrainsMono; then
	sudo mkdir -p $XDG_DATA_HOME/fonts/JetBrainsMono
	rm -rf /tmp/JetBrainsMono*
	wget $(
		curl https://api.github.com/repos/ryanoasis/nerd-fonts/releases/
		latest | grep JetBrainsMono | grep -P download.*\.zip |
			sed 's/"browser_download_url":\s*//' | tr -d '"'
	) -P /tmp
	unzip /tmp/JetBrainsMono.zip -d $XDG_DATA_HOME/fonts/JetBrainsMono
	fc-cache -f -v &>/dev/null
fi

# install Hack Nerd Font if absent
if ! fc-list | grep Hack; then
	mkdir -p $XDG_DATA_HOME/fonts/Hack
	rm -rf /tmp/Hack*
	wget $(
		curl https://api.github.com/repos/ryanoasis/nerd-fonts/releases/
		latest | grep Hack | grep -P download.*\.zip |
			sed 's/"browser_download_url":\s*//' | tr -d '"'
	) -P /tmp
	unzip /tmp/Hack.zip -d $XDG_DATA_HOME/fonts/Hack
	fc-cache -f -v &>/dev/null
fi

# install phinger-cursor icons  if absent
if ! ls $XDG_DATA_HOME/icons | grep phinger-cursors; then
	wget -cO- https://github.com/phisch/phinger-cursors/releases/latest/download/phinger-cursors-variants.tar.bz2 | tar -xjf - -C $XDG_DATA_HOME/icons/
fi

# install Tela icons if absent
if ! ls $XDG_DATA_HOME/icons | grep Tela; then
	git clone https://github.com/vinceliuice/Tela-icon-theme.git /tmp/Tela-icon-theme
	bash /tmp/Tela-icon-thme/install.sh -d $XDG_DATA_HOME/icons
fi

# install Jasper icons if absent
if ! ls $XDG_DATA_HOME/themes | grep Jasper; then
	git clone https://github.com/vinceliuice/Jasper-gtk-theme.git /tmp/Jasper-gtk-theme
	bash /tmp/Jasper-gtk-theme/install.sh -d $XDG_DATA_HOME/themes
fi

# set gtk theme settings
mkdir -p $XDG_CONFIG_HOME/gtk-3.0
tee $XDG_CONFIG_HOME/gtk-3.0/settings.ini >/dev/null <<EOF
[Settings]
gtk-theme-name=Jasper-Dark
gtk-icon-theme-name=Tela-dark
gtk-font-name=Sans 10
gtk-cursor-theme-name=phinger-cursors
gtk-cursor-theme-size=0
gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=0
gtk-menu-images=0
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintmedium
EOF

# set default wallpaper
if ! [ -z "$NEW" ]; then
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

# Enable suspend on lid close
sudo sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=suspend/' /etc/systemd/logind.conf
sudo sed -i 's/#HandleLidSwitchExternalPower=suspend/HandleLidSwitchExternalPower=suspend/' /etc/systemd/logind.conf
sudo sed -i 's/#HandleLidSwitchDocked=ignore/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf
sudo sed -i 's/#LidSwitchIgnoreInhibited=yes/LidSwitchIgnoreInhibited=yes/' /etc/systemd/logind.conf

# Add locking before suspend
sudo tee /etc/systemd/system/suspend@root.service >/dev/null <<EOF
[Unit]
etc/systemd/system/suspend@.service

[Unit]
Description=User suspend actions
Before=sleep.target

[Service]
User=smahm
Type=forking
Environment=DISPLAY=:0
ExecStart=-/usr/local/cbins/blurlock
ExecStartPost=/usr/bin/sleep 1

[Install]
WantedBy=sleep.target
EOF

sudo systemctl enable suspend@root.service
