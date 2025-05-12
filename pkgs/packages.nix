{ pkgs, ... }:
pkgs.lib.fix (self: {
  turing-smart-screen-python = pkgs.callPackage ./turing-smart-screen-python {
    inherit (self.python312Packages) gputil-mathoudebine pyamdgpuinfo;
  };

  python312Packages = pkgs.recurseIntoAttrs (pkgs.callPackage ./python312Packages { });
  resources = pkgs.recurseIntoAttrs (pkgs.callPackage ./resources { });
})
