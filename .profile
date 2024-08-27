#!/bin/bash
# shellcheck disable=1090

source ~/.profile.d/hostname
source ~/.profile.d/locale
source ~/.profile.d/arrayutil
source ~/.profile.d/pathutil
source ~/.profile.d/home_path
source ~/.profile.d/xdg
source ~/.profile.d/sbin_path
source ~/.profile.d/homebrew
source ~/.profile.d/term
source ~/.profile.d/pager
source ~/.profile.d/editor
source ~/.profile.d/man
source ~/.profile.d/dircolors
source ~/.profile.d/ripgrep

source ~/.profile.d/github

source ~/.profile.d/python
source ~/.profile.d/golang
source ~/.profile.d/rust
source ~/.profile.d/haskell
source ~/.profile.d/zig

# - Each shell profile (e.g., .bash_profile) sources .profile
# - Each shell rc (e.g., .bashrc) sources .profile if _PROFILE_LOADED is not
#   set
_PROFILE_LOADED=$(date +%s)
export _PROFILE_LOADED
