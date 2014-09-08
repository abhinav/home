fpath=(/usr/local/share/zsh-completions $fpath)

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
PROMPT="$PROMPT
"'%{$terminfo[bold]$fg[blue]%} $ %{$reset_color%}'
bindkey '^R' history-incremental-search-backward
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
setopt menu_complete
setopt histignoredups

#############################################################################
# Aliases
#############################################################################

alias l=ls
alias ll="ls -l"
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
