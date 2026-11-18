# Walkthrough: de tu primer valor Nix a un servicio

Este recorrido conecta las piezas del repositorio. Son ejemplos originales de estudio que acompañan al curso; no son una solución oficial. Lee cada archivo antes de ejecutarlo, predice la salida y cambia una sola cosa cada vez. Reserva varias sesiones y guarda tus cambios con Git.

## 1. Prepara una terminal Linux

Necesitas Linux con Nix: la VM del curso sirve. VS Code en Windows permite leer y editar, pero abrir la carpeta no conecta automáticamente con Linux. Todos los comandos siguientes parten de la raíz `nix-estudio/`.

Si todavía no tienes el repositorio en esa máquina:

```bash
git clone https://github.com/matiassaitam/nix-estudio.git
cd nix-estudio
```

Si ya estás en tu copia local, omite el clon y el `cd`. Comprueba:

```bash
pwd
ls
nix --version
```

Debes ver `README.md`, `lecciones`, `nix` y `proyecto`. Conserva aparte el material original del curso. Si `nix` no existe, continúa en la VM preparada o consulta la [instalación oficial](https://nixos.org/download/); no pegues los comandos Linux en PowerShell.

## 2. Calcula datos antes de construir software

Abre [exercise.nix](../lecciones/01-lenguaje/exercise.nix). `let` define nombres locales; `in` indica el resultado. `{ … }` crea atributos, `[ … ]` crea listas y `host: …` define una función. `${…}` inserta valores en texto.

```bash
nix-instantiate --eval --strict --json lecciones/01-lenguaje/exercise.nix
```

Encontrarás `name: "aula"`, `port: 8080` y `url: "http://localhost:8080"`. La URL es texto: todavía no hay ningún servidor. Esta lección no necesita descargar Nixpkgs.

Cambia el puerto a `9090`, añade `urls = builtins.map makeUrl hosts;` al resultado y evalúa otra vez. Ambas direcciones deben usar el nuevo puerto. Compara con [solution.nix](../lecciones/01-lenguaje/solution.nix). Antes de avanzar, explica qué diferencia hay entre una función y el valor que devuelve.

## 3. Entra en un entorno y revisa sus entradas

Lee [la shell](../lecciones/02-shells/exercise.nix): `mkShell` selecciona herramientas; `shellHook` contiene Bash ejecutado al entrar.

```bash
nix-shell lecciones/02-shells/shell.nix
printf '%s\n' "$COURSE_NAME"
printf '%s\n' '{"curso":"Nix"}' | jq -r '.curso'
command -v jq
exit
```

Esperas `nix-estudio`, `Nix` y una ruta de `jq` normalmente dentro del store. El primer comando abre otra shell; `exit` cierra solo esa shell y devuelve al terminal anterior. Evita acumular varias shells: sal de cada una antes del siguiente bloque. Cuando usemos `--run`, la orden terminará y volverás automáticamente.

Añade `pkgs.hello` a `packages`, entra otra vez y ejecuta `hello`. Después sal. Cambiar el archivo no actualiza una shell que ya estaba abierta.

Ahora lee [source.nix](../nix/source.nix) y [pkgs.nix](../nix/pkgs.nix). El primero selecciona el commit `f68407657ad294471eb4b2e65d193df26edf729f`; el segundo importa esos paquetes para una plataforma. La primera descarga requiere conexión o caché. Se fija una revisión, aunque el archivo no incluye un hash adicional del archivo comprimido. Usamos comandos clásicos, sin flakes ni modo de evaluación pura. [Por qué fijar Nixpkgs](https://nix.dev/tutorials/first-steps/towards-reproducibility-pinning-nixpkgs).

## 4. Construye algo que puedas ejecutar

En [03-paquetes/exercise.nix](../lecciones/03-paquetes/exercise.nix), `writeShellApplication` produce `saluda`. `runtimeInputs` declara Coreutils porque el programa utiliza `wc`.

```bash
nix-build lecciones/03-paquetes/exercise.nix -o result-saluda
./result-saluda/bin/saluda "Ada Lovelace"
```

Resultado:

```text
Hola, Ada Lovelace
Palabras en el nombre: 2
```

`result-saluda` apunta a una salida en `/nix/store`. Una shell proporciona herramientas; una derivación describe cómo producir una salida. Añade un segundo argumento para imprimir un mensaje y reconstruye. La [solución](../lecciones/03-paquetes/solution.nix) incluye un valor por defecto.

Observa `''${1:-estudiante}`: el escape conserva una expansión de Bash dentro del texto Nix. Nix construye el script; Bash procesa los argumentos al ejecutarlo.

## 5. Sigue las referencias del store

```bash
nix-build lecciones/04-store/exercise.nix -o result-store
cat result-store/informe.txt
cat result-store/programa.txt
nix-store --query --references ./result-store
nix-store --query --requisites ./result-store
```

El informe dice `Informe creado dentro de una derivacion.`. El segundo archivo guarda la ruta de `hello`. Las referencias directas incluyen ese paquete; los requisitos muestran el *closure*, incluyendo dependencias transitivas.

En [la receta](../lecciones/04-store/exercise.nix), `$out` es la salida asignada por Nix. Guardar una referencia a un paquete permite conservar la relación con él. Una herramienta usada al construir no tiene por qué aparecer en el closure final.

El sandbox restringe qué recursos ve una construcción cuando está habilitado. El éxito de este ejemplo no verifica su activación: también puede reutilizarse una salida o una caché. Añade la ruta de `jq` como pide el ejercicio y comprueba cómo cambian las referencias.

## 6. Entiende por qué existe `self`

```bash
nix-instantiate --eval --strict lecciones/05-lib-y-puntos-fijos/datos.nix
nix-instantiate --eval --strict lecciones/05-lib-y-puntos-fijos/puntos-fijos.nix
```

El inventario suma `activeCores = 6`. Después compara los resultados: `original` tiene `web.example.org`; `updatedAfter` cambia el nombre a `docs` pero conserva esa dirección; `extended` produce `docs.example.org`.

Lee [puntos-fijos.nix](../lecciones/05-lib-y-puntos-fijos/puntos-fijos.nix). `lib.fix` conecta el argumento con el resultado final: las referencias internas pueden consultar la configuración extendida. Nix evalúa cuando necesita valores; no repite cálculos buscando convergencia. Una referencia circular sin valor concreto puede causar recursión infinita.

Completa [el ejercicio](../lecciones/05-lib-y-puntos-fijos/ejercicio.nix) sin escribir manualmente la URL. Debe producir `https://tienda.curso.test`.

## 7. Combina módulos

Lee [base.nix](../lecciones/06-modulos/base.nix), [host.nix](../lecciones/06-modulos/host.nix) y [eval.nix](../lecciones/06-modulos/eval.nix).

```bash
nix-instantiate --eval --strict lecciones/06-modulos/eval.nix
```

Obtendrás el nombre `aula`, el mensaje `Bienvenido a aula` y `tools = [ "git" ]`. `options` declara tipos; las definiciones aportan valores; `config` permite consultar el resultado combinado. Las herramientas son textos de una práctica, no programas instalados.

Completa [greeter.nix](../lecciones/06-modulos/greeter.nix) usando `lib.mkIf`: activado debe añadir `"saludo"` y sustituir el mensaje por `cfg.message`.

```bash
nix-instantiate --eval --strict lecciones/06-modulos/ejercicio.nix -A motd
nix-instantiate --eval --strict lecciones/06-modulos/checks.nix
```

Tras resolverlo, el mensaje será `"Hola, aula"`. Los checks de referencia devuelven `true`, incluso antes de completar tu ejercicio: verifican los ejemplos y la solución. Las listas se combinan; una definición normal del mensaje supera a `mkDefault`. [Tutorial de módulos](https://nix.dev/tutorials/module-system/a-basic-module/).

## 8. Construye la aplicación C y su página

Lee [main.c](../proyecto/main.c), [CMakeLists.txt](../proyecto/CMakeLists.txt) y [default.nix](../proyecto/default.nix). El programa usa zlib y genera HTML. CMake organiza compilación, instalación y pruebas; Nix registra sus dependencias.

```bash
nix-shell proyecto/shell.nix
cmake -S proyecto -B build/proyecto
cmake --build build/proyecto
ctest --test-dir build/proyecto --output-on-failure
./build/proyecto/nix-estudio --version
exit
```

CTest debe pasar y la versión será `nix-estudio 1.0.0`. Ahora construye resultados separados:

```bash
nix-build proyecto/default.nix -o result-app
nix-build proyecto/site.nix -o result-site
cat result-site/index.html
```

[site.nix](../proyecto/site.nix) ejecuta la aplicación durante la construcción y guarda `index.html`. Caddy servirá ese archivo; no ejecutará el programa C por cada petición.

Para verlo sin Docker ni otra VM:

```bash
nix-shell --run 'python3 -m http.server 8080 --bind 127.0.0.1 --directory result-site'
```

Déjalo ejecutándose. En otra terminal de **la misma máquina**, prueba `curl http://127.0.0.1:8080`. Si el laboratorio está en un servidor remoto, su `localhost` es ese servidor: abrir esa dirección en el navegador de Windows apunta a Windows. Recomiendo comprobar con `curl` dentro del laboratorio; una vista previa del editor o un túnel depende del entorno disponible. Pulsa `Ctrl+C` para detener el servidor.

## 9. Opcional: ejecuta el mismo sitio en Docker o NixOS

Elige una alternativa y deja libre el puerto 8080. Docker necesita un motor disponible:

```bash
nix-build proyecto/docker.nix -o result-image
docker load < result-image
docker run --rm --name nix-estudio -p 127.0.0.1:8080:80 nix-estudio:1.0.0
```

Detén el contenedor con `Ctrl+C`. La alternativa NixOS requiere ejecutar QEMU en Linux:

```bash
nix-build proyecto/vm.nix -o result-vm
./result-vm/bin/run-nix-estudio-vm
```

Espera al arranque y comprueba HTTP desde otra terminal del anfitrión. Para salir: `Ctrl+A`, suelta y pulsa `X`. Este invitado no requiere iniciar sesión para servir la página. Construirlo no activa su configuración en tu ordenador. Consulta las limitaciones en [el proyecto](../proyecto/README.md).

## 10. Evalúa un inventario y comprueba tu recorrido

Colmena permite coordinar configuraciones de varias máquinas. Aquí los destinos están desactivados. Ejecuta únicamente la evaluación; el cambio de directorio sucede dentro del proceso temporal:

```bash
nix-shell despliegue/shell.nix --run 'cd despliegue && colmena eval -E "{ nodes, lib, ... }: lib.mapAttrs (_: node: node.config.deployment.tags) nodes"'
```

Esperas `alpha: ["web"]`, `beta: ["db"]` y `gamma: ["web"]`. Lee [hive.nix](../despliegue/hive.nix), añade un nodo ficticio y vuelve a evaluar. No hace falta desplegar nada.

Finalmente, desde la raíz:

```bash
nix-shell --run 'bash scripts/check.sh --build'
```

Esto comprueba expresiones, construcciones y HTML, sin arrancar VM ni desplegar hosts. Si modificaste expectativas de referencia, revisa el error antes de restaurar tus cambios. Consulta [VALIDACION.md](VALIDACION.md) para distinguir lo revisado de lo ejecutado en el entorno de preparación. El objetivo es poder explicar el camino completo: datos → entorno → paquete → página → servicio.
