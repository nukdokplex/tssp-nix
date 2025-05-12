{
  pkgs,
  tsspSrc,
  tsspVersion,
  ...
}:
pkgs.lib.fix (self: {
  turing-smart-screen-python = pkgs.callPackage ./turing-smart-screen-python {
    inherit (self.python312Packages) gputil-mathoudebine pyamdgpuinfo;
    inherit tsspSrc tsspVersion;
  };

  python312Packages = pkgs.recurseIntoAttrs (pkgs.callPackage ./python312Packages { });
  resources = pkgs.recurseIntoAttrs (pkgs.callPackage ./resources { inherit tsspSrc tsspVersion; });
})
