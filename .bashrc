#!/bin/bash

# Make sure that .profile has been loaded, even if there was no "login shell"
# in our lineage.
if [ -n "$_PROFILE_LOADED" ]; then
    source ~/.profile
fi

source ~/.aliases
[ -f /etc/bashrc ] && source /etc/bashrc
