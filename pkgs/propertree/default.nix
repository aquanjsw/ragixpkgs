{
  lib,
  fetchFromGitHub,
  stdenv,
  python3,
  makeWrapper,
}:
let
  pythonEnv = python3.withPackages (ps: [ ps.tkinter ]);
in
stdenv.mkDerivation {
  pname = "propertree";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "corpnewt";
    repo = "propertree";
    rev = "51ed53dbe3c96a81686ae1fc47f6d2a92f668159";
    sha256 = "sha256-yDkIALfDh8LcCStZGPaUDQbmDdei6nir8XSed2ZqOIs=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/propertree
    cp -r ProperTree.py Scripts $out/share/propertree/

    mkdir -p $out/bin
    makeWrapper ${pythonEnv}/bin/python $out/bin/propertree \
      --add-flags "$out/share/propertree/ProperTree.py"

    runHook postInstall
  '';

  passthru = {
    exePath = "/bin/propertree";
  };

  meta = with lib; {
    description = "A simple property tree viewer";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
