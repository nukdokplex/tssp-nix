{
  # lib
  lib
, fetchFromGitHub
, # python
  python312
, python312Packages
, # libraries
  libdrm
, ...
}: python312.pkgs.buildPythonPackage rec {
  pname = "pyamdgpuinfo";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "mark9064";
    repo = "pyamdgpuinfo";
    rev = "v${version}";
    hash = "sha256-waHLLGefLAq9qjuaeLGItAIsgXi2SZPKJzxax4HYQ7U=";
  };

  pyproject = true;
  build-system = with python312Packages; [ cython setuptools ];
  buildInputs = [ libdrm ];

  postPatch = ''
    substituteInPlace ./setup.py \
      --replace-fail '"/usr/include/libdrm"' '"${lib.getDev libdrm}/include/libdrm", "${lib.getDev libdrm}/include"'
  '';

  meta = {
    homepage = "https://github.com/mark9064/pyamdgpuinfo";
    description = "Python module that provides AMD GPU information";
    licenses = with lib.licenses; [ gpl3Only ];
    platforms = [ "x86_64-linux" ];
  };
}
