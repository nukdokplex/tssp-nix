{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch,
  ...
}:
python3Packages.buildPythonPackage (
  lib.fix (final: {
    pname = "gputil";
    version = "1.4.0";

    pyproject = true;
    build-system = with python3Packages; [ setuptools ];

    src = fetchFromGitHub {
      owner = "anderskm";
      repo = "gputil";
      tag = "v${final.version}";
      hash = "sha256-uzdo8fnaV0YftJe/+rnLz635mI8Buj6DIkB4iSNyIRo=";
    };

    patches = lib.singleton (fetchpatch {
      url = "https://github.com/anderskm/gputil/compare/42ef071dfcb6469b7ab5ab824bde6ca9f6d0ab8a...mathoudebine:gputil:784499d443d38ed8c591fd27ae76b0a91dbcf788.patch";
      hash = "sha256-WA93ayqixtT10X+d0D0PRsIL+/LCcwaUiLKA9WkMAMA=";
    });

    meta = {
      homepage = "https://github.com/anderskm/gputil";
      description = "Python module for getting the GPU status from NVIDIA GPUs using `nvidia-smi`.";
      license = lib.licenses.mit;
      platforms = [ "x86_64-linux" ];
      maintainers = with lib.maintainers; [ nukdokplex ];
    };
  })
)
