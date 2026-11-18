let
  lib = import ((import ../../nix/source.nix) + "/lib");

  machines = {
    api = { cores = 4; enabled = true; };
    batch = { cores = 8; enabled = false; };
    web = { cores = 2; enabled = true; };
  };

  active = lib.filterAttrs (_name: machine: machine.enabled) machines;
in
{
  # mapAttrs conserva los nombres y transforma sus valores.
  workers = lib.mapAttrs (_name: machine: machine.cores * 2) machines;

  # attrNames produce una lista de nombres en orden alfabetico.
  activeNames = builtins.attrNames active;

  # foldl' recorre los valores y acumula el total de nucleos activos.
  activeCores = lib.foldl'
    (total: machine: total + machine.cores)
    0
    (builtins.attrValues active);

  inventory = lib.mapAttrsToList
    (name: machine: "${name}:${toString machine.cores}")
    machines;
}
