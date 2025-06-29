{
  lib,
  stdenvNoCC,
  recurseIntoAttrs,
  fetchFromGitHub,
  turing-smart-screen-python,
  ...
}:
let
  inherit (turing-smart-screen-python) src version meta;

  reservedThemeFolders = [ "--Theme examples" ];

  isThemeFolder = p: p.value == "directory" && !builtins.elem p.name reservedThemeFolders;
  isFontFolder = p: p.value == "directory";

  themes = builtins.map (p: p.name) (
    lib.filter isThemeFolder (
      lib.mapAttrsToList (name: value: lib.nameValuePair name value) (
        builtins.readDir (src + /res/themes)
      )
    )
  );

  fonts = builtins.map (p: p.name) (
    lib.filter isFontFolder (
      lib.mapAttrsToList (name: value: lib.nameValuePair name value) (builtins.readDir (src + /res/fonts))
    )
  );

  digitChars = builtins.genList (x: builtins.toString x) 10;
  removeBadSymbols = str: lib.replaceStrings [ " " "." ] [ "_" "-" ] str; # i know that it's morally wrong but there is no other way, nix doesn't support regex substitution
  prefixNumber =
    str: if builtins.elem (builtins.substring 0 1 str) digitChars then "_" + str else str;
  sanitizeIdentifier = str: prefixNumber (removeBadSymbols str);

  makeResourceDerivation =
    dirName: resType:
    lib.fix (
      self:
      stdenvNoCC.mkDerivation {
        pname = sanitizeIdentifier dirName;
        inherit src version;

        installPhase = ''
          cp -a "res/${resType}s/${dirName}" "$out"
        '';

        meta = {
          inherit (meta) homepage license maintainers;
          description =
            "This is \"${dirName}\" ${resType} package for turing-smart-screen-python package."
            + (
              if dirName != self.pname then
                " Notice that now it's renamed to \"${self.pname}}\" so you need to use this name in your configuration."
              else
                ""
            );
          platforms = lib.platforms.all;
        };

      }
    );
in
recurseIntoAttrs {
  themes = recurseIntoAttrs (
    builtins.listToAttrs (
      builtins.map (
        dirName: lib.nameValuePair (sanitizeIdentifier dirName) (makeResourceDerivation dirName "theme")
      ) themes
    )
  );
  fonts = recurseIntoAttrs (
    builtins.listToAttrs (
      builtins.map (
        dirName: lib.nameValuePair (sanitizeIdentifier dirName) (makeResourceDerivation dirName "font")
      ) fonts
    )
  );
}
