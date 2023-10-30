#!/bin/sh

VERSION="1.0.0"

# shellcheck disable=SC1083
parser_definition() {
  setup   REST help:usage -- "Usage: setup [options]... [arguments]..." ''
  msg -- 'Options:'
  param   TOKEN   -t --token                 -- "github token to clone repositories"
  disp    :usage  -h --help
  disp    VERSION    --version
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
