let pkgs = import ../nix/pkgs.nix {}; in
pkgs.mkShell { packages = [ pkgs.colmena ]; }
