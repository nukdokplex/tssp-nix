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
      {
        inputs,
        config,
        ...
      }:
      {
        imports = with inputs; [
          pkgs-by-name-for-flake-parts.flakeModule
          ./overlays.nix
          ./devshells.nix
        ];

        systems = import inputs.systems;

        flake.nixosModules.tssp = import ./nixos-module.nix inputs;
        flake.nixosModules.default = config.flake.nixosModules.tssp;

        perSystem =
          { pkgs, ... }:
          {
            formatter = pkgs.nixfmt-rfc-style;
            pkgsDirectory = ./pkgs;
          };
      }
    );
}
