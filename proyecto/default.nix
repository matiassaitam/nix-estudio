{ pkgs ? import ../nix/pkgs.nix { } }:

# Una derivacion describe como construir un resultado en /nix/store.
pkgs.stdenv.mkDerivation {
  pname = "nix-estudio";
  version = "1.0.0";
  src = pkgs.lib.cleanSource ./.;

  # Herramienta que corre durante la compilacion.
  nativeBuildInputs = [ pkgs.cmake ];
  # Biblioteca que utiliza el programa compilado.
  buildInputs = [ pkgs.zlib ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    ctest --output-on-failure
    runHook postCheck
  '';
}
