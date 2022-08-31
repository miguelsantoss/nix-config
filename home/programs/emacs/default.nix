{ pkgs, ... }:

{
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
    emacsPackage = pkgs.emacsPgtkNativeComp;

    emacsPackagesOverlay = self: super: {
      gitignore-mode = pkgs.emacsPackages.git-modes;
      gitconfig-mode = pkgs.emacsPackages.git-modes;
      ob-ammonite = pkgs.emacsPackages.ob-ammonite;
    };
  };

  # services.emacs = {
  #   enable = true;
  #   package = programs.emacs.package;
  # };
}
