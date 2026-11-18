let
  pkgs = import ../../nix/pkgs.nix {};
in
pkgs.runCommand "informe-store" {
  nativeBuildInputs = [ pkgs.coreutils ];
} ''
  mkdir -p "$out"
  printf '%s\n' 'Informe creado dentro de una derivacion.' > "$out/informe.txt"
  printf '%s\n' '${pkgs.hello}/bin/hello' > "$out/programa.txt"
''
