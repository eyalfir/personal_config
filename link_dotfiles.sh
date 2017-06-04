#! /bin/bash

for file in {.tmux,.ctags,.vimrc.after,.vimrc.before,.gitconfig,.bashrc,.tmux.conf,.ipython/profile_default/startup,.screenrc,.config/powerline}
do
  mkdir -p ~/$(dirname $file)
  mv ~/${file} ~/${file}_backup
  ln -s ~/personal_config/${file} ~/${file}
done
