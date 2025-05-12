{
  inputs,
  config,
  withSystem,
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
        tsspPackages = config.packages;
      }
    ));
}
