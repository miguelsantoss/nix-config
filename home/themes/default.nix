{ pkgs, ... }:

let
  juno = pkgs.callPackage ./juno {};
in
{
  gtk = {
    enable = true;
    iconTheme = {
      name = "BeautyLine";
      package = pkgs.beauty-line-icon-theme;
    };
    theme = {
      name = "Juno-ocean";
      package = juno;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
  };
}
