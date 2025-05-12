{
  inputs,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      packages = inputs.flake-utils.lib.flattenTree (import ./packages.nix { inherit pkgs; });
    };

  flake.overlays.default = final: prev: prev // (import ./packages.nix { pkgs = prev; });
}
