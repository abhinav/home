#!/bin/zsh

(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"

# Make sure that .profile has been loaded, even if there was no "login shell"
# in our lineage.
if [ -z "$_PROFILE_LOADED" ]; then
    source ~/.profile
else
    # Always want arrayutil
    source ~/.profile.d/arrayutil
fi


source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme

source ~/.zsh/rc.d/options
source ~/.zsh/rc.d/history
source ~/.zsh/rc.d/editor
source ~/.zsh/rc.d/dir
source ~/.zsh/rc.d/direnv
source ~/.zsh/rc.d/fzf
source ~/.zsh/rc.d/homebrew
source ~/.zsh/rc.d/git-delta
source ~/.zsh/rc.d/completion
source ~/.zsh/rc.d/zoxide
source ~/.zsh/rc.d/fzf-tab
source ~/.zsh/rc.d/highlighting
source ~/.zsh/rc.d/autosuggestions

source ~/.aliases

if [[ -f "$HOME/.zsh/rc.d/local" ]]; then
    source "$HOME/.zsh/rc.d/local"
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
