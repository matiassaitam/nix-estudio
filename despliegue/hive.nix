let
  pkgs = import ../nix/pkgs.nix { system = "x86_64-linux"; };
  lib = pkgs.lib;
  hosts = {
    alpha = { role = "web"; };
    beta = { role = "db"; };
    gamma = { role = "web"; };
  };
in
{
  meta.nixpkgs = pkgs;
  defaults = { name, ... }: {
    networking.hostName = name;
    system.stateVersion = "26.05";
    # Sistemas mínimos para estudiar/evaluar: no describen discos de un servidor.
    boot.isContainer = true;
    # Sin destinos remotos ni activación en el anfitrión del laboratorio.
    deployment.targetHost = null;
    deployment.allowLocalDeployment = false;
  };
} // lib.mapAttrs (_: host: {
  deployment.tags = [ host.role ];
  imports = [ (./roles + "/${host.role}.nix") ];
}) hosts
