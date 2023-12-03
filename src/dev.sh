export GOROOT=$WORKSTATION/architecture/toolchains/go
export CARGO_HOME=$WORKSTATION/architecture/toolchains/rust/.cargo
export RUSTUP_HOME=$WORKSTATION/architecture/toolchains/rust/.rustup
export PATH=$PATH:$HOME/.local/bin:$GOROOT/bin:$CARGO_HOME/bin

latest_stable_debian=$(curl -sL http://ftp.fi.debian.org/debian/dists/stable/Release | grep Codename: | sed 's/^.*: //')

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

#############
# ALACRITTY #
#############



# clean up lingering packages
sudo apt-get -y autoremove
