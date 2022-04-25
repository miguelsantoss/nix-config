{ lib, inputs, system, ... }:

{
   asus = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      ../system/configuration.nix
      ../system/machine/asus/configuration.nix
    ];
  };
}
