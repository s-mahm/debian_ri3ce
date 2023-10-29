# set XDG global environment_variables
sudo tee /etc/profile.d/xdg.sh >/dev/null <<EOF
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_DIRS="/etc/xdg"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Setting \$XDG_RUNTIME_DIR
if test -z "\${XDG_RUNTIME_DIR}"; then
     export XDG_RUNTIME_DIR=/tmp/\${UID}-runtime-dir
     if ! test -d "\${XDG_RUNTIME_DIR}"; then
         mkdir "\${XDG_RUNTIME_DIR}"
         chmod 0700 "\${XDG_RUNTIME_DIR}"
     fi
 fi
EOF
sudo chmod 0644  /etc/profile.d/xdg.sh

# create xdg directories
mkdir -p $XDG_DATA_HOME
mkdir -p $XDG_DATA_HOME/gnupg
mkdir -p $XDG_DATA_HOME/python
mkdir -p $XDG_DATA_HOME/wine
mkdir -p $XDG_DATA_HOME/terminfo
mkdir -p $XDG_CONFIG_HOME
mkdir -p $XDG_CONFIG_HOME/X11
mkdir -p $XDG_CONFIG_HOME/wgetrc
mkdir -p $XDG_CONFIG_HOME/git
mkdir -p $XDG_CONFIG_HOME/gtk-2.0
mkdir -p $XDG_CONFIG_HOME/aws
mkdir -p $XDG_CACHE_HOME
mkdir -p $XDG_CACHE_HOME/X11
mkdir -p $XDG_CACHE_HOME/python
mkdir -p $XDG_STATE_HOME
mkdir -p $XDG_STATE_HOME/bash
mkdir -p $XDG_STATE_HOME/less
