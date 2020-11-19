# vim: set ft=conf:

{ config, pkgs, ... }:

{
  boot.plymouth = {
    enable = true;
    theme = "breeze";
  };

  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
  };

  environment.systemPackages = with pkgs; [
      cron

      zsh
      starship
      autojump
      rxvt_unicode
      roxterm
      sakura
      aminal
      file
      wf-recorder
      redshift-wlr
      v4l-utils
      linuxPackages_5_9.v4l2loopback
      xdg_utils
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
      home-manager

      ly
      rofi
      dconf
      grim
      wl-clipboard

      mpv
      feh
      gimp
      evince
      imagemagick

      google-chrome
      firefox
      slack
      zoom-us

      libreoffice
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

  services.xserver = {
    layout = "us";
    enable = true;
  };

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;

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
  #       xorg.xmodmap
  #    ];
  #   };
  # };
}
