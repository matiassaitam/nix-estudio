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

  # TODO: cuando cfg.enable sea true, contribuir tools = [ "saludo" ]
  # y motd = cfg.message. Usa lib.mkIf y no cambies las opciones.
  config = {};
}
