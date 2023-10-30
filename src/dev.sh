export GOROOT=$WORKSTATION/architecture/toolchains/go
export CARGO_HOME=$WORKSTATION/architecture/toolchains/rust/.cargo
export RUSTUP_HOME=$WORKSTATION/architecture/toolchains/rust/.rustup
export PATH=$PATH:$HOME/.local/bin:$GOROOT/bin:$CARGO_HOME/bin

latest_stable_debian=$(curl -sL http://ftp.fi.debian.org/debian/dists/stable/Release | grep Codename: | sed 's/^.*: //')

function version {
    echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }';
}

##########
# PYTHON #
##########

# setup default virtualenv
python3 -m venv $WORKSTATION/architecture/.pyvenv_default
source $WORKSTATION/architecture/.pyvenv_default/bin/activate
pip install --upgrade pip
pip install black flake8 pyright

##########
# NODEJS #
##########

# set up nodesource apt repository
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=$(wget -qO-  https://deb.nodesource.com | grep -Po "NODE_MAJOR=\d+" | sed 's/^.*=//')
sudo tee /etc/apt/sources.list.d/docker.list >/dev/null <<EOF
deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main
EOF
sudo apt-get update

# install nodejs
sudo apt-get -y install nodejs

##########
# GOLANG #
##########

# find latest go version
go_latest=$(
wget --connect-timeout 5 -qO- https://go.dev/dl/ \
     | grep -v -E 'go[0-9\.]+(beta|rc)' \
     | grep -E -o 'go[0-9\.]+' \
     | grep -E -o '[0-9]\.[0-9]+(\.[0-9]+)?' \
     | sort -V | uniq \
     | tail -1
         )

# find current go version
go_current=$(go version | grep -Po '\d+\.\d+\.\d+' || true)

# install latest go if not latest
if ! [ $(version $go_current) -ge $(version $go_latest) ]; then
    rm -rf $WORKSTATION/architecture/toolchains/go
    wget https://go.dev/dl/go${go_latest}.linux-amd64.tar.gz -P $WORKSTATION/architecture/toolchains/
    cd $WORKSTATION/architecture/toolchains
    tar -xf go*.tar.gz
    rm go*.tar.gz
fi

# install go language server
go install golang.org/x/tools/gopls@latest

########
# RUST #
########

# update rust or install if absent
if ! rustup --version; then
    # install latest rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

    # setup rustup
    rustup override set stable
    rustup update stable
else
    rustup update stable
fi

####################
# LANGUAGE SERVERS #
####################
npm config set prefix "${XDG_DATA_HOME}/npm"
npm i -g bash-language-server
npm i -g yaml-language-server
npm i -g vls

##########
# DOCKER #
##########

# set up docker's apt repository
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --yes --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo tee /etc/apt/sources.list.d/docker.list >/dev/null <<EOF
deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian  $latest_stable_debian stable
EOF
sudo apt-get update

# install docker
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

###########
# VAGRANT #
###########

# set up vagrant apt repository
 curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
sudo tee /etc/apt/sources.list.d/docker.list >/dev/null <<EOF
deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $latest_stable_debian main
EOF
sudo apt-get update

# install vagrant
sudo apt install -y vagrant

# start virtualbox service
if ! sudo systemctl start virtualbox; then
    sudo apt install --reinstall linux-headers-$(uname -r) virtualbox-dkms dkms
fi

#########
# EMACS #
#########

# find latest emacs version
emacs_latest=$(
    wget --connect-timeout=5 -qO- http://ftpmirror.gnu.org/emacs/ \
    | grep -Po "emacs-\\d\\d\.\\d" \
    | tail -1 \
    | sed 's/^emacs-//'
            )
# find current emacs version
emacs_current=$(emacs --version | grep -P "GNU Emacs \d" | grep -Po "\d+\.\d+" || true)

# install emacs if old or absent
if ! [ $(version $emacs_current) -ge $(version $emacs_latest) ]; then
    echo INSTLALLING EMACS
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
fi

#############
# ALACRITTY #
#############

# install alacritty if old or absent
if ! [ $(version $(alacritty --version | grep -Po '\d+\.\d+\.\d+' || true)) -ge $(version "0.13.0") ]; then
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
    scdoc < extra/man/alacritty.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
    scdoc < extra/man/alacritty-msg.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
    scdoc < extra/man/alacritty.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz > /dev/null
    scdoc < extra/man/alacritty-bindings.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz > /dev/null

    # shell completions
    mv extra/completions/alacritty.bash ~/.dotfiles/bash/.local/state/bash/bash_completions/alacritty
fi

# clean up lingering packages
sudo apt-get -y autoremove
