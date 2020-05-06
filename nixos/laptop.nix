# vim: set ft=conf:

{ config, pkgs, ... }:

{
  services.fwupd.enable = true;

  environment.systemPackages = with pkgs; [
    borgbackup
    pciutils
    usbutils

    nix-index
  ];

  hardware = {
    enableRedistributableFirmware = true;

    cpu.intel.updateMicrocode = true;
    cpu.amd.updateMicrocode = false;

    bluetooth.enable = false;
    facetimehd.enable = true;

    opengl.enable = true;
    opengl.driSupport32Bit = true;
    opengl.extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau ];
    opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ vaapiIntel libvdpau-va-gl vaapiVdpau ];

    pulseaudio.package = pkgs.pulseaudioFull;
    pulseaudio.enable = true;
    pulseaudio.support32Bit = true;
    pulseaudio.daemon.config = {
      flat-volumes = "no";
    };
  };

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
  '';
}
