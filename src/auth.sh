export GNUPGHOME=$XDG_DATA_HOME/gnupg
export PASSWORD_STORE_DIR=$HOME/vault

# setup gpg keys if absent
if ! gpg --list-secret-keys $EMAIL &>/dev/null; then
    # recreate current gpg directory
    rm -rf $XDG_DATA_HOME/gnupg && mkdir -p $XDG_DATA_HOME/gnupg
    # add sensible gpg config
    tee $XDG_DATA_HOME/gnupg/gpg-agent.conf >/dev/null <<EOF
false-allow-external-cache
pinentry-program /bin/pinentry-tty
default-cache-ttl 86400
maximum-cache-ttl 86400
EOF
    # set proper gnupg permissions
    sudo chmod 0600 $XDG_DATA_HOME/gnupg/*
    sudo chmod 0700 $XDG_DATA_HOME/gnupg
    # reload gpg agent with new config
    gpg-connect-agent reloadagent /bye
    # import private gpg key
    gpg --import $HOME/vault/private.asc
    # import public gpg key
    gpg --import $HOME/vault/public.asc
fi

# setup ssh keys if absent
cd $HOME/vault/ssh
for key in *; do
    # private key
    pass ssh/$key/private > $HOME/.ssh/$key.pri
    sudo chmod 0600 $HOME/.ssh/$key.pri
    # public key
    pass ssh/$key/public > $HOME/.ssh/$key.pub
    sudo chmod 0600 $HOME/.ssh/$key.pri
    sudo chmod 0644 $HOME/.ssh/$key.pub
    # store password in keychain
    echo "$(pass ssh/$key/password)" | eval $(keychain --eval --agents ssh $HOME/.ssh/$key.pri)
done
