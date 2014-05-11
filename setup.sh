#!/bin/sh

cd ${1:-$(dirname $0)}

if [ "$SHELL" != "/bin/zsh" ]
then
  chsh -s /bin/zsh
fi

for file in $(find $(pwd)/dotfiles -maxdepth 1 -type f)
do
  target=$HOME/$(basename $file)

  if [ -e "$target" ]
  then
    diff -q "$target" "$file" > /dev/null
    if [ $? -ne 0 ]
    then
      if [ -L "$target" ]
      then
        echo $(basename $file): overwriting link even though contents differ.
      else
        echo $(basename $file): skipping because of diffs.
        continue
      fi
    fi
  fi
  rm -f $target
  ln -s $file $target
done
