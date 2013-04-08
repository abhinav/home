
##############################################################################
# Aliases
##############################################################################

alias l="ls"
alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias clj="rlwrap --remember -c -b '\(\){}[],^%$#@\"\";:''|\\' -f $HOME/.clj_completions clj"

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

