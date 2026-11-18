# 03 · Construir un paquete que puedas ejecutar

Objetivo: convertir un script en una aplicación con dependencias declaradas. Una shell te da herramientas para trabajar; un paquete es un resultado construido y reutilizable.

Ejecuta los comandos en Linux desde la raíz del repositorio. No necesitas escribir C ni descargar fuentes de otra aplicación.

## Lee el ejemplo

Abre [exercise.nix](exercise.nix).

| Fragmento | Qué hace |
| --- | --- |
| `pkgs.writeShellApplication` | Genera una aplicación Bash y comprueba su script durante la construcción. |
| `name = "saluda";` | El ejecutable se llamará `saluda`. |
| `runtimeInputs = [ pkgs.coreutils ];` | Hace disponible `wc`, de Coreutils, al ejecutar el programa. |
| `text = '' … '';` | Guarda el cuerpo del programa como una cadena Nix multilínea. |
| `nombre="''${1:-estudiante}"` | Conserva la expansión Bash `${1:-estudiante}` dentro de la cadena Nix. |
| `wc -w` | Cuenta las palabras del nombre recibido. |

Hay dos momentos: Nix genera el script al construir el paquete; Bash interpreta `$nombre` y los argumentos cuando ejecutas `saluda`.

Una derivación describe un trabajo de construcción: entradas, instrucciones y salida. Aquí `writeShellApplication` prepara la derivación por ti. No se ejecuta el saludo mientras se evalúa el archivo Nix.

## Construye y ejecuta

```bash
nix-build lecciones/03-paquetes/exercise.nix -o result-saluda
./result-saluda/bin/saluda "Ada Lovelace"
```

Resultado:

```text
Hola, Ada Lovelace
Palabras en el nombre: 2
```

Sin argumentos:

```bash
./result-saluda/bin/saluda
```

Resultado:

```text
Hola, estudiante
Palabras en el nombre: 1
```

`result-saluda` es un enlace al resultado dentro de `/nix/store`:

```bash
readlink -f result-saluda
cat result-saluda/bin/saluda
```

El script generado incluye preparación añadida por Nixpkgs, además de tu código. Modifica la receta y vuelve a construir para cambiar la aplicación.

## Ejercicio

Añade un segundo argumento opcional: un mensaje. Si falta, utiliza `Buen trabajo`. Imprímelo al final con el prefijo `Mensaje: `.

Después de reconstruir:

```bash
./result-saluda/bin/saluda "Ada Lovelace" "Primera construccion lista"
```

Debes obtener:

```text
Hola, Ada Lovelace
Palabras en el nombre: 2
Mensaje: Primera construccion lista
```

Solución: [solution.nix](solution.nix).

```bash
nix-build lecciones/03-paquetes/solution.nix -o result-saluda-solucion
./result-saluda-solucion/bin/saluda Ada
```

Resultado: `Hola, Ada`, el recuento `1` y `Mensaje: Buen trabajo`.

Pregunta de repaso: ¿por qué Coreutils es una dependencia de ejecución aunque ya tengas `wc` en tu terminal?

Referencia: [scripts con Nixpkgs](https://nixos.org/manual/nixpkgs/stable/#trivial-builder-writeShellApplication).
