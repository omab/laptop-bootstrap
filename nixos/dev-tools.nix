# vim: set ft=conf:

{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "overlay2";

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "omab" ];

  environment.systemPackages = with pkgs; [
      wget
      curl
      unp
      unrar
      unzip
      bzip2
      bc

      vagrant

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
      jq
      fd
      # editorconfig-checker
      # editorconfig-core-c
      shellcheck
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
      ansible

      ruby
      pry

      libtool

      # Python build dependencies for pyenv
      # sqlite
      # openssl
      # readline
  ];
}
