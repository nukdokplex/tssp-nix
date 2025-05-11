inputs:
{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.services.turing-smart-screen-python;
in
{

  options.services.turing-smart-screen-python = {
    enable = lib.mkEnableOption "Turing smart screen python daemon";
    systemd.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable turing-smart-screen-python systemd service";
      default = true;
    };
    fonts = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "TSSP font packages that will be added to turing-smart-screen-python installation";
      example = lib.literalExpression ''
        with pkgs.tsspResources.fonts; [ 
          geforce
          generale-mono
          jetbrains-mono
          racespace
          roboto
          roboto-mono
        ]
      '';
    };
    themes = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "TSSP theme packages that will be added to turing-smart-screen-python installation";
      example = lib.literalExpression ''
        with pkgs.tsspResources.themes; [ 
          LandscapeEarth
          Landscape6Grid
        ]
      '';
    };
    finalPackage = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      visible = false;
      description = "The final turing-smart-screen-python package with all configured resources installed";
      default = pkgs.turing-smart-screen-python.override {
        fontPackages = cfg.fonts;
        themePackages = cfg.themes;
        tsspConfiguration = cfg.settings;
      };
    };

    settings = lib.mkOption {
      inherit (pkgs.formats.yaml { }) type;
      default = { };
      example = {
        config = {
          COM_PORT = "/dev/ttyACM0";
          THEME = "3.5inchTheme2";
          HW_SENSORS = "PYTHON";
          ETH = "enp42s0";
          WL0 = "wlp1s0";
          CPU_FAN = "AUTO";
          PING = "8.8.8.8";
          WEATHER_API_KEY = "";
          WEATHER_LATITUDE = 45.75;
          WEATHER_LONGITUDE = 4.85;
          WEATHER_UNITS = "metric";
          WEATHER_LANGUAGE = "en";
        };
        display = {
          REVISION = "A";
          BRIGHTNESS = 20;
          DISPLAY_REVERSE = false;
        };
      };
      description = ''
        Turing smart screen python configuration.

        For configuration explanation see <https://github.com/mathoudebine/turing-smart-screen-python/blob/main/config.yaml>.'';
    };
  };

  config =
    {
      config.nixpkgs.overlays = lib.singleton inputs.self.overlays.default;
    }
    // (lib.mkIf cfg.enable {
      systemd.services.turing-smart-screen-python = lib.mkIf cfg.systemd.enable {
        description = "Turing smart screen python service";
        wantedBy = [ "multi-user.target" ];
        requires = [ "network-online.target" ];
        after = [ "network-online.target" ];
        serviceConfig = {
          Type = "simple";
          SupplementaryGroups = [ "dialout" ];
          WorkingDirectory = "${cfg.finalPackage}/share/turing-smart-screen-python";
          ExecStart = "${cfg.finalPackage}/share/turing-smart-screen-python/run";
          Restart = "always";
          ProtectSystem = "full";
          ProtectHome = "read-only";
          PrivateTmp = true;
        };
      };
    });
}
