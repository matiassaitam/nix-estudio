let
  lib = import ((import ../../nix/source.nix) + "/lib");
  base = import ./eval.nix;
  solved = import ./soluciones/eval.nix;
  evaluate = extra: (lib.evalModules {
    modules = [ ./host.nix ./soluciones/greeter.nix ] ++ extra;
  }).config;
  disabled = evaluate [];
  withExtraTool = evaluate [
    { greeter.enable = true; tools = [ "curl" ]; }
  ];
  forcedOff = evaluate [
    { greeter.enable = true; }
    { greeter.enable = lib.mkForce false; }
  ];
  forcedMessage = evaluate [
    { greeter.enable = true; }
    { motd = lib.mkForce "En mantenimiento"; }
  ];
in
assert base.hostName == "aula";
assert base.motd == "Bienvenido a aula";
assert base.tools == [ "git" ];
assert solved.motd == "Hola, aula";
assert lib.sort builtins.lessThan solved.tools == [ "git" "saludo" ];
assert !disabled.greeter.enable;
assert disabled.tools == [ "git" ];
assert disabled.motd == "Bienvenido a aula";
assert lib.sort builtins.lessThan withExtraTool.tools == [ "curl" "git" "saludo" ];
assert !forcedOff.greeter.enable;
assert forcedOff.tools == [ "git" ];
assert forcedMessage.motd == "En mantenimiento";
assert builtins.elem "saludo" forcedMessage.tools;
true
