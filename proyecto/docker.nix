{ pkgs ? import ../nix/pkgs.nix { } }:
let
  site = import ./site.nix { inherit pkgs; };
  caddyfile = pkgs.writeText "Caddyfile" ''
    :80 {
      root * ${site}
      file_server
    }
  '';
in
pkgs.dockerTools.buildLayeredImage {
  name = "nix-estudio";
  tag = "1.0.0";
  contents = [ pkgs.caddy ];
  extraCommands = ''
    mkdir -p tmp
    chmod 1777 tmp
  '';
  config = {
    Cmd = [
      "${pkgs.caddy}/bin/caddy"
      "run"
      "--config"
      "${caddyfile}"
      "--adapter"
      "caddyfile"
    ];
    Env = [
      "XDG_CONFIG_HOME=/tmp/caddy/config"
      "XDG_DATA_HOME=/tmp/caddy/data"
    ];
    ExposedPorts = { "80/tcp" = { }; };
  };
}
