let
  lib = import ((import ../../nix/source.nix) + "/lib");
  original = {
    server = { port = 8080; name = "web"; };
  };
  change = {
    server.name = "docs";
  };
in
{
  # // reemplaza el atributo server completo.
  shallow = original // change;

  # recursiveUpdate entra en los conjuntos anidados.
  recursive = lib.recursiveUpdate original change;
}
