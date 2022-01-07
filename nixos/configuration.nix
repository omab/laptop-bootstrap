# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  ############################################################################
  # Boot & Kernel

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.grub = {
  #   enable = true;
  #   version = 2;
  #   device = "nodev";
  #   efiSupport = true;
  #   enableCryptodisk = true;
  #   canTouchEfiVariables = true;
  # };
  boot.plymouth = {
    enable = true;
    theme = "breeze";
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "mem_sleep_default=deep"
    "usbcore.use_both_schemes=y"
  ];
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/13e13116-58f0-46f2-994b-856a900c5428";
      preLVM = true;
    };
  };
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 1048576;
    "fs.inotify.max_user_instances" = 1024;
    "fs.inotify.max_queued_events" = 32768;
    "vm.max_map_count" = 262144;
  };
  boot.extraModulePackages = [
    config.boot.kernelPackages.v4l2loopback
  ];
  boot.kernelModules = [
    "v4l2loopback"
  ];

  boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1 video_nr=9 card_label=a7III
  '';

  fileSystems."/".options = [
    "noatime"
    "nodiratime"
    "discard"
  ];

  ############################################################################
  # Networking

  networking.hostName = "rigel";
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlo1.useDHCP = false;

  networking.hosts = {
    "127.0.0.1" = [
    ];
  };

  networking.firewall.checkReversePath = "loose";
  networking.wireguard.enable = true;

  networking.firewall.allowedTCPPorts = [
    # 8000
    # 51820
    # 22
    # 80
    # # barrier
    # 24800
    # # docker swarm ports
    # 2377
    # 7946
    # 4789
    # # psql
    # 5432
  ];

  # docker swarm ports
  networking.firewall.allowedUDPPorts = [
    # 51820
    # 2377
    # 7946
    # 4789
  ];

  ############################################################################
  # Nix & Nixpkgs

  nixpkgs.config.allowBroken = true;
  nixpkgs.config.allowUnfree = true;

  ############################################################################
  # Environment

  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    keyMap = "us";
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/Montevideo";

  # Sound
  sound.enable = true;

  # Global environment setup
  environment.pathsToLink = [ "/libexec" ];

  environment.variables = {
    GDK_SCALE = "1";
    # GDK_DPI_SCALE = "0.5";
    GDK_DPI_SCALE = "1";
  };

  fonts = {
    fontconfig.enable = true;
    enableGhostscriptFonts = true;
    fontDir = {
      enable = true;
    };
    fonts = with pkgs; [
      emojione
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      fira
      fira-code
      fira-mono
      font-awesome
      iosevka
      hack-font
      terminus_font
      anonymousPro
      freefont_ttf
      corefonts
      dejavu_fonts
      inconsolata
      ubuntu_font_family
      ttf_bitstream_vera
      starship
      nerdfonts
    ];
  };

  hardware = {
    enableRedistributableFirmware = true;

    cpu.intel.updateMicrocode = true;
    cpu.amd.updateMicrocode = false;

    facetimehd.enable = true;

    bluetooth.enable = true;
    bluetooth.settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };

    opengl.enable = true;
    opengl.driSupport32Bit = true;
    opengl.extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      libvdpau-va-gl
      vaapiVdpau
    ];
    opengl.extraPackages32 = with pkgs.pkgsi686Linux; [
       vaapiIntel
       libvdpau-va-gl
       vaapiVdpau
    ];

    pulseaudio.enable = true;
    pulseaudio.package = pkgs.pulseaudioFull;
    pulseaudio.support32Bit = true;
    pulseaudio.daemon.config = {
      flat-volumes = "no";
    };
  };

  ############################################################################
  # Services

  services.openssh.enable = true;
  services.upower.enable = true;
  services.fwupd.enable = true;
  services.mullvad-vpn.enable = false;
  services.pipewire.enable = true;
  services.tlp.enable = true;

  # X11
  services.xserver = {
    enable = true;
    # videoDrivers = [ "displaylink" "modesetting" ];
    videoDrivers = [ "modesetting" ];
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;

    layout = "us";
    # xkbOptions = "eurosign:e";
    libinput = {
      enable = true;
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        i3blocks
      ];
    };
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Bluetooth
  services.blueman.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # services.udev.packages = [ pkgs.gnome3.gnome-settings-daemon ];
  # services.dbus.packages = [ pkgs.gnome3.dconf ];

  # Configure lid changes actions
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "suspend";
    lidSwitchExternalPower = "suspend";
    extraConfig = ''
      HandlePowerKey=suspend
      KillUserProcess=no
      RuntimeDirectorySize=50%
    '';
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/intel_backlight/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/intel_backlight/brightness"
    ACTION=="add", SUBSYSTEM=="thunderbolt", ATTR{authorized}=="0", ATTR{authorized}="1"
    ACTION=="add", SUBSYSTEM=="thunderbolt", ATTRS{iommu_dma_protection}=="1", ATTR{authorized}=="0", ATTR{authorized}="1"
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8153", TEST=="power/control", ATTR{power/control}="on"
  '';

  ############################################################################
  # Programs

  programs.dconf.enable = true;
  programs.zsh.enable = true;
  programs.light.enable = true;
  # programs.adb.enable = true;

  xdg.portal.wlr.enable = true;

  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      swaylock
      swaylock-fancy
      swayidle
      xwayland
      waybar
      mako
      kanshi
      wofi
      i3status-rust
    ];
  };

  ############################################################################
  # Virtualization

  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "overlay2";
  virtualisation.docker.liveRestore = false;
  virtualisation.libvirtd.enable = true;
  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;

  ############################################################################
  # Packages

  environment.systemPackages = with pkgs; [
    wget
    curl
    unp
    unrar
    unzip
    zip
    bzip2
    bc
    whois
    telnet
    apacheHttpd
    netcat
    ipvsadm
    wirelesstools

    virt-manager
    google-cloud-sdk
    heroku

    gcc
    gnumake
    cmake
    binutils
    zlib
    libressl
    libyaml
    postgresql
    autoconf
    automake
    nasm
    mozjpeg

    nixfmt
    vim
    ((emacsPackagesNgGen emacs).emacsWithPackages (epkgs: [
      epkgs.vterm
    ]))
    vscode
    aspell
    aspellDicts.en
    aspellDicts.es
    hunspell
    hunspellDicts.en-us
    hunspellDicts.es-uy
    jq
    fd
    editorconfig-core-c
    shellcheck
    ack
    ripgrep
    silver-searcher

    htop
    iotop
    tmux
    powertop
    wezterm
    foot

    mullvad-vpn

    git
    gitAndTools.gh
    docker-compose
    terraform
    pipenv
    csslint
    multimarkdown
    timetrap
    vagrant

    perl

    (python39.withPackages (pypkgs: [
      pypkgs.ipython
      pypkgs.pip
      pypkgs.setuptools
      pypkgs.jedi
      pypkgs.virtualenv
      pypkgs.requests
      # pypkgs.python-language-server
      # pypkgs.pyls-isort
      # pypkgs.pyls-black
      pypkgs.pyflakes
      pypkgs.isort
      pypkgs.nose
      pypkgs.pytest
      pypkgs.jsbeautifier
      pypkgs.sqlparse
      pypkgs.pygments
    ]))

    nodejs
    yarn

    ruby
    pry

    ncat
    bind
    iperf3

    libtool
    libvterm

    borgbackup
    pciutils
    usbutils
    dmidecode
    lshw
    thunderbolt
    nix-index
    linuxPackages.evdi
    tlp

    cron

    zsh
    starship
    autojump
    sakura
    alacritty
    file
    wf-recorder
    redshift-wlr
    v4l-utils
    libv4l
    linuxPackages.v4l2loopback
    xdg_utils
    pipewire
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
    pavucontrol
    libappindicator
    libappindicator-gtk3
    breeze-icons
    breeze-gtk
    gnome-breeze
    capitaine-cursors
    xorg.xmodmap

    rofi
    dconf
    grim
    slurp
    wl-clipboard

    mpv
    feh
    gimp
    inkscape
    evince
    imagemagick
    optipng
    jpegoptim

    (chromium.override { enableWideVine = true; })
    firefox
    slack
    zoom-us
    skypeforlinux
    barrier

    # cups
    libreoffice
  ];

  ############################################################################
  # User account

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.omab = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Matías Aguirre";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "audio"
      "video"
      "kvm"
      "libvirtd"
      "qemu-libvirtd"
      "vboxusers"
      "disk"
      "messagebus"
      # "vboxusers"
      # "adbusers"
    ];
  };

  nix.allowedUsers = [
    "omab"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}

# vim: set ft=conf:
