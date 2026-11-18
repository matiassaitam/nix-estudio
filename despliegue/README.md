# Colmena: de una máquina a un inventario

El curso termina coordinando varios sistemas. Este ejemplo define `alpha` y `gamma` como web y `beta` como base de datos. Los nombres son datos; `lib.mapAttrs` genera sus configuraciones y etiquetas.

## Leer y evaluar

Desde la raíz del repo:

```bash
nix-shell despliegue/shell.nix
cd despliegue
colmena eval -E '{ nodes, lib, ... }: lib.mapAttrs (_: node: node.config.deployment.tags) nodes'
```

Resultado esperado (el espacio del JSON puede variar):

```json
{"alpha":["web"],"beta":["db"],"gamma":["web"]}
```

También puedes usar `colmena repl` y consultar `nodes.alpha.config.services.nginx.enable` o `nodes.beta.config.services.postgresql.enable`; ambos deberían devolver `true`.

`hive.nix` establece `deployment.targetHost = null` y desactiva el despliegue local. Los nodos son configuraciones mínimas de tipo contenedor para estudiar el inventario; no tienen configuración de discos de máquinas reales.

## Qué sucede al desplegar

1. Evaluar y construir la configuración seleccionada.
2. Copiar su closure al destino, normalmente por SSH.
3. Activar el sistema en el destino.

En un inventario real ya preparado, `colmena apply --on @web` seleccionaría los nodos etiquetados `web`. Aquí no se proporcionan hosts reales. Para adaptar el ejemplo necesitas los datos del servidor, acceso autorizado y su configuración de hardware; no basta con cambiar una dirección y asumir que la configuración de discos es correcta.

## Secretos y rollback

No escribas una contraseña real en `environment.etc.<nombre>.text`: el archivo resultante irá al store y será generalmente legible por usuarios locales. Colmena permite transferir secretos separadamente mediante `deployment.keys`. Un archivo de secretos debe mantenerse fuera de Git; este repo no contiene credenciales.

Volver a una generación de NixOS recupera la configuración y paquetes retenidos. No deshace modificaciones de PostgreSQL ni restaura archivos del usuario. Una base de datos necesita copias de seguridad y su propio procedimiento de recuperación.

## Ejercicio

Añade un nodo ficticio `delta` con rol web. Evalúa de nuevo las etiquetas. Explica por qué no necesitas duplicar `roles/web.nix`. Después cambia solo `delta` al rol db y predice el resultado.

[Manual de Colmena](https://colmena.cli.rs/unstable/tutorial/index.html) · [Ejemplo original del curso](https://gitlab.com/viperML/nixos-usweek/-/tree/main/12-colmena)
