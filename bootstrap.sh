#! /bin/bash
git submodule update --init --recursive

for file in {.vimrc.after,.vimrc.before,.janus,.vim,.gitconfig,.bashrc,.byobu}
do
  mv ~/${file} ~/${file}_backup
  ln -s ~/personal_config/${file} ~/${file}
done
