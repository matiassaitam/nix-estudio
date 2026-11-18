# 02 · Un entorno de desarrollo para el proyecto

Objetivo: disponer de herramientas concretas al entrar en una shell. La configuración registra qué necesitas para trabajar; todavía no describe cómo construir una aplicación.

Ejecuta los comandos en Linux, dentro de la VM y desde la raíz del repositorio. La primera ejecución puede descargar Nixpkgs y paquetes.

## Lee el ejemplo

Abre [exercise.nix](exercise.nix). [shell.nix](shell.nix) importa ese archivo para tener un punto de entrada reconocible.

| Fragmento | Qué hace |
| --- | --- |
| `import ../../nix/pkgs.nix {}` | Obtiene paquetes de la revisión fijada por este repositorio. |
| `pkgs.mkShell { … }` | Describe el entorno de desarrollo. |
| `packages = [ … ];` | Añade herramientas, aquí Coreutils y `jq`. |
| `shellHook = '' … '';` | Una cadena multilínea con comandos Bash ejecutados al entrar. |
| `export COURSE_NAME=…` | Define una variable disponible para los procesos de la shell. |

Fijar una revisión evita que `<nixpkgs>` dependa de la configuración personal de cada alumno. Lee [nix/pkgs.nix](../../nix/pkgs.nix) para ver cómo se importa.

## Ejecuta

```bash
nix-shell lecciones/02-shells/shell.nix
```

Verás `Entorno listo: nix-estudio`. Dentro de esa shell:

```bash
printf '%s\n' "$COURSE_NAME"
printf '%s\n' '{"curso":"Nix","leccion":2}' | jq -r '.curso'
command -v jq
exit
```

Los dos primeros resultados serán `nix-estudio` y `Nix`. La ruta de `jq` normalmente estará dentro de `/nix/store`. No tienes que memorizar el hash.

`exit` vuelve a tu terminal anterior. No borra archivos ni elimina automáticamente paquetes descargados. La shell normal puede conservar herramientas y variables del entorno exterior; no es una máquina virtual aislada.

Puedes ejecutar una orden y salir automáticamente:

```bash
nix-shell lecciones/02-shells/shell.nix --run 'jq --version'
```

Después del mensaje del hook, aparecerá la versión de `jq`.

## Ejercicio

Edita `exercise.nix`:

1. Añade `pkgs.hello` a `packages`.
2. Exporta `STUDY_MESSAGE="Aprendo practicando"` dentro del hook.
3. Imprime esa variable al entrar.

Sal y vuelve a entrar para aplicar los cambios. Comprueba:

```bash
hello
printf '%s\n' "$STUDY_MESSAGE"
```

`hello` imprimirá su saludo, posiblemente traducido según el idioma de la VM. La segunda orden debe imprimir `Aprendo practicando`.

Solución: [solution.nix](solution.nix). Pruébala sin modificar tu ejercicio:

```bash
nix-shell lecciones/02-shells/solution.nix --run 'printf "%s\n" "$STUDY_MESSAGE"'
```

Pregunta de repaso: ¿por qué `shellHook` contiene Bash, aunque el archivo exterior esté escrito en Nix?

Referencia: [entornos declarativos de desarrollo](https://nix.dev/tutorials/first-steps/declarative-shell).
