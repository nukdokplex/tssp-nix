{
  lib,
  stdenvNoCC,
  tsspSrc,
  tsspVersion,
  recurseIntoAttrs,
  ...
}:
let
  reservedThemeFolders = [ "--Theme examples" ];

  isThemeFolder = p: p.value == "directory" && !builtins.elem p.name reservedThemeFolders;
  isFontFolder = p: p.value == "directory";

  themes = builtins.map (p: p.name) (
    lib.filter isThemeFolder (
      lib.mapAttrsToList (name: value: lib.nameValuePair name value) (
        builtins.readDir (tsspSrc + /res/themes)
      )
    )
  );

  fonts = builtins.map (p: p.name) (
    lib.filter isFontFolder (
      lib.mapAttrsToList (name: value: lib.nameValuePair name value) (
        builtins.readDir (tsspSrc + /res/fonts)
      )
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
        version = tsspVersion;

        src = tsspSrc;

        installPhase = ''
          cp -a "res/${resType}s/${dirName}" "$out"
        '';

        meta = {
          homepage = "https://github.com/mathoudebine/turing-smart-screen-python/tree/${lib.escapeURL tsspSrc.rev}/res/${resType}s/${lib.escapeURL dirName}";
          description =
            "This is \"${dirName}\" ${resType} package for turing-smart-screen-python package."
            + (
              if dirName != self.pname then
                " Notice that now it's renamed to \"${self.pname}}\" so you need to use this name in your configuration."
              else
                ""
            );
          platforms = lib.platforms.all;
          license = with lib.licenses; [ gpl3Only ];
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
