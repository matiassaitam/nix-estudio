{ pkgs, ... }:
let
  site = import ./site.nix { inherit pkgs; };
in
{
  networking.hostName = "nix-estudio";
  system.stateVersion = "26.05";

  services.caddy = {
    enable = true;
    virtualHosts.":80".extraConfig = ''
      root * ${site}
      file_server
    '';
  };
  networking.firewall.allowedTCPPorts = [ 80 ];

  # VM de un servicio: no hace falta abrir una sesion para visitar la pagina.
  users.mutableUsers = false;
  users.users.root.hashedPassword = "!";
}
