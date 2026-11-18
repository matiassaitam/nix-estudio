# Revisión exacta compartida. Verificada en nixos-26.05 el 18-11-2026.
# fetchTarball sin sha256 requiere evaluación no pura; usamos comandos clásicos.
builtins.fetchTarball {
  url = "https://github.com/NixOS/nixpkgs/archive/f68407657ad294471eb4b2e65d193df26edf729f.tar.gz";
}
