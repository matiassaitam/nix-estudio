#!/usr/bin/env bash
# Ejecutar desde Linux con Nix. No activa sistemas ni despliega.
set -euo pipefail
cd "$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
mode="${1:-}"
if [[ $# -gt 1 || ( -n "$mode" && "$mode" != "--build" ) ]]; then
  echo 'Uso: bash scripts/check.sh [--build]' >&2
  exit 2
fi
for tool in nix-instantiate python3; do
  command -v "$tool" >/dev/null || { echo "Falta $tool. Usa Linux con Nix y entra con nix-shell." >&2; exit 1; }
done
printf '%s\n' '1. Sintaxis de todos los archivos Nix'
while IFS= read -r -d '' file; do
  nix-instantiate --parse "$file" >/dev/null
done < <(find . -type d \( -name .git -o -name build \) -prune -o -type f -name '*.nix' -print0)
printf '%s\n' '2. Lenguaje: comprobar datos calculados'
nix-instantiate --eval --strict --json lecciones/01-lenguaje/solution.nix | python3 -c 'import json,sys; d=json.load(sys.stdin); assert d["port"] == 9090; assert d["message"] == "Proyecto aula"; print("Lenguaje: OK")'
printf '%s\n' '3. Biblioteca, puntos fijos y módulos'
for lesson in 05-lib-y-puntos-fijos 06-modulos; do
  value="$(nix-instantiate --eval --strict "lecciones/$lesson/checks.nix")"
  test "$value" = true
  printf '%s: OK\n' "$lesson"
done
printf '%s\n' '4. Evaluación de las recetas y de las opciones NixOS (sin construir)'
for expression in proyecto/default.nix proyecto/site.nix proyecto/docker.nix proyecto/vm.nix; do
  nix-instantiate "$expression" >/dev/null
  printf '%s: OK\n' "$expression"
done
if [[ "$mode" = "--build" ]]; then
  command -v nix-build >/dev/null || { echo 'Falta nix-build' >&2; exit 1; }
  printf '%s\n' '5. Construcción, CTest y comprobación del HTML'
  app="$(nix-build proyecto/default.nix --no-out-link)"
  test "$("$app/bin/nix-estudio" --version)" = 'nix-estudio 1.0.0'
  site="$(nix-build proyecto/site.nix --no-out-link)"
  python3 scripts/check_html.py "$site/index.html"
  greeting="$(nix-build lecciones/03-paquetes/solution.nix --no-out-link)"
  test "$("$greeting/bin/saluda" 'Ada Lovelace')" = $'Hola, Ada Lovelace\nPalabras en el nombre: 2\nMensaje: Buen trabajo'
  printf '%s\n' 'Paquetes: OK'
fi
printf '%s\n' 'Comprobaciones terminadas. No se han arrancado Docker/VM ni desplegado hosts.'
