#!/bin/sh

cd "${1:-$(dirname $0)}"

if [ "$SHELL" != "/bin/zsh" ]
then
  chsh -s /bin/zsh
fi

find "$(pwd)/dotfiles" -mindepth 1 -maxdepth 1 -print0 | while read -d $'\0' file
do
  target="$HOME/$(basename $file)"

  if [ -L "$target" ]
  then
    previous="$(readlink "$target")"
    if [ "$file" != "$previous" ]
    then
      echo "$(basename "$file"): Overwriting link previously pointing to $previous".
    fi
    rm "$target"
  fi
  ln -si "$file" "$target"
done
