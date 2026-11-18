let
  pkgs = import ../../nix/pkgs.nix {};
in
pkgs.writeShellApplication {
  name = "saluda";
  runtimeInputs = [ pkgs.coreutils ];
  text = ''
    nombre="''${1:-estudiante}"
    mensaje="''${2:-Buen trabajo}"
    printf 'Hola, %s\n' "$nombre"
    printf 'Palabras en el nombre: '
    printf '%s\n' "$nombre" | wc -w
    printf 'Mensaje: %s\n' "$mensaje"
  '';
}
