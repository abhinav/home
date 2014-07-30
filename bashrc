
##############################################################################
# Aliases
##############################################################################

alias l="ls"
alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias serve_this='python -mSimpleHTTPServer'

##############################################################################
# Bookmark system
##############################################################################

MARKS="$HOME/.marks"

function mark {
    [ -n "$1" ] && mkdir -p "$MARKS" && ln -s "$(pwd)" "$MARKS/$1" \
                && echo "Bookmarked."
}

function unmark {
    [ -n "$1" ] && [ -d "$MARKS/$1" ] && rm "$MARKS/$1" \
                && echo "Deleted bookmark."
}

function marks {
    [ -d "$MARKS" ] && ls -l "$MARKS" \
        | tail -n+2 | sed 's/  / /g' | cut -d' ' -f10-
}

function cm {
    [ -n "$1" ] && [ -d "$MARKS/$1" ] && cd -P "$MARKS/$1"
}

##############################################################################
# Functions
##############################################################################

# Execute an mr command on each directory in the current folder that contains
# an mrconfig.
function mr-each {
    for D in *; do
        if [ -f "$D/.mrconfig" ]; then
            pushd "$D" >/dev/null
            mr $@
            popd >/dev/null
        fi
    done
}

##############################################################################
# Environment variables
##############################################################################

export WATCHMAN_CONFIG_FILE="$HOME/.watchman.json"
export PS1='\e[35;40m\u\e[37;40m \e[32;40m\w\e[37;40m\n● '
export CLICOLOR=1
export NODE_PATH="/usr/local/lib/node_modules:$NODE_PATH"
export PIP_DOWNLOAD_CACHE="$HOME/.pip_download_cache"
export EDITOR="vim"
export HOMEBREW_EDITOR="vim"
export VIRTUALENV_DISTRIBUTE=1
export GHC_DOT_APP="$HOME/Applications/ghc-7.8.3.app"
export PATH="\
$HOME/.bin:\
$HOME/.cabal/bin:\
$GHC_DOT_APP/Contents/bin:\
/usr/local/bin:\
/usr/local/sbin:\
/usr/local/share/npm/bin:\
$PATH"

##############################################################################
# Scripts
##############################################################################

scripts=(
    /usr/local/etc/bash_completion
)

for script in ${scripts[@]}; do
  [[ -f "$script" ]] && . "$script"
done

