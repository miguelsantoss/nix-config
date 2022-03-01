{ lib, inputs, system, ... }:

{
   asus = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      ../system/machine/asus/configuration.nix
    ];
  };
}
