# vim: set ft=conf:

{ config, pkgs, ... }:

{
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
  };

  environment.systemPackages = with pkgs; [
      cron

      zsh
      autojump
      rxvt_unicode
      roxterm
      file

      ly
      rofi
      dconf
      grim

      mpv
      feh
      gimp
      evince
      imagemagick

      google-chrome
      slack
      zoom-us
  ];

  fonts = {
    fontconfig.enable = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      emojione
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      fira
      fira-code
      fira-mono

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
    ];
  };

  sound.enable = true;

  programs.dconf.enable = true;
  programs.zsh.enable = true;
  programs.light.enable = true;
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      xwayland
      waybar
      mako
      kanshi
      i3status-rust
    ];
  };

  # services.xserver.dpi = 96;
  # services.xserver.libinput.enable = true;
  # services.xserver.displayManager.sddm.enable = true;

  # services.xserver = {
  #   layout = "us";
  #   enable = true;
  #   windowManager.i3 = {
  #     enable = true;
  #     extraPackages = with pkgs; [
  #       dmenu
  #       i3status
  #       i3lock
  #       i3blocks
  #    ];
  #   };
  # };
}
