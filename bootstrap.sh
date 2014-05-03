#! /bin/bash

link_dotfiles.sh

git submodule update --init --recursive
# download latest tmux
wget http://downloads.sourceforge.net/project/tmux/tmux/tmux-1.8/tmux-1.8.tar.gz
tar xvf tmux*gz
# install tmux dependencies
sudo apt-get install libevent-dev libncurses-dev pkg-config
