{ system ? builtins.currentSystem }:
let
  nixpkgsSource = import ../nix/source.nix;
  evaluated = import (nixpkgsSource + "/nixos/lib/eval-config.nix") {
    inherit system;
    modules = [
      ./configuration.nix
      (nixpkgsSource + "/nixos/modules/virtualisation/qemu-vm.nix")
      {
        # Invitado de servicio sin acceso administrativo; no habilita contraseñas vacías.
        users.allowNoPasswordLogin = true;
        virtualisation = {
          graphics = false;
          memorySize = 1024;
          cores = 2;
          forwardPorts = [
            {
              from = "host";
              host.address = "127.0.0.1";
              host.port = 8080;
              guest.port = 80;
            }
          ];
        };
      }
    ];
  };
in
evaluated.config.system.build.vm
