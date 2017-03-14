#!/bin/bash

source ~/.profile.d/hostname
source ~/.profile.d/locale
source ~/.profile.d/pager
source ~/.profile.d/editor
source ~/.profile.d/term
source ~/.profile.d/dircolors

source ~/.profile.d/fasd
source ~/.profile.d/github
source ~/.profile.d/homebrew

# - Each shell profile (e.g., .bash_profile) sources .profile
# - Each shell rc (e.g., .bashrc) sources .profile if _PROFILE_LOADED is not
#   set
_PROFILE_LOADED=$(date +%s)
export _PROFILE_LOADED
