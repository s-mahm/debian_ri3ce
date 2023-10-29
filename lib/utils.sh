check_cmd() {
    if [ ! "$(command -v "$1")" ]; then
        app=$1
        redprint "It seems like you don't have ${app}."
        redprint "Please install ${app}."
        exit 1
    fi
}

### Colors ##
ESC=$(printf '\033')
RESET="${ESC}[0m"
BLACK="${ESC}[30m"
RED="${ESC}[31m"
GREEN="${ESC}[32m"
YELLOW="${ESC}[33m"
BLUE="${ESC}[34m"
MAGENTA="${ESC}[35m"
CYAN="${ESC}[36m"
WHITE="${ESC}[37m"
DEFAULT="${ESC}[39m"

### Color Functions ##

success() {
    printf "${GREEN}%s${RESET}\n" "$1"
}

blueprint() {
    printf "${BLUE}%s${RESET}\n" "$1"
}

error() {
    printf "${RED}ERROR: %s${RESET}\n" "$1" 1>&2
    exit 1
}

warn() {
    printf "${YELLOW}WARNING: %s${RESET}\n" "$1"
}

magentaprint() {
    printf "${MAGENTA}%s${RESET}\n" "$1"
}

cyanprint() {
    printf "${CYAN}%s${RESET}\n" "$1"
}
