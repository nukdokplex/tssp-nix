{
  description = "turing-smart-screen-python by mathoudebine on Nix(OS) (linux only)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default-linux";
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    flake-compat.url = "github:edolstra/flake-compat";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }:
      {
        imports = [
          inputs.git-hooks-nix.flakeModule
          ./pkgs
          ./nixos-modules
        ];

        systems = import inputs.systems;

        perSystem =
          { pkgs, ... }:
          {
            formatter = pkgs.nixfmt-rfc-style;
            #pre-commit.settings = {
            #  hooks = {
            #    nixfmt-rfc-style.enable = true;
            #    deadnix.enable = true;
            #    check-json.enable = true;
            #    pretty-format-json.enable = true;
            #  };
            #};
          };
      }
    );
}
