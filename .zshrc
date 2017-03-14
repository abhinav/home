#!/bin/zsh

# Make sure that .profile has been loaded, even if there was no "login shell"
# in our lineage.
if [ -n "$_PROFILE_LOADED" ]; then
    source ~/.profile
fi

fpath=(/usr/local/share/zsh/site-functions $fpath)

#############################################################################
# Options
#############################################################################
setopt COMPLETE_IN_WORD
setopt PROMPT_SUBST
setopt HIST_IGNORE_SPACE
setopt extended_glob
setopt histignoredups
setopt interactivecomments
setopt autocd

#############################################################################
# Autoloads
#############################################################################
autoload -U colors
colors

autoload -U bashcompinit
bashcompinit

#############################################################################
# Prompt
#############################################################################
local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %s)"

# Indicate with red <<< on the right when in normal mode.
function zle-key-map-init zle-keymap-select {
    zle reset-prompt
    zle -R
}

zle -N zle-keymap-init
zle -N zle-keymap-select

MODE_INDICATOR="%{$fg_bold[red]%}<<<%{$reset_color%}"
function vi_mode_indicator() {
    echo "${${KEYMAP/vicmd/$MODE_INDICATOR}/(main|viins)/}"
}
RPS1='$(vi_mode_indicator)'

function cabal_sandbox_info() {
    if [ -f cabal.sandbox.config ]; then
        echo "%{$fg[green]%}sandboxed%{$reset_color%}"
    else
        if [ -d .stack-work ]; then
            echo "%{$fg[green]%}stack%{$reset_color%}"
        else
        cabal_files=(*.cabal(N))
            if [ $#cabal_files -gt 0 ]; then
                echo "%{$fg[red]%}not sandboxed%{$reset_color%}"
            fi
        fi
    fi
}

source ~/.zsh/git_prompt.sh

PROMPT='%{$fg_bold[white]%}%M%{$reset_color%} ${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}%~ %{$fg_bold[blue]%}$(git_super_status)%{$reset_color%} $(cabal_sandbox_info)
%{$fg[blue]%} $ %{$reset_color%}'

#############################################################################
# Key bindings
#############################################################################
bindkey -v
bindkey '^R' history-incremental-search-backward
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^K' kill-line
bindkey '\eb' backward-word
bindkey '\ef' forward-word
bindkey '\ed' kill-word

# Bind v in Normal mode to edit the current command in vim.
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

#############################################################################
# Environment variables
#############################################################################
export HISTSIZE=9999
export SAVEHIST=9999
export HISTFILE=~/.zsh_history
export KEYTIMEOUT=1  # no lag when switching to vi normal mode

fzf_search_command='ag -g ""'
if (which rg &> /dev/null); then
    fzf_search_command='rg --files'
fi

export FZF_DEFAULT_OPTS="--cycle"
export FZF_DEFAULT_COMMAND='
  ('"$fzf_search_command"' || git ls-tree -r --name-only HEAD ||
   find . -path "*/\.*" -prune -o -type f -print -o -type l -print |
      sed s/^..//) 2> /dev/null'
if [ -n "$TMUX" ]; then
    export FZF_TMUX=1
fi
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='
  (git ls-tree -d -r --name-only HEAD ||
   find -L . \( -path "*/\.*" -o -fstype dev -o -fstype proc \) -prune -o -type d -print |
      sed 1d | cut -b3-) 2> /dev/null'

#############################################################################
# Completion configuration
#############################################################################

source ~/.zsh/zsh-completions/zsh-completions.plugin.zsh

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _approximate
zstyle ':completion:*' file-sort name
zstyle ':completion:*' ignore-parents parent pwd directory
zstyle ':completion:*:*:-command-:*:*' ignored-patterns '_*'
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle :compinstall filename '/Users/abg/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
#

#############################################################################
# End setup
#############################################################################

. ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#############################################################################
# Source the local zshrc if present
#############################################################################

source ~/.aliases

if [[ -f "$HOME/.zsh/rc.d/local" ]]; then
    source "$HOME/.zsh/rc.d/local"
fi
