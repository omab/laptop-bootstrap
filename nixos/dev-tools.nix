# vim: set ft=conf:

{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "overlay2";
  virtualisation.docker.liveRestore = false;
  virtualisation.libvirtd.enable = true;

  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  # users.extraGroups.vboxusers.members = [ "omab" ];

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
      apacheHttpd
      netcat
      ipvsadm

      virt-manager
      vagrant
      google-cloud-sdk
      heroku

      gcc
      gnumake
      cmake
      binutils
      zlib
      libressl
      libyaml

      nixfmt
      vim
      emacs
      # emacsPackages.vterm
      aspell
      aspellDicts.en
      aspellDicts.es
      jq
      fd
      # editorconfig-checker
      editorconfig-core-c
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
      pipenv
      csslint
      multimarkdown

      perl

      # python-language-server

      python27
      python27Packages.ipython
      python27Packages.pip
      python27Packages.setuptools
      # python27Packages.jedi
      python27Packages.virtualenv
      python27Packages.requests
      # python27Packages.pyls-isort
      # python27Packages.pyflakes
      python27Packages.isort
      python27Packages.nose
      python27Packages.pytest
      python27Packages.jsbeautifier

      python37
      python37Packages.ipython
      python37Packages.pip
      python37Packages.setuptools
      python37Packages.jedi
      python37Packages.virtualenv
      python37Packages.requests
      python37Packages.python-language-server
      python37Packages.pyls-isort
      python37Packages.pyls-black
      python37Packages.pyflakes
      python37Packages.isort
      python37Packages.nose
      python37Packages.pytest
      python37Packages.jsbeautifier

      python38
      python38Packages.ipython
      python38Packages.pip
      python38Packages.setuptools
      python38Packages.jedi
      python38Packages.virtualenv
      python38Packages.requests
      python38Packages.python-language-server
      python38Packages.pyls-isort
      python38Packages.pyls-black
      python38Packages.pyflakes
      python38Packages.isort
      python38Packages.nose
      python38Packages.pytest
      python38Packages.jsbeautifier

      nodejs
      yarn

      ruby
      pry

      ncat
      bind

      libtool
      # libvterm

      # Python build dependencies for pyenv
      # sqlite
      # openssl
      # readline
  ];
}
