{ system, nixpkgs, nurpkgs, home-manager, ... }:

let
  username = "miguelsantoss";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";

  pkgs = import nixpkgs {
    inherit system;

    config.allowUnfree = true;
    config.xdg.configHome = configHome;

    overlays = [
      nurpkgs.overlay
    ];
  };

  nur = import nurpkgs {
    inherit pkgs;
    nurpkgs = pkgs;
  };

  mkHome = conf: (
    home-manager.lib.homeManagerConfiguration rec {
      inherit pkgs system username homeDirectory;

      stateVersion = "22.05";
      configuration = conf;
    });

  conf = import ../home/home.nix {
    inherit nur pkgs;
    inherit (pkgs) config lib stdenv;
  };
in
{
  miguelsantoss = mkHome conf;
}
