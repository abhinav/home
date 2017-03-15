#!/bin/bash

# Make sure that .profile has been loaded, even if there was no "login shell"
# in our lineage.
if [ -z "$_PROFILE_LOADED" ]; then
	source ~/.profile
else
	# Always want arrayutil
	source ~/.profile.d/arrayutil
fi

source ~/.aliases
[ -f /etc/bashrc ] && source /etc/bashrc
