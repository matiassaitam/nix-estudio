let
  data = import ./datos.nix;
  merges = import ./mezclas.nix;
  fixed = import ./puntos-fijos.nix;
  solution = import ./soluciones/ejercicio.nix;
in
assert data.workers == { api = 8; batch = 16; web = 4; };
assert data.activeNames == [ "api" "web" ];
assert data.activeCores == 6;
assert data.inventory == [ "api:4" "batch:8" "web:2" ];
assert !(merges.shallow.server ? port);
assert merges.recursive.server == { name = "docs"; port = 8080; };
assert fixed.original.url == "https://web.example.org";
assert fixed.updatedAfter.name == "docs";
assert fixed.updatedAfter.fqdn == "web.example.org";
assert fixed.extended.url == "https://docs.example.org";
assert solution.url == "https://tienda.curso.test";
true
