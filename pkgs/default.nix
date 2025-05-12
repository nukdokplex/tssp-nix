{
  inputs,
  withSystem,
  lib,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      packages = inputs.flake-utils.lib.flattenTree (import ./packages.nix { inherit pkgs; });
    };

  flake.overlays.default =
    final: prev:
    (withSystem prev.stdenv.hostPlatform.system (
      { config, ... }:
      {
        tsspPackages = builtins.foldl' (acc: elem: lib.recursiveUpdate acc elem) { } (
          lib.mapAttrsToList (name: value: lib.setAttrByPath (lib.splitString "/" name) value) config.packages
        );
      }
    ));
}
