{
  description = "turing-smart-screen-python by mathoudebine Nix package + NixOS module";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }: let
    systems = [ "x86_64-linux" ];
    genPackages = system: let
      pkgs = import nixpkgs { inherit system; };
    in pkgs.lib.fix (
      self: import ./pkgs { inherit pkgs; } // { default = self.turing-smart-screen-python; }
    );
  in {
    packages = builtins.listToAttrs (
      builtins.map
        (system: { name = system; value = genPackages system; })
        systems
    );
    nixosModules.default = import ./nixos-module.nix;
  };
}
  
