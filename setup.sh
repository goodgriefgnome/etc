#!/bin/sh

cd ${1:-$(dirname $0)}

if [ "$SHELL" != "/bin/zsh" ]
then
  chsh -s /bin/zsh
fi

for file in $(find $(pwd)/dotfiles -mindepth 1 -maxdepth 1)
do
  target=$HOME/$(basename $file)

  if [ -e "$target" ]
  then
    if [ -L "$target" ]
    then
      previous=$(readlink "$target")
      if [ "$file" != "$previous" ]
      then
        echo $(basename $file): Overwriting link previously pointing to $(readlink "$target").
      fi
    else
      echo $(basename $file): Skipping because target is a real file.
      continue
    fi
  fi
  ln -sf $file $target
done
