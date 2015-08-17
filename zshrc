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
setopt histignoredups

# Don't share command history between active sessions.
unsetopt inc_append_history
unsetopt share_history

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

autoload -U bashcompinit
bashcompinit

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _approximate
zstyle ':completion:*' file-sort name
zstyle ':completion:*' ignore-parents parent pwd directory
zstyle ':completion:*:*:-command-:*:*' ignored-patterns '_*'
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle :compinstall filename '/Users/abg/.dotfiles/zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
#
