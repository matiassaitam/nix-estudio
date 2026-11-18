# Proyecto completo: del código C a una página servida

Este es un proyecto original de estudio preparado para acompañar el curso. No es la solución oficial del profesor. Usa una aplicación pequeña para que puedas seguir todas las capas: código, dependencias, compilación, sitio estático, contenedor y máquina virtual.

El programa inicializa zlib, comprueba el resultado y genera HTML. La página no depende de la hora, de números aleatorios ni de una petición de red. `site.nix` ejecuta el programa una vez durante la construcción. Caddy sirve después ese archivo, tanto en Docker como en NixOS.

```text
main.c + CMakeLists.txt
        │
        ├── shell.nix → entorno para desarrollar
        │
        └── default.nix → paquete en /nix/store
                  │
                  └── site.nix → index.html
                            ├── docker.nix → imagen con Caddy
                            └── configuration.nix + vm.nix → VM NixOS con Caddy
```

## Qué leer en cada archivo

| Archivo | Qué aporta | Qué conviene observar |
|---|---|---|
| `main.c` | Programa C y salida HTML | Una dependencia real se incluye con `zlib.h` y se usa mediante `deflateInit`. |
| `CMakeLists.txt` | Compilación, instalación y pruebas | `ZLIB::ZLIB` conecta la biblioteca; el ejecutable se instala en `bin`. |
| `default.nix` | Paquete reproducible | CMake va en `nativeBuildInputs`; zlib va en `buildInputs`; `doCheck` ejecuta CTest. |
| `shell.nix` | Entorno de desarrollo | `inputsFrom` reutiliza las dependencias del paquete. Entrar en la shell no compila el programa. |
| `site.nix` | Sitio estático | La ruta `${app}` identifica exactamente el paquete usado para generar el HTML. |
| `docker.nix` | Imagen de contenedor | Nix incluye Caddy, la configuración y las dependencias del sitio sin un Dockerfile. |
| `configuration.nix` | Servicio y configuración NixOS | Declara Caddy y el puerto HTTP permitido dentro de la VM. |
| `vm.nix` | VM de prueba local | Añade QEMU sin interfaz gráfica y redirige `127.0.0.1:8080` al puerto 80 del invitado. |
| `../nix/pkgs.nix` y `../nix/source.nix` | Nixpkgs compartido | Todas las construcciones parten de la misma revisión fijada por el repositorio. |

## Preparación

Ejecuta los comandos de esta guía desde la raíz `nix-estudio/`, donde están `proyecto/` y `nix/`. Usa un entorno Linux con Nix instalado. En Windows, abre tu entorno Linux de WSL o una VM Linux; estos comandos no son comandos de PowerShell. La ruta de máquinas virtuales requiere un entorno Linux capaz de ejecutar QEMU; el acceso a virtualización por hardware acelera la VM y puede depender de la configuración de WSL o del hipervisor.

La primera construcción puede descargar herramientas y dependencias. Los siguientes pasos no instalan esta configuración en tu sistema anfitrión ni realizan un despliegue remoto.

## 1. Desarrollar y probar

```bash
nix-shell proyecto/shell.nix
cmake -S proyecto -B build/proyecto
cmake --build build/proyecto
ctest --test-dir build/proyecto --output-on-failure
./build/proyecto/nix-estudio --version
./build/proyecto/nix-estudio > build/proyecto/index.html
exit
```

La salida de `--version` es `nix-estudio 1.0.0`. Sin argumentos, el programa escribe una página HTML que muestra la versión de zlib y el resultado correcto de su inicialización. CTest incluye una comprobación de salida HTML y otra de versión. El directorio `build/` queda fuera de `proyecto/` para no mezclar archivos generados con el código fuente.

## 2. Construir el paquete y el sitio

```bash
nix-build proyecto/default.nix -o result-app
./result-app/bin/nix-estudio --version
nix-build proyecto/site.nix -o result-site
cat result-site/index.html
```

`result-app` y `result-site` son enlaces a resultados inmutables en `/nix/store`. El primero contiene el programa instalado en `bin/`; el segundo contiene `index.html`. La construcción del paquete también ejecuta las pruebas porque `doCheck = true`.

## 3. Servirlo con Docker

Necesitas un motor Docker disponible para cargar y ejecutar la imagen. Nix construye el archivo de imagen; Docker lo ejecuta.

```bash
nix-build proyecto/docker.nix -o result-image
docker load < result-image
docker run --rm --name nix-estudio -p 127.0.0.1:8080:80 nix-estudio:1.0.0
```

Abre <http://127.0.0.1:8080> en el anfitrión que ejecuta Docker. Si trabajas en un laboratorio remoto, comprueba desde otra terminal de ese laboratorio con `curl http://127.0.0.1:8080`; el localhost de tu Windows es otra máquina. La publicación queda limitada a la interfaz local del anfitrión. El comando permanece en primer plano mostrando los mensajes de Caddy; pulsa `Ctrl+C` para detenerlo. `--rm` elimina el contenedor al terminar, pero conserva la imagen cargada.

## 4. Servirlo con una VM NixOS

Detén antes el contenedor si está usando el puerto 8080.

```bash
nix-build proyecto/vm.nix -o result-vm
./result-vm/bin/run-nix-estudio-vm
```

Espera a que termine el arranque y consulta <http://127.0.0.1:8080> desde el anfitrión de QEMU (o usa `curl` desde otra terminal del laboratorio remoto). Verás la misma página. La VM arranca sin interfaz gráfica y no requiere iniciar sesión: el servicio Caddy se inicia automáticamente. La cuenta root está bloqueada y este proyecto no configura acceso SSH. El módulo exclusivo de la VM usa `users.allowNoPasswordLogin = true` para permitir construir este invitado sin una cuenta administrativa utilizable; esa opción omite la comprobación preventiva y no asigna una contraseña vacía.

Para salir de QEMU, pulsa `Ctrl+A`, suelta las teclas y pulsa `X`. El lanzador puede crear un archivo de disco `nix-estudio.qcow2` en el directorio actual. No uses `nixos-rebuild switch` para esta práctica; `nix-build proyecto/vm.nix` construye un invitado de prueba, no una nueva configuración de tu ordenador.

## Experimentos para entender el flujo

1. Cambia el título HTML en `main.c` y vuelve a construir `result-site`: observa cómo cambia su destino en `/nix/store`.
2. Cambia `APP_VERSION` y actualiza la expectativa de versión en `CMakeLists.txt`: comprueba por qué las pruebas forman parte de la construcción.
3. Añade una herramienta a `shell.nix`: observa que sirve para desarrollar, pero no se añade por ello a la imagen de Docker.
4. Sirve el mismo `site.nix` con Docker y con la VM: compara qué configuración aporta cada uno y qué resultado comparten.

## Estado de verificación

Los archivos se han revisado como material de estudio. En el entorno donde se preparó este proyecto no había Nix disponible, por lo que no se han ejecutado aquí las construcciones, CTest, Docker ni la VM. Los comandos anteriores son los pasos de verificación que debes ejecutar en tu entorno Linux con Nix.
