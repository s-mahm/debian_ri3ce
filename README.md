# debian_ri3ce
## About
This repository was created to streamline setting up a new machine with debian OS and i3wm.

## Usage

``` shell
# List all available CLI options
./setup --help
Usage: setup [options]... [arguments]...

Options:
  -t, --token TOKEN           github token to clone repositories
  -h, --help
      --version
Arguments:
    packages - maintain required packages and updates
    xdg - conform directories to XDG specification
    auth - retrieve .ssh and gpg keys from vault
    dev - setup development environment
    email - download tutanota email appimage
    env - ricing configuration + sensible fixes for i3wm
    purge - remove all directories to conforming to XDG
```
