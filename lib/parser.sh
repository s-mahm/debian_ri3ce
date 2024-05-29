#!/bin/sh

VERSION="1.0.0"

global_options() {
    flag  FORCE   -f --force -- "force install"
	flag  NEW     -n --new -- "new setup"
	disp :usage  -h --help
	disp VERSION -v --version
}

parser_definition() {
    setup   REST help:usage -- "Usage: setup [options]... [arguments]..." ''
    msg -- 'Options:'
    global_options

    msg -- '' 'Commands:'
    cmd apps -- "install user applications"
    cmd auth -- "maintain gpg/ssh keys and settings"
    cmd dev  -- "install development languages and toolchains"
    cmd env -- "configure environment for i3wm"
    cmd packages  -- "update required packages to latest"
    cmd purge  -- "remove any unwanted directories"
    cmd xdg -- "ensure xdg directories and github repos exist"
}

# shellcheck disable=SC1083
parser_definition_apps() {
	setup   REST help:usage abbr:true -- \
		"Usage: ${2##*/} apps [options...] [arguments...]"
    disp :usage  -h --help

    msg -- '' 'Commands:'
    commands=""
    newline=$'\n'
    while IFS= read -r line; do
        commands+="cmd $line $newline"
    done < <(function_list_parser apps)
    eval "$commands"
}

# shellcheck disable=SC1083
parser_definition_dev() {
	setup   REST help:usage abbr:true -- \
		"Usage: ${2##*/} dev [options...] [arguments...]"
    disp :usage  -h --help

    msg -- '' 'Commands:'
    commands=""
    newline=$'\n'
    while IFS= read -r line; do
        commands+="cmd $line $newline"
    done < <(function_list_parser dev)
    eval "$commands"
}

# shellcheck disable=SC1083
parser_definition_xdg() {
	setup   REST help:usage abbr:true -- \
		"Usage: ${2##*/} xdg [options...] [arguments...]"
    disp :usage  -h --help

    msg -- '' 'Commands:'
    commands=""
    newline=$'\n'
    while IFS= read -r line; do
        commands+="cmd $line $newline"
    done < <(function_list_parser xdg)
    eval "$commands"
}

eval "$(getoptions parser_definition parse "$0") exit 1"
parse "$@"
eval "set -- $REST"
