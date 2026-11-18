{ lib, config, ... }:
{
  options = {
    hostName = lib.mkOption {
      type = lib.types.str;
      default = "laboratorio";
      description = "Nombre del equipo ficticio.";
    };

    tools = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Nombres de herramientas, solo como datos del ejercicio.";
    };

    motd = lib.mkOption {
      type = lib.types.str;
      description = "Mensaje de bienvenida.";
    };
  };

  config.motd = lib.mkDefault "Bienvenido a ${config.hostName}";
}
