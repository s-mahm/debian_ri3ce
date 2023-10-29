#!/bin/sh

VERSION="1.0.0"

# shellcheck disable=SC1083
parser_definition() {
  setup   REST help:usage -- "Usage: setup [options]... [arguments]..." ''
  msg -- 'Options:'
  flag    FLAG    -f --flag                  -- "takes no arguments"
  flag    CLEAN   -c --clean                 -- "clean up file prior to execution"
  param   TOKEN   -t --token                 -- "takes one argument"
  param   PARAM   -p --param                 -- "takes one argument"
  option  OPTION  -o --option  on:"default"  -- "takes one optional argument"
  disp    :usage  -h --help
  disp    VERSION    --version
}

eval "$(getoptions parser_definition parse "$0") exit 1"
parse "$@"
eval "set -- $REST"

# Required parameters
# if [ -z "$TOKEN" ] || [ -z "$TOKEN" ]; then
#         error 'Required parameter -t token missing'
# fi
