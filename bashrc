
##############################################################################
# Aliases
##############################################################################

alias l="ls"
alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias clj="rlwrap --remember -c -b '\(\){}[],^%$#@\"\";:''|\\' -f $HOME/.clj_completions clj"
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

# Activate the hsenv in the current directory.
function activate_hsenv {
    source .hsenv*/bin/activate 2> /dev/null
    if [[ $? -ne 0 ]]; then
        echo "Not an hsenv project directory."
    fi
}

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

export PS1='\e[35;40m\u\e[37;40m \e[32;40m\w\e[37;40m\n● '
export CLICOLOR=1
export NODE_PATH="/usr/local/lib/node_modules:$NODE_PATH"
export PIP_DOWNLOAD_CACHE="$HOME/.pip_download_cache"
export EDITOR="vim"
export HOMEBREW_EDITOR="vim"
export VIRTUALENV_DISTRIBUTE=1
export PATH="\
$HOME/.bin:\
$HOME/.cabal/bin:\
/usr/local/share/python:\
/usr/local/bin:\
/usr/local/sbin:\
/usr/local/share/npm/bin:\
$PATH"

##############################################################################
# Scripts
##############################################################################

scripts=(
    /usr/local/etc/bash_completion
    /usr/local/share/python/virtualenvwrapper_lazy.sh
)

for script in ${scripts[@]}; do
  [[ -f "$script" ]] && . "$script"
done

