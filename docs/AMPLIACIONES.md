# Ampliaciones del curso

Estas notas completan los temas que no requieren otra aplicación distinta. Los ejemplos siguientes son ilustraciones; los laboratorios del repositorio original permiten profundizar.

## Python: intérprete y bibliotecas juntos

Con `pkgs` importado desde nuestro pin:

```nix
pkgs.python3.withPackages (ps: [ ps.requests ])
```

Esto produce un intérprete con esa biblioteca disponible. Puedes añadirlo a `packages` de una shell. Tener Python y ejecutar `pip install` manualmente son decisiones diferentes: registra las dependencias que necesitas para que otra persona pueda recrear el entorno. No combines dos intérpretes sin comprobar cuál ejecuta tu aplicación.

**Práctica:** consulta `06-python-deps` del curso e identifica el intérprete y el conjunto de bibliotecas. [Guía oficial](https://nix.dev/guides/recipes/python-environment).

## Parches y overrides

Una definición de paquete puede modificarse con `overrideAttrs`. Por ejemplo, añadir un parche local cambia los inputs de construcción:

```nix
pkgs.hello.overrideAttrs (old: {
  patches = (old.patches or []) ++ [ ./mi-cambio.patch ];
})
```

Es un esquema: necesita un archivo de parche real compatible con el código fuente. No se presenta como un comando listo para ejecutar. Revisa `07-c-patched-deps` del curso y explica qué cambia antes de compilar.

## Compilación cruzada

La máquina que ejecuta el compilador puede ser distinta del sistema que ejecutará el programa. Distingue herramientas para la máquina de construcción y bibliotecas para el destino. Un ejecutable ARM no se puede ejecutar directamente en x86_64 sin soporte adicional.

El proyecto de este repo usa compilación nativa: `site.nix` ejecuta el programa construido para generar HTML. Convertirlo en cross-build requiere separar ese paso o disponer de ejecución para el destino. La lección original `09-c-cross` trata la selección del destino. [Tutorial](https://nix.dev/tutorials/cross-compilation).

## Perfiles y entorno de usuario

Una shell temporal cambia las herramientas disponibles en una sesión. Un perfil mantiene una selección de paquetes para el usuario. `pkgs.buildEnv` permite combinar varios paquetes en un resultado. Home Manager aplica el sistema de módulos a herramientas y archivos del usuario.

**Práctica:** en `18-user-env`, localiza las rutas combinadas y distingue la construcción del entorno de su instalación en un perfil. [Home Manager](https://github.com/nix-community/home-manager).

## CI

Un sistema de integración continua obtiene el código, instala/configura Nix y ejecuta las mismas comprobaciones que tú. En este repo, el comando de construcción y comprobación es:

```bash
bash scripts/check.sh --build
```

Los logs deben distinguir evaluación, construcción, pruebas y arranque de servicios. El script no despliega. Una caché reutiliza resultados; para repetir las pruebas fuera de la derivación, `--build` ejecuta además el binario resultante.

No se ha publicado este repo ni configurado un runner remoto. [Guía de CI con Nix](https://nix.dev/guides/recipes/continuous-integration-github-actions).

## Imágenes frente a contenedores frente a VM

Una imagen es un artefacto. Un contenedor es una ejecución de esa imagen que comparte el kernel del anfitrión. Una VM ejecuta su propio kernel invitado. Construir una imagen no la arranca; construir una configuración de VM no activa el sistema anfitrión.
