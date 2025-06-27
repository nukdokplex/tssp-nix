{ withSystem, lib, ... }:
{
  flake.overlays = lib.fix (final: {
    # this adds all packages under outputs.packages.${system}
    pkgs =
      final: prev:
      withSystem prev.stdenv.hostPlatform.system (
        { system, config, ... }:
        let
          packageNameValuePairs = lib.attrsToList config.packages;
          packagePathPkgPairs = builtins.map (elem: {
            path = lib.splitString "/" elem.name;
            pkg = elem.value;
          }) packageNameValuePairs;
        in
        builtins.foldl' (
          acc: elem: lib.recursiveUpdate acc (lib.setAttrByPath elem.path elem.pkg)
        ) { } packagePathPkgPairs
      );

    default = final.pkgs;
  });
}
