{ inputs, ... }:
{
  imports = [
    inputs.git-hooks-nix.flakeModule
  ];

  perSystem =
    { pkgs, config, ... }:
    {
      pre-commit.check.enable = true;
      pre-commit.settings.hooks = {
        nixfmt-rfc-style.enable = true; # nix format
        deadnix.enable = true; # check for dead nix code
      };

      devShells.default = pkgs.mkShell {
        name = "default";

        shellHook = config.pre-commit.installationScript;

        packages = with pkgs; [ ] ++ config.pre-commit.settings.enabledPackages;
      };
    };
}
