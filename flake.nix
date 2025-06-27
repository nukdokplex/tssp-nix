{
  description = "turing-smart-screen-python by mathoudebine on Nix(OS) (linux only)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";
    systems.url = "github:nix-systems/default-linux";
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }:
      {
        imports = with inputs; [
          git-hooks-nix.flakeModule
          pkgs-by-name-for-flake-parts.flakeModule
          ./overlays.nix
          ./nixos-modules
        ];

        systems = import inputs.systems;

        perSystem =
          { pkgs, ... }:
          {
            formatter = pkgs.nixfmt-rfc-style;
            pkgsDirectory = ./pkgs;
          };
      }
    );
}
