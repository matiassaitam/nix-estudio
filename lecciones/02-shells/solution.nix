let
  pkgs = import ../../nix/pkgs.nix {};
in
pkgs.mkShell {
  packages = [ pkgs.coreutils pkgs.jq pkgs.hello ];
  shellHook = ''
    export COURSE_NAME="nix-estudio"
    export STUDY_MESSAGE="Aprendo practicando"
    printf 'Entorno listo: %s\n' "$COURSE_NAME"
    printf '%s\n' "$STUDY_MESSAGE"
  '';
}
