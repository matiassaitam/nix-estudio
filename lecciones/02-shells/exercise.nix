let
  pkgs = import ../../nix/pkgs.nix {};
in
pkgs.mkShell {
  packages = [ pkgs.coreutils pkgs.jq ];
  shellHook = ''
    export COURSE_NAME="nix-estudio"
    printf 'Entorno listo: %s\n' "$COURSE_NAME"
  '';
}
