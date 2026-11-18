{ pkgs ? import ../nix/pkgs.nix { } }:
let
  app = import ./default.nix { inherit pkgs; };
in
# El HTML se genera al construir, no en cada peticion del navegador.
pkgs.runCommand "nix-estudio-site-1.0.0" { } ''
  mkdir -p "$out"
  ${app}/bin/nix-estudio > "$out/index.html"
''
