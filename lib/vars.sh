# base
EMAIL=soh.mahmood@tutanota.com
if [ -z "$TOKEN" ]; then
    GITURL="git@github.com:"
else
    GITURL="https://smahm006:$TOKEN@github.com/"
fi
GITURL_SSH="git@github.com"

# home related folders
XDG_DATA_HOME="$HOME/.local/share"
XDG_CONFIG_HOME="$HOME/.config"
XDG_CACHE_HOME="$HOME/.cache"
XDG_STATE_HOME="$HOME/.local/state"
WORKSTATION="$HOME/workstation"
OFFICE="$HOME/office"
DUMP="$HOME/dump"
MEDIA="$HOME/media"
APPLICATIONS="$HOME/apps"
