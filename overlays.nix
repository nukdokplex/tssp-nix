{
  lib,
  inputs,
  config,
  ...
}:
{
  flake.overlays = lib.fix (final: {
    # this adds all packages under outputs.packages.${system}
    packages = final: prev: {
      tsspPackages = inputs.self.outputs.legacyPackages.${prev.stdenv.hostPlatform.system} or { };
    };

    default = final.packages;
  });
}
