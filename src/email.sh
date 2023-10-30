# install latest tutanota email client
wget https://mail.tutanota.com/desktop/tutanota-desktop-linux.AppImage -P $HOME/apps
sudo chmod +x $HOME/apps/tutanota-desktop-linux.AppImage
sudo ln -sf $HOME/apps/tutanota-desktop-linux.AppImage /usr/local/bin/tutanota

# create destkop entry
sudo wget https://aegis-icons.github.io/icons/primary/Tutanota.svg -O /usr/share/pixmaps/Tutanota.svg
sudo tee /tmp/tutanota.desktop >/dev/null <<EOF
[Desktop Entry]
Type=Application
TryExec=tutanota
Exec="tutanota" %U
Icon=Tutanota
Terminal=false
Categories=Network;Email;

Name=Tutanota
GenericName=Mail Client
Comment=The desktop client for Tutanota, the secure e-mail service.
StartupNotify=true
StartupWMClass=tutanota-desktop
MimeType=x-scheme-handler/mailto;
Actions=New;

[Desktop Action New]
Name=New Tutanota Instance
Exec=tutanota
EOF
sudo desktop-file-install /tmp/tutanota.desktop
