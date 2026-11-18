let
  lib = import ((import ../../../nix/source.nix) + "/lib");
  base = self: {
    name = "web";
    domain = "example.org";
    fqdn = "${self.name}.${self.domain}";
    url = "https://${self.fqdn}";
  };
in
lib.fix (self: (base self) // {
  name = "tienda";
  domain = "curso.test";
})
