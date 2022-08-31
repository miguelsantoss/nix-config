{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    nurpkgs = {
      url = github:nix-community/NUR;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-flake = {
      # url = git+file:///home/gvolpe/workspace/neovim-flake;
      url = github:gvolpe/neovim-flake;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-doom-emacs = {
      url = "github:nix-community/nix-doom-emacs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.emacs-overlay.follows = "emacs-overlay";
    };

    # emacs-plz = {
    #   url = "github:alphapapa/plz.el";
    #   flake = false;
    # };
  };

  outputs = inputs @ { self, nixpkgs, ... }:
    let
    system = "x86_64-linux";
  in {
    homeConfigurations = (
      import ./outputs/home-conf.nix {
        inherit inputs system;
      }
    );

    nixosConfigurations = (
      import ./outputs/nixos-conf.nix {
        inherit inputs system;
      }
    );
  };
}
