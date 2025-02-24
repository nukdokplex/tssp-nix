{ pkgs ? import <nixpkgs> {} }: let
  inherit (pkgs) lib; 
in lib.fix (self: {
  python312Packages = pkgs.recurseIntoAttrs (pkgs.callPackage ./python312Packages {}); 

  turing-smart-screen-python = pkgs.callPackage ./turing-smart-screen-python {
    inherit (self.python312Packages) gputil-mathoudebine pyamdgpuinfo;
  };

  resources = pkgs.recurseIntoAttrs (pkgs.callPackage ./resources {});
})
