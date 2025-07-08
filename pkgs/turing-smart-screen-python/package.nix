{
  lib,
  fetchFromGitHub,

  python3Packages,
  pyamdgpuinfo,
  gputil,

  fontPackages ? [ ],
  themePackages ? [ ],
  tsspConfiguration ? { },
  ...
}:
# wtf buildPython{Package, Application} has no builtin fixed-point
python3Packages.buildPythonApplication (
  lib.fix (final: {
    pname = "turing-smart-screen-python";
    version = "3.9.3";

    src = fetchFromGitHub {
      owner = "mathoudebine";
      repo = "turing-smart-screen-python";
      rev = final.version;
      hash = "sha256-VbuJ6f3RUXVFjTZXcv/U8VdYLA2uppZP1yOl8jKWmaA=";
    };

    disabled = !python3Packages.pythonAtLeast "3.9";
    format = "other";
    patches = [ ./disable-log-file.patch ];

    dependencies = with python3Packages; [
      pyserial
      pyyaml
      psutil
      babel
      uptime
      requests
      ping3
      pillow
      numpy

      gputil
      pyamdgpuinfo
    ];

    installPhase =
      let
        tsspDir = "$out/share/turing-smart-screen-python";
      in
      ''
        mkdir -p "${tsspDir}/res/themes" "${tsspDir}/res/fonts"
        cp -a library main.py "${tsspDir}"
        cp -a "res/themes/default.yaml" "${tsspDir}/res/themes"
        chmod +x "${tsspDir}/main.py"
        makeWrapper "${tsspDir}/main.py" "${tsspDir}/run" \
          --prefix PYTHONPATH : "$PYTHONPATH"
        echo ${lib.escapeShellArg (builtins.toJSON tsspConfiguration)} > "${tsspDir}/config.yaml"
      ''
      + builtins.concatStringsSep "\n" (
        (builtins.map (theme: "ln -sf \"${theme}\" \"${tsspDir}/res/themes/${theme.pname}\"") themePackages)
        ++ (builtins.map (font: "ln -sf \"${font}\" \"${tsspDir}/res/fonts/${font.pname}\"") fontPackages)
      );

    meta = {
      homepage = "github.com/mathoudebine/turing-smart-screen-python";
      description = "Unofficial Python system monitor and library for small IPS USB-C displays like Turing Smart Screen or XuanFang.";
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      maintainers = with lib.maintainers; [ nukdokplex ];
      license = lib.licenses.gpl3Only;
    };
  })
)
