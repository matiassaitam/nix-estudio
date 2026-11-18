# Fuentes y mapa del curso

Este repositorio de estudio contiene material nuevo en español. Las fuentes siguientes sirven para contrastar conceptos y consultar los ejemplos originales; no se ha copiado aquí el repositorio del profesor.

- [Presentación: 140 diapositivas](https://viperml.gitlab.io/nixos-usweek/overview)
- [Repositorio oficial](https://gitlab.com/viperML/nixos-usweek)
- [Demo original](https://gitlab.com/viperML/nixos-usweek/-/tree/main/demo)
- [Revisión Nixpkgs usada aquí](https://github.com/NixOS/nixpkgs/commit/f68407657ad294471eb4b2e65d193df26edf729f)

El pin fue consultado en la rama `nixos-26.05` el 18-11-2026. Se fija el commit, no el nombre de la rama. `fetchTarball` no incluye un hash NAR calculado: no se ha inventado uno y este ejemplo usa evaluación no pura con herramientas clásicas.

## Correspondencia

| Carpeta del curso original | Dónde repasarlo aquí |
|---|---|
| 00-simple-shell | Lección 02 |
| 01-shellhook | Lección 02 |
| 02-pinned-nixpkgs | Lección 02 y nix/source.nix |
| 03-custom-script | Lección 03 |
| 04-c-deps | Proyecto: main.c y dependencias |
| 05-c-cmake-deps | Proyecto: CMakeLists.txt |
| 06-python-deps | AMPLIACIONES.md |
| 07-c-patched-deps | AMPLIACIONES.md |
| 08-direct | Consultar el ejemplo original; comparar con shells |
| 09-c-cross | AMPLIACIONES.md |
| 10-modules | Lección 06 |
| 11-nixos-vm | Proyecto: configuration.nix y vm.nix |
| 12-colmena | despliegue/ |
| 13-docker-caddy | Proyecto: docker.nix |
| 14-docker-caddy-adv | Proyecto: site.nix y docker.nix; comparar con original |
| 15-docker-python | AMPLIACIONES.md y ejemplo original |
| 16-automatic-deps | Lección 04 |
| 17-sandbox-check | Lección 04 |
| 18-user-env | AMPLIACIONES.md |
| 19-c-derivation | Proyecto: default.nix |
| 20-container-shell | Consultar el ejemplo original tras contenedores |
| Biblioteca y puntos fijos de las diapositivas | Lección 05 |
| Anexo del lenguaje | Lección 01 |

La diapositiva de entrada al primer ejercicio decía `00-simple`; la carpeta observada en el repositorio y tu VM se llama `00-simple-shell`.

## Documentación primaria

- [Lenguaje](https://nix.dev/tutorials/nix-language)
- [Shell declarativa](https://nix.dev/tutorials/first-steps/declarative-shell)
- [Pinning](https://nix.dev/tutorials/first-steps/towards-reproducibility-pinning-nixpkgs)
- [Empaquetado](https://nix.dev/tutorials/packaging-existing-software)
- [Biblioteca Nixpkgs](https://nixos.org/manual/nixpkgs/stable/)
- [Módulos](https://nix.dev/tutorials/module-system/a-basic-module/)
- [VM NixOS](https://nix.dev/tutorials/nixos/nixos-configuration-on-vm)
- [Contenedores](https://nix.dev/tutorials/nixos/building-and-running-docker-images)
- [Colmena](https://colmena.cli.rs/unstable/tutorial/index.html)

La rama de documentación `unstable` de Colmena puede describir funciones distintas de la versión instalada. Los comandos del material se mantienen dentro del flujo básico del curso.
