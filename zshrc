fpath=(/usr/local/share/zsh-completions $fpath)

#############################################################################
# oh-my-zsh
#############################################################################
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
COMPLETION_WAITING_DOTS="true"
DISABLE_AUTO_UPDATE="true"
plugins=(cabal git vi-mode zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

scripts=(
    /usr/local/bin/virtualenvwrapper_lazy.sh
)
for script in "${scripts[@]}"; do
    [[ -f "$script" ]] && . "$script"
done

#############################################################################
# zsh configuration
#############################################################################
PROMPT="$PROMPT\$(cabal_sandbox_info)
"'%{$terminfo[bold]$fg[blue]%} $ %{$reset_color%}'

bindkey '^R' history-incremental-search-backward
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^K' kill-line
bindkey '\eb' backward-word
bindkey '\ef' forward-word
bindkey '\ed' kill-word

setopt COMPLETE_IN_WORD
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

#############################################################################
# Completion configuration
#############################################################################

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' file-sort name
zstyle ':completion:*' ignore-parents parent pwd directory
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]} r:|[._-]=** r:|=**' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'l:|=* r:|=*'
zstyle ':completion:*:*:-command-:*:*' ignored-patterns '_*'       
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/abg/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
#
