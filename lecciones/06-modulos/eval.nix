let
  lib = import ((import ../../nix/source.nix) + "/lib");
in
(lib.evalModules {
  modules = [ ./host.nix ];
}).config
