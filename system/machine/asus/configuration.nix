# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    blacklistedKernelModules = [ "nouveau" "nvidia" ];

    tmpOnTmpfs = true;
    cleanTmpDir = true;

    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  services.xserver.videoDrivers = [ "modesetting" ];
  # services.xserver.useGlamor = true;

  hardware = {
    firmware = with pkgs; [ firmwareLinuxNonfree ];
    cpu.intel.updateMicrocode = true;

    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    # nvidia = {
    #   package = config.boot.kernelPackages.nvidiaPackages.legacy_390;
    #   modesetting.enable = true;
    #   prime = {
    #     sync.enable = true;
    #   # sync.enable = true;
    #   # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    #   nvidiaBusId = "PCI:1:0:0";
    #   # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    #   intelBusId = "PCI:0:2:0";
    # };
  };


  # powerManagement = {
  #   enable = true;
  #   cpuFreqGovernor = "powersave";
  # };

  services.power-profiles-daemon.enable = false;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_BAT="powersave";
      CPU_SCALING_GOVERNOR_ON_AC="powersave";

      # The following prevents the battery from charging fully to
      # preserve lifetime. Run `tlp fullcharge` to temporarily force
      # full charge.
      # https://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholds
      START_CHARGE_THRESH_BAT0=40;
      STOP_CHARGE_THRESH_BAT0=50;

      # 100 being the maximum, limit the speed of my CPU to reduce
      # heat and increase battery usage:
      CPU_MAX_PERF_ON_AC=75;
      CPU_MAX_PERF_ON_BAT=60;
    };
  };

  # services.upower.enable = true;
}

