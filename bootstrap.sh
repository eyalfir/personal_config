#! /bin/bash
git submodule update --init --recursive

ln -s ~/personal_config/.vimrc.after ~/.vimrc.after
ln -s ~/personal_config/.vimrc.before ~/.vimrc.before
ln -s ~/personal_config/.janus ~/.janus
ln -s ~/personal_config/.vim ~/.vim
ln -s ~/personal_config/.gitconfig ~/.gitconfig
ln -s ~/personal_config/.bashrc ~/.bashrc
ln -s ~/personal_config/.byobu/ ~/.byobu
