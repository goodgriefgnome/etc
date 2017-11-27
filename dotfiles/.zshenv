export EDITOR=emacsclient
export VISUAL=emacsclient
export ALTERNATE_EDITOR=''
export GOPATH="$HOME/gopath"

typeset -U path
path=("$HOME/bin" "$GOPATH/bin" $path)
