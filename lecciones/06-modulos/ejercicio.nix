let
  lib = import ((import ../../nix/source.nix) + "/lib");
in
(lib.evalModules {
  modules = [
    ./host.nix
    ./greeter.nix
    ({ config, ... }: {
      greeter.enable = true;
      greeter.message = "Hola, ${config.hostName}";
    })
  ];
}).config
