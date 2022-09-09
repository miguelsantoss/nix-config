{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      matklad.rust-analyzer
      jnoortheen.nix-ide
      golang.go
    ];
  };
}
