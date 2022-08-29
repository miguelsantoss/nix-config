{ config, pkgs, inputs, ... }:

{
  nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];

  fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];

  home.packages = with pkgs; [
    ## Emacs itself
    binutils       # native-comp needs 'as', provided by this
    # 29 + pgtk + native-comp
    ((emacsPackagesFor emacsPgtkGcc).emacsWithPackages (epkgs: [
      epkgs.vterm
    ]))

    ## Doom dependencies
    git
    (ripgrep.override {withPCRE2 = true;})
    gnutls              # for TLS connectivity

    ## Optional dependencies
    fd                  # faster projectile indexing
    imagemagick         # for image-dired
    zstd                # for undo-fu-session/undo-tree compression

    ## Module dependencies
    # :checkers spell
    (aspellWithDicts (ds: with ds; [
      en en-computers en-science
    ]))
    # :tools editorconfig
    editorconfig-core-c # per-project style config
    # :tools lookup & :lang org +roam
    sqlite
  ];

  system.userActivationScripts = {
    installDoomEmacs = ''
      if [ ! -d "$XDG_CONFIG_HOME/emacs" ]; then
         git clone --depth=1 --single-branch "https://github.com/hlissner/doom-emacs" "$XDG_CONFIG_HOME/emacs"
      fi
    '';
  };
}
