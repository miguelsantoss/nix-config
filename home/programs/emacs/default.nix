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
      clojure-lsp = super.clojure-lsp.overrideAttrs (esuper: {
        buildInputs = esuper.buildInputs ++ [ pkgs.clojure-lsp ];
      });
    };
  };

  # services.emacs = {
  #   enable = true;
  #   package = programs.emacs.package;
  # };
}
