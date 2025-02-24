{ pkgs, ... }: {
  gputil-mathoudebine = pkgs.callPackage ./gputil-mathoudebine.nix {};
  pyamdgpuinfo = pkgs.callPackage ./pyamdgpuinfo.nix {};
}
