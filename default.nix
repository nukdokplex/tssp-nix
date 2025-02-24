{ pkgs ? import <nixpkgs> {} }: let
  inherit (pkgs) lib;
in lib.fix (self: {
  pkgs = import ./pkgs { inherit pkgs; };
  nixosModules.default = import ./nixos-module.nix self.pkgs;
})
