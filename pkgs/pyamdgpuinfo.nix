{
  lib,
  fetchFromGitHub,

  python3Packages,

  libdrm,
  ...
}:
python3Packages.buildPythonPackage (
  lib.fix (final: {
    pname = "pyamdgpuinfo";
    version = "2.1.7";

    src = fetchFromGitHub {
      owner = "mark9064";
      repo = "pyamdgpuinfo";
      rev = "v${final.version}";
      hash = "sha256-e+pgLDe+fFgK+KNDuMkNSd2/1gorqSDQeSRJiRDZ5Nw=";
    };

    pyproject = true;
    build-system = with python3Packages; [
      cython
      setuptools
    ];

    buildInputs = [ libdrm ];

    postPatch = ''
      substituteInPlace ./setup.py \
        --replace-fail '"/usr/include/libdrm"' '"${lib.getDev libdrm}/include/libdrm", "${lib.getDev libdrm}/include"'
    '';

    meta = {
      homepage = "https://github.com/mark9064/pyamdgpuinfo";
      description = "Python module that provides AMD GPU information";
      licenses = lib.licenses.gpl3Only;
      platforms = [ "x86_64-linux" ];
      maintainers = with lib.maintainers; [ nukdokplex ];
    };
  })
)
