#!/bin/zsh

# Comments next to commands
setopt INTERACTIVECOMMENTS

# Make sure that .profile has been loaded, even if there was no "login shell"
# in our lineage.
if [ -n "$_PROFILE_LOADED" ]; then
    source ~/.profile
fi

source ~/.zsh/rc.d/prompt
source ~/.zsh/rc.d/editor
source ~/.zsh/rc.d/dir
source ~/.zsh/rc.d/completion
source ~/.zsh/rc.d/highlighting
source ~/.zsh/rc.d/history
source ~/.zsh/rc.d/fzf
source ~/.aliases

if [[ -f "$HOME/.zsh/rc.d/local" ]]; then
    source "$HOME/.zsh/rc.d/local"
fi
