let
  lib = import ((import ../../nix/source.nix) + "/lib");
  base = self: {
    name = "web";
    domain = "example.org";
    fqdn = "${self.name}.${self.domain}";
    url = "https://${self.fqdn}";
  };
in
lib.fix (self: (base self) // {
  # TODO: cambia name a "tienda" y domain a "curso.test" aqui.
  # No repitas fqdn ni url: deben depender del resultado final.
})
