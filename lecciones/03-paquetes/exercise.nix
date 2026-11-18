let
  pkgs = import ../../nix/pkgs.nix {};
in
pkgs.writeShellApplication {
  name = "saluda";
  runtimeInputs = [ pkgs.coreutils ];
  text = ''
    nombre="''${1:-estudiante}"
    printf 'Hola, %s\n' "$nombre"
    printf 'Palabras en el nombre: '
    printf '%s\n' "$nombre" | wc -w
  '';
}
