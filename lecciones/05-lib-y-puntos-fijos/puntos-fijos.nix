let
  lib = import ((import ../../nix/source.nix) + "/lib");

  # self es el argumento de esta funcion. No es una palabra reservada.
  base = self: {
    name = "web";
    domain = "example.org";
    fqdn = "${self.name}.${self.domain}";
    url = "https://${self.fqdn}";
  };

  original = lib.fix base;
in
{
  inherit original;

  # Una actualizacion posterior no cambia la referencia interna de fqdn.
  updatedAfter = original // { name = "docs"; };

  # Aqui la extension participa en la definicion del resultado final.
  extended = lib.fix (self: (base self) // { name = "docs"; });
}
