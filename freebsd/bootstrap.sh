#!/usr/bin/env bash

set -x

PKG="sudo pkg"
PKG_INSTALL="$PKG install -y"

# install bash
# configure sudo
# omab ALL=(ALL) NOPASSWD:ALL

# update packages
# $PKG update
# $PKG upgrade

# restore backup
# mkdir /tmp/backups
# borg mount /media/backups /tmp/backups
# rsync -av --progress /tmp/backups/<date of last backup>/home/omab /home/omab

$PKG update
$PKG_INSTALL p5-ack arandr aspell en-aspell es-aspell autojump curl emacs \
	     evince-lite feh geeqie git htop i3 i3lock mpv node npm redshift \
	     rxvt-unicode scrot slim vagrant vim zsh the_silver_searcher rofi \
	     dunst tmux imagemagick unzip xclip hack-font font-awesome chromium \
	     ruby rubygem-pry rubygem-rubocop \
	     python27 python36 py27-ipython py36-ipython py27-flake8 \
	     py36-flake8 pylint-py27 pylint-py36

# TODO
# sudo ln -s /usr/bin/nodejs /usr/local/bin/node

# Fetch dotfiles
git clone git@github.com:omab/dotfiles.git .dotfiles
cat .dotfiles/.bin/dotfiles-bootstrap | bash -

# gems / pip / etc packages

sudo npm install -g eslint babel-eslint eslint-plugin-react
