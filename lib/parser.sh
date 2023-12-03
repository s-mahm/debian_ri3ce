#!/bin/sh

VERSION="1.0.0"

global_options() {
    flag  FORCE   -f --force -- "force install applicatons"
    param TOKEN   -t --token -- "github token to clone repositories"
	disp :usage  -h --help
	disp VERSION    --version
}

parser_definition() {
    setup   REST help:usage -- "Usage: setup [options]... [arguments]..." ''
    msg -- 'Options:'
    global_options

    msg -- '' 'Commands:'
    cmd dev  -- "install different development"
    cmd apps -- "install different applications"
}

# shellcheck disable=SC1083
parser_definition_apps() {
    setup   REST help:usage -- "Usage: apps [options]... [arguments]..." ''
    disp :usage  -h --help

    msg -- '' 'Commands:'
    cmd emacs  -- "install emacs editor"
    cmd alacritty -- "install alacritty terminal"
}

eval "$(getoptions parser_definition parse "$0") exit 1"
parse "$@"
eval "set -- $REST"

# Token required if first time setup
if ! git ls-remote git@github.com:s-mahm/debian_ri3ce.git &>/dev/null &&
        [ $# -eq 0 ] && \
        [ -z "$TOKEN" ]; then
    error 'Required parameter token (-t) missing'
fi
