#############################################################################
# oh-my-zsh
#############################################################################
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
COMPLETION_WAITING_DOTS="true"
plugins=(git vi-mode zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

#############################################################################
# zsh configuration
#############################################################################
fpath=(/usr/local/share/zsh-completions $fpath)

bindkey '^R' history-incremental-search-backward

setopt menu_complete
autoload -Uz compinit
compinit

#############################################################################
# Aliases
#############################################################################

alias l=ls
alias serve_this="python -mSimpleHTTPServer"

#############################################################################
# General environment variables
#############################################################################
export LANG=en_US.UTF-8
export EDITOR=vim
export TERM=xterm-256color
export HISTSIZE=9999
export SAVEHIST=9999

export WATCHMAN_CONFIG_FILE="$HOME/.watchman.json"
export PIP_DOWNLOAD_CACHE="$HOME/.pip_download_cache"
export HOMEBREW_EDITOR="vim"

export PATH="\
$HOME/.bin:\
$HOME/.cabal/bin:\
/usr/local/bin:\
/usr/local/sbin:\
/usr/local/share/npm/bin:\
$PATH"
