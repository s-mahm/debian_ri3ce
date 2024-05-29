dev_nodejs() {
	sudo apt-get update
	sudo apt-get -y install nodejs
	npm config set prefix "${XDG_DATA_HOME}/npm"
	npm install -g pyright
	npm i -g bash-language-server
	npm i -g yaml-language-server
}

dev_go() {
	export GOROOT=$WORKSTATION/architecture/toolchains/go
	export PATH=$PATH:$GOROOT/bin
	go_latest=$(
		wget --connect-timeout 5 -qO- https://go.dev/dl/ |
			grep -v -E 'go[0-9\.]+(beta|rc)' |
			grep -E -o 'go[0-9\.]+' |
			grep -E -o '[0-9]\.[0-9]+(\.[0-9]+)?' |
			sort -V | uniq |
			tail -1
	)
	go_current=$(go version | grep -Po '\d+\.\d+\.\d+' || true)
	if ! [ $(version $go_current) -ge $(version $go_latest) ]; then
		rm -rf $WORKSTATION/architecture/toolchains/go
		wget https://go.dev/dl/go${go_latest}.linux-amd64.tar.gz -P $WORKSTATION/architecture/toolchains/
		cd $WORKSTATION/architecture/toolchains
		tar -xf go*.tar.gz
		rm go*.tar.gz
	fi
	go install golang.org/x/tools/gopls@latest
}

dev_rust() {
	export CARGO_HOME=$WORKSTATION/architecture/toolchains/rust/.cargo
	export RUSTUP_HOME=$WORKSTATION/architecture/toolchains/rust/.rustup
	export PATH=$PATH:$CARGO_HOME/bin
	if ! rustup --version; then
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
		rustup override set stable
		rustup update stable
	else
		rustup update stable
	fi

}

dev_docker() {
    curl -fsSL https://get.docker.com | bash
    sudo groupadd docker
    sudo usermod -aG docker $USER
}

dev_vagrant() {
	curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
	sudo tee /etc/apt/sources.list.d/vagrant.list >/dev/null <<EOF
	deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main
EOF
	sudo apt-get update
	sudo apt install -y vagrant
}

if [ $# -gt 0 ]; then
	dev_$1 $@
else
	for cmd in $(function_list_parser dev); do
		dev_$cmd
	done
fi
