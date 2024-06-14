#!/bin/bash

## instalation
sudo apt install ripgrep
sudo apt install git
sudo apt install fd-find
sudo apt install bat

## make alias
ln -s $(which fdfind) ~/.local/bin/fd
ln -s /usr/bin/batcat ~/.local/bin/bat

## install fzf
## https://www.linode.com/docs/guides/how-to-use-fzf/
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
