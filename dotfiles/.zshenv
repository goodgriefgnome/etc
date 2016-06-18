export EDITOR=emacsclient
export VISUAL=emacsclient
export ALTERNATE_EDITOR=''

typeset -U path
[[ -d "$HOME/bin" ]] && path=("$HOME/bin" $path)
