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

    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    hostName = "asus-laptop"; # Define your hostname.
    interfaces.wlp2s0.useDHCP = true;
    firewall.enable = false;
  };


  # Set your time zone.
  time.timeZone = "Europe/Lisbon";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.consoleUseXkbConfig = true;
  console = {
    font = "Lat2-Terminus16";
  };

  # Enable Docker & VirtualBox support.
  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    videoDrivers = [ "nvidia" ];

    # Configure keymap in X11
    layout = "pt";
    xkbOptions = "eurosign:e";

    # Enable the Plasma 5 Desktop Environment.
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    optimus_prime = {
      enable = true;
  
      # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
      nvidiaBusId = "PCI:1:0:0";
  
      # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
      intelBusId = "PCI:0:2:0";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound.
  sound.enable = false;
  sound.mediaKeys.enable = true;

  hardware.pulseaudio = {
    enable = false;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
   
    # config.pipewire = {
    #   "context.properties" = {
    #     #"link.max-buffers" = 64;
    #     "link.max-buffers" = 16; # version < 3 clients can't handle more than this
    #     "log.level" = 2; # https://docs.pipewire.org/page_daemon.html
    #     #"default.clock.rate" = 48000;
    #     #"default.clock.quantum" = 1024;
    #     #"default.clock.min-quantum" = 32;
    #     #"default.clock.max-quantum" = 8192;
    #   };
    # };
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.miguelsantoss = {
    isNormalUser = true;
    extraGroups = [ "docker" "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable           = true;
    enableSSHSupport = true;
  };

  programs.fish.enable = true;

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    (nerdfonts.override { fonts = [ "JetBrainsMono" "LiberationMono" ]; })
  ];

  nixpkgs.config.allowUnfree = true;

  # Nix daemon config
  nix = {
    # Flakes settings
    package = pkgs.nixFlakes;
    registry.nixpkgs.flake = inputs.nixpkgs;

    # Automate `nix-store --optimise`
    autoOptimiseStore = true;

    # Automate garbage collection
    gc = {
      automatic = true;
      dates     = "weekly";
      options   = "--delete-older-than 7d";
    };

    # Avoid unwanted garbage collection when using nix-direnv
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';

    # Required by Cachix to be used as non-root user
    trustedUsers = [ "root" "miguelsantoss" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}

