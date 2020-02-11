# vim: set ft=conf:

{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "overlay2";

  environment.systemPackages = with pkgs; [
      wget
      curl
      unp
      unrar
      unzip
      bzip2

      gcc
      gnumake
      cmake
      binutils
      zlib

      vim
      emacs
      aspell
      aspellDicts.en
      aspellDicts.es
      ack
      ripgrep
      silver-searcher

      htop
      tmux

      git
      docker-compose

      python27
      python27Packages.ipython
      python38
      python38Packages.ipython

      # Python build dependencies for pyenv
      # sqlite
      # openssl
      # readline
  ];
}
