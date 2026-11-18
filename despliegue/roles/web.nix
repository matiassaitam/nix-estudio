{ pkgs, ... }: {
  services.nginx.enable = true;
  services.nginx.virtualHosts.localhost.root =
    pkgs.writeTextDir "index.html" "Servidor web de estudio\n";
  networking.firewall.allowedTCPPorts = [ 80 ];
}
