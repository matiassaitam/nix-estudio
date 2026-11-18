{ pkgs ? import ../nix/pkgs.nix { } }:
let
  app = import ./default.nix { inherit pkgs; };
in
pkgs.mkShell {
  # Reutiliza las dependencias declaradas en el paquete.
  inputsFrom = [ app ];
  packages = [ pkgs.git pkgs.pkg-config ];

  shellHook = ''
    echo "Entorno listo: compilador C, CMake y zlib."
    echo "Desde la raiz: cmake -S proyecto -B build/proyecto"
    echo "Despues: cmake --build build/proyecto"
  '';
}
