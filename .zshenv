#!/bin/zsh

# Comments next to commands
setopt INTERACTIVECOMMENTS

# Enable bash-like expansion for things like arrayutil.
setopt SH_WORD_SPLIT

export GOPATH="$HOME/dev/go"

export PATH="\
$HOME/.bin:\
$HOME/bin:\
$GOPATH/bin:\
$HOME/.cabal/bin:\
$HOME/.cargo/bin:\
$HOME/.local/bin:\
/usr/local/bin:\
/usr/local/sbin:\
/usr/local/share/npm/bin:\
$PATH:\
/usr/local/opt/go/libexec/bin"
