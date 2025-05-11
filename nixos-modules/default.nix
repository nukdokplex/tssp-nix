{ config, inputs, ... }:
{
  flake.nixosModules.tssp = import ./tssp.nix inputs;
  flake.nixosModules.default = config.flake.nixosModules.tssp;
}
