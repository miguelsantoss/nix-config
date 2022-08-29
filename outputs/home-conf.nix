{ inputs, system, ... }:

with inputs;

let
  pkgs = import nixpkgs {
    inherit system;

    config.allowUnfree = true;

    overlays = [
      neovim-flake.overlays.default
      nurpkgs.overlay
    ];
  };

  nur = import nurpkgs {
    inherit pkgs;
    nurpkgs = pkgs;
  };

  imports = [
    neovim-flake.nixosModules.hm
    ../home/home.nix
  ];
in
{
  miguelsantoss = home-manager.lib.homeManagerConfiguration rec {
    inherit pkgs;

    extraSpecialArgs = {
      addons = nur.repos.rycee.firefox-addons;
    };

    modules = [{ inherit imports; }];
  };
}
