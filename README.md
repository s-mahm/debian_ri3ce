# debian_ri3ce
## About
This repository was created to streamline setting up a new machine with debian OS and i3wm.

## Usage

``` text
./setup --help
Usage: setup [options]... [arguments]...

Options:
  -f, --force                 force install
  -t, --token TOKEN           github token to clone repositories
  -h, --help
  -v, --version

Commands:
  apps      install user applications
  auth      maintain gpg/ssh keys and settings
  dev       install development languages and toolchains
  env       configure environment for i3wm
  packages  update required packages to latest
  puge      remove any unwanted directories
  xdg       ensure xdg directories and github repos exist
```

### Subcommands
Commands can include sub-commands that are automatically generated from the functions in the script associated with the command found in the "src" directory.

For example the command apps has sub-commands based on the functions in the script "src/apps.sh"
``` text
Usage: setup apps [options...] [arguments...]
  -h, --help

Commands:
  alacritty
  emacs
```
