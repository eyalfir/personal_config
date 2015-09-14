#! /bin/bash

for file in {.ctags,.vimrc.after,.vimrc.before,.janus,.vim,.gitconfig,.bashrc,.byobu/.tmux.conf,.ipython/profile_default/startup,.screenrc}
do
  mv ~/${file} ~/${file}_backup
  ln -s ~/personal_config/${file} ~/${file}
done
mv ~/.vimrc ~/.vimrc_backup
ln -s ~/personal_config/.vim/janus/vim/vimrc ~/.vimrc

