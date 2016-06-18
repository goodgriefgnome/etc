#!/bin/sh

cd "${1:-$(dirname $0)}"

[[ -e "termdefs" ]] && tic termdefs

if [[ "$SHELL" != "/bin/zsh" ]]
then
  chsh -s /bin/zsh
fi

process_dotfile() {
  target="$HOME/$(basename "$1")"

  if [ -L "$target" ]
  then
    previous="$(readlink "$target")"
    if [ "$1" != "$previous" ]
    then
      echo "$(basename "$1"): Overwriting link previously pointing to $previous".
    fi
    rm "$target"
  fi
  ln -si "$1" "$target"
}
export -f process_dotfile

find "$(pwd)/dotfiles" -mindepth 1 -maxdepth 1 -exec /bin/sh -c 'process_dotfile "$0"' '{}' ';'
