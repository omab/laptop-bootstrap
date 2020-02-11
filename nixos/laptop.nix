# vim: set ft=conf:

{ config, pkgs, ... }:

{
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
}
