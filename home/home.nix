{ config, lib, pkgs, stdenv, ... }:

let
  username = "miguelsantoss";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";

  defaultPkgs = with pkgs; [
    any-nix-shell        # fish support for nix shell
    asciinema            # record the terminal
    bitwarden-cli        # command-line client for the password manager
    _1password-gui       # 1password
    bottom               # alternative to htop & ytop
    cachix               # nix caching
    # calibre              # e-book reader
    clojure
    dconf2nix            # dconf (gnome) files to nix converter
    dive                 # explore docker layers
    docker-compose       # docker manager
    drawio               # diagram design
    duf                  # disk usage/free utility
    exa                  # a better `ls`
    fd                   # "find" for files
    gimp                 # gnu image manipulation program
    glow                 # terminal markdown viewer
    gnomecast            # chromecast local files
    gnumake              # Make
    hyperfine            # command-line benchmarking tool
    insomnia             # rest client with graphql support
    jitsi-meet-electron  # open source video calls and chat
    killall              # kill processes by name
    libnotify            # notify-send command
    libreoffice          # office suite
    mpv                  # minimal and nice video player
    multilockscreen      # fast lockscreen based on i3lock
    ncdu                 # disk space info (a better du)
    neofetch             # command-line system information
    prettyping           # a nicer ping
    ranger               # terminal file explorer
    ripgrep              # fast grep
    rnix-lsp             # nix lsp server
    signal-desktop       # signal messaging client
    simple-scan          # scanner gui
    simplescreenrecorder # screen recorder gui
    slack                # messaging client
    spotify              # music source
    syncthing
    tdesktop             # telegram messaging client
    tldr                 # summary of a man page
    tree                 # display files in a tree view
    vlc                  # media player
    xsel                 # clipboard support (also for neovim)
    yad                  # yet another dialog - fork of zenity
    unzip

    # browser
    chromium

    # fixes the `ar` error required by cabal
    binutils-unwrapped

    mutt
    thunderbird
    evolution
    evolution-data-server
  ];

  gitPkgs = with pkgs.gitAndTools; [
    diff-so-fancy # git diff with colors
    git-crypt     # git files encryption
    hub           # github command-line client
    tig           # diff and commit view
  ];

  gnomePkgs = with pkgs.gnome3; [
    eog            # image viewer
    evince         # pdf reader
    gnome-calendar # calendar
    nautilus       # file manager

  ];

  haskellPkgs = with pkgs.haskellPackages; [
    brittany                # code formatter
    cabal2nix               # convert cabal projects to nix
    cabal-install           # package manager
    ghc                     # compiler
    haskell-language-server # haskell IDE (ships with ghcide)
    hoogle                  # documentation
    nix-tree                # visualize nix dependencies
  ];

  # polybarPkgs = with pkgs; [
  #   font-awesome-ttf      # awesome fonts
  #   material-design-icons # fonts with glyphs
  # ];
  # scripts = pkgs.callPackage ./scripts/default.nix { inherit config pkgs; };
  # yubiPkgs = with pkgs; [
  #   yubikey-manager  # yubikey manager cli
  #   yubioath-desktop # yubikey OTP manager (gui)
  # ];
  # xmonadPkgs = with pkgs; [
  #   networkmanager_dmenu   # networkmanager on dmenu
  #   networkmanagerapplet   # networkmanager applet
  #   nitrogen               # wallpaper manager
  #   xcape                  # keymaps modifier
  #   xorg.xkbcomp           # keymaps modifier
  #   xorg.xmodmap           # keymaps modifier
  #   xorg.xrandr            # display manager (X Resize and Rotate protocol)
  # ];

in
{
  programs.home-manager.enable = true;


  # imports = (import ./programs) ++ [(import ./themes)];
  imports = (import ./programs);

  xdg = {
    inherit configHome;
    enable = true;
  };

  home = {
    inherit username homeDirectory;
    stateVersion = "22.11";

    packages = defaultPkgs ++ gitPkgs ++ gnomePkgs ++ haskellPkgs;

    sessionVariables = {
      DISPLAY = ":0";
      EDITOR = "nvim";
    };
  };

  # restart services on change
  systemd.user.startServices = "sd-switch";

  # notifications about home-manager news
  news.display = "silent";

  programs = {
    bat.enable = true;

    broot = {
      enable = true;
      enableFishIntegration = true;
    };

    direnv = {
      enable = true;
      #enableFishIntegration = true;
      nix-direnv.enable = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
      defaultCommand = "fd --type file --follow"; # FZF_DEFAULT_COMMAND
      defaultOptions = [ "--height 20%" ]; # FZF_DEFAULT_OPTS
      fileWidgetCommand = "fd --type file --follow"; # FZF_CTRL_T_COMMAND
    };

    gpg.enable = true;

    htop = {
      enable = true;
      settings = {
        sort_direction = true;
        sort_key = "PERCENT_CPU";
      };
    };

    jq.enable = true;

    obs-studio = {
      enable = true;
      plugins = [];
    };

    ssh.enable = true;

    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [];
    };
  };

  services = {
    flameshot.enable = true;
  };

}
