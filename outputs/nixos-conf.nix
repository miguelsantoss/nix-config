{ inputs, system, ... }:

let
  nixosSystem = inputs.nixpkgs.lib.nixosSystem;
in
{
   asus = nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      ../system/machine/asus/configuration.nix
      ../system/configuration.nix
    ];
  };
}
