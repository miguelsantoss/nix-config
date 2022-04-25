{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.gnome3.adwaita-icon-theme ];

  programs.gnupg.agent.pinentryFlavor = "gnome3";

  programs.dconf.enable = true;
  programs.xwayland.enable = true;

  # Enable the X11 windowing system.
  services = {
    gnome.gnome-keyring.enable = true;
    upower.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    # Gnome3 config
    udev.packages = [ pkgs.gnome3.gnome-settings-daemon ];

    # GUI interface
    xserver = {
      enable = true;

      # Configure keymap in X11
      layout = "pt";
      xkbOptions = "eurosign:e, ctrl:nocaps";

      # Enable touchpad support.
      libinput.enable = true;

      # Enable the Gnome3 desktop manager
      # displayManager.sddm.enable    = true;
      # desktopManager.plasma5.enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      desktopManager.gnome.enable = true;
      # desktopManager.xfce.enable = true;
    };

    # redshift.enable = true;
  };
}
