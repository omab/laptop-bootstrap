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
      whois
      telnet

      vagrant
      google-cloud-sdk

      gcc
      gnumake
      cmake
      binutils
      zlib
      libressl

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
      iotop
      tmux

      git
      docker-compose
      terraform

      python27
      python27Packages.ipython
      python27Packages.pip
      python27Packages.setuptools
      python38
      python38Packages.ipython
      python38Packages.pip
      python38Packages.setuptools
      ansible

      ruby
      pry

      ncat
      bind

      libtool

      # Python build dependencies for pyenv
      # sqlite
      # openssl
      # readline
  ];
}
