#! /bin/bash


git submodule update --init --recursive

for file in {.vimrc.after,.vimrc.before,.janus,.vim,.gitconfig,.bashrc,.byobu,.ipython/profile_default}
do
  mv ~/${file} ~/${file}_backup
  ln -s ~/personal_config/${file} ~/${file}
done
ln -s ~/personal_config/.vim/janus/vim/vimrc ~/.vimrc

# download latest tmux
wget http://downloads.sourceforge.net/project/tmux/tmux/tmux-1.8/tmux-1.8.tar.gz
tar xvf tmux*gz
# install tmux dependencies
sudo apt-get install libevent-dev libncurses-dev pkg-config
