# create workstation folders
mkdir -p $WORKSTATION
mkdir -p $WORKSTATION/projects
mkdir -p $WORKSTATION/projects/personal
mkdir -p $WORKSTATION/projects/work
mkdir -p $WORKSTATION/projects/sandbox
mkdir -p $WORKSTATION/resources
mkdir -p $WORKSTATION/architecture
mkdir -p $WORKSTATION/architecture/toolchains
mkdir -p $WORKSTATION/architecture/virtualmachines
mkdir -p $WORKSTATION/architecture/virtualmachines/vagrant
mkdir -p $WORKSTATION/architecture/virtualmachines/virtualbox

# create dump (downloads) folder
mkdir -p $DUMP

# create media folders
mkdir -p $MEDIA
mkdir -p $MEDIA/audio
mkdir -p $MEDIA/pictures
mkdir -p $MEDIA/pictures/wallpapers
mkdir -p $MEDIA/pictures/screenshots
mkdir -p $MEDIA/pictures/misc
mkdir -p $MEDIA/videos

# create office folders
mkdir -p $OFFICE
mkdir -p $OFFICE/documents
mkdir -p $OFFICE/misc
mkdir -p $OFFICE/books
mkdir -p $OFFICE/backup
mkdir -p $OFFICE/proffesional

# create apps folders
mkdir -p $APPLICATIONS

# set user-dirs
tee $XDG_CONFIG_HOME/user-dirs.dirs >/dev/null <<EOF
XDG_DESKTOP_DIR="$HOME"
XDG_DOWNLOAD_DIR="$HOME/dump"
XDG_TEMPLATES_DIR="$HOME"
XDG_PUBLICSHARE_DIR="$HOME"
XDG_DOCUMENTS_DIR="$OFFICE"
XDG_MUSIC_DIR="$MEDIA/audio"
XDG_PICTURES_DIR="$MEDIA/pictures"
XDG_VIDEOS_DIR="$MEDIA/videos"
EOF
xdg-user-dirs-update
