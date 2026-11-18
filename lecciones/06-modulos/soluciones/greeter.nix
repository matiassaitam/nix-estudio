{ lib, config, ... }:
let
  cfg = config.greeter;
in
{
  options.greeter = {
    enable = lib.mkEnableOption "el saludo de nuestra configuracion de practica";
    message = lib.mkOption {
      type = lib.types.str;
      default = "Hola";
      description = "Texto elegido para el saludo.";
    };
  };

  config = lib.mkIf cfg.enable {
    tools = [ "saludo" ];
    motd = cfg.message;
  };
}
