let
  pkgs = import ./nix/pkgs.nix {};
in
pkgs.mkShell {
  packages = [ pkgs.git pkgs.cmake pkgs.python3 ];
  buildInputs = [ pkgs.zlib ];
  shellHook = ''
    echo "Nix: laboratorio de estudio"
    echo "Empieza en README.md. Comprueba con: bash scripts/check.sh"
  '';
}
