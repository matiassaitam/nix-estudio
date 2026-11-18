# 04 · Store, dependencias y sandbox

Objetivo: observar una salida en `/nix/store`, descubrir qué referencias conserva y entender el aislamiento de las construcciones.

Ejecuta los comandos en Linux desde la raíz del repositorio. No necesitas cambiar la configuración del sistema del laboratorio.

## Lee el ejemplo

[exercise.nix](exercise.nix) construye una carpeta con dos archivos de texto.

| Fragmento | Qué hace |
| --- | --- |
| `pkgs.runCommand "informe-store" { … } …` | Describe una construcción ejecutando un script. |
| `nativeBuildInputs` | Añade herramientas necesarias durante la construcción. |
| `$out` | Ruta de salida que Nix asigna a la construcción. |
| `mkdir -p "$out"` | Crea la salida; la receta debe producir su resultado declarado. |
| `${pkgs.hello}` | Inserta la ruta de `hello` y lo declara como entrada de la derivación. |
| `> "$out/programa.txt"` | Conserva esa ruta en el resultado. |

Los constructores de Nixpkgs proporcionan su entorno; no dependes del `mkdir` de tu sesión personal. Aquí declaramos Coreutils explícitamente para mostrar la relación entre herramienta y construcción.

## Construye e inspecciona

```bash
nix-build lecciones/04-store/exercise.nix -o result-store
cat result-store/informe.txt
cat result-store/programa.txt
readlink -f result-store
```

El primer archivo contiene:

```text
Informe creado dentro de una derivacion.
```

El segundo contiene una ruta parecida a `/nix/store/<hash>-hello-<version>/bin/hello`. Ejecuta el programa usando esa ruta:

```bash
"$(cat result-store/programa.txt)"
```

Debe aparecer el saludo de GNU Hello, posiblemente traducido según la VM.

## Sigue las dependencias

```bash
nix-store --query --references ./result-store
nix-store --query --requisites ./result-store
```

La primera orden muestra referencias directas de la salida. Debe incluir `hello` porque su ruta aparece en `programa.txt`. La segunda muestra su cierre de dependencias, o *closure*: la salida consultada y las rutas alcanzables siguiendo sus referencias.

Una dependencia utilizada al construir no tiene por qué ser una dependencia de ejecución. Un compilador puede ser necesario para crear un programa sin aparecer después en su closure. Lo que se conserva depende de las referencias del resultado.

El hash de la ruta de un paquete ordinario depende de la descripción de construcción y sus entradas; no es simplemente una suma del contenido final. Los detalles varían según el tipo de derivación.

## Qué aporta el sandbox

Cuando está habilitado, el sandbox restringe los recursos que puede ver el constructor. Ayuda a detectar dependencias que faltan: una biblioteca instalada casualmente en el ordenador del autor no debería convertirse en una entrada oculta.

Este ejemplo utiliza entradas declaradas y escribe en su salida. Construirlo con éxito no demuestra por sí solo que el sandbox esté activo: Nix también puede reutilizar una salida existente o descargarla de una caché. La política del sandbox depende de la instalación y de su administrador.

La shell de desarrollo anterior no es el sandbox de construcción. Tampoco confundas el sandbox con aislamiento de seguridad de una aplicación que ya está ejecutándose.

## Ejercicio

Añade un tercer archivo, `json-tool.txt`, que contenga la ruta `${pkgs.jq}/bin/jq`. Reconstruye e inspecciona las referencias directas: deben aparecer `hello` y `jq`.

Solución: [solution.nix](solution.nix).

```bash
nix-build lecciones/04-store/solution.nix -o result-store-solucion
nix-store --query --references ./result-store-solucion
"$(cat result-store-solucion/json-tool.txt)" --version
```

La última orden imprime una versión de `jq`. Los hashes y versiones los determina el Nixpkgs fijado y la plataforma.

Pregunta de repaso: si copias únicamente los archivos de texto a otra máquina, ¿por qué no basta para ejecutar el programa referenciado?

Referencias: [glosario de Nix](https://nix.dev/manual/nix/latest/glossary), [opción de sandbox](https://nix.dev/manual/nix/latest/command-ref/conf-file.html#conf-sandbox).
