# vim: set ft=conf:

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./laptop.nix
    ./dev-tools.nix
    ./desktop.nix
  ];

  # Set boot options
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    "mem_sleep_default=deep"
  ];
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;
  };
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/1686d11f-d6c8-4618-a2de-1ce6b34a4695";
      preLVM = true;
    };
  };
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 1048576;
    "fs.inotify.max_user_instances" = 1024;
    "fs.inotify.max_queued_events" = 32768;
    "vm.max_map_count" = 262144;
  };

  # Set networking options
  networking.hostName = "rigel";
  networking.wireless.enable = false;
  # networking.useDHCP = false;  # deprecated
  # networking.interfaces.enp0s20f0u2u4.useDHCP = false;
  # networking.interfaces.wlo1.useDHCP = false;
  networking.networkmanager.enable = true;
  # networking.networkmanager.insertNameservers = [ "208.67.222.222" "208.67.220.220" ];
  # networking.nameservers = [ "208.67.222.222" "208.67.220.220" ];
  networking.hosts = {
    # "127.0.0.1" = [
    # ];
  };
  networking.firewall.allowedTCPPorts = [
    22
    80
  ];

  # Set i18n properties.
  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    keyMap = "us";
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/Montevideo";

  # Allow non-free packages
  nixpkgs.config.allowUnfree = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.upower.enable = true;

  # Global environment setup
  environment.pathsToLink = [ "/libexec" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.omab = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "audio"
      "video"
    ];
  };

  system.stateVersion = "20.03";
}
