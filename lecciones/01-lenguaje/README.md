# 01 · Leer el lenguaje Nix

Objetivo: convertir una expresión Nix en datos y reconocer variables, listas, atributos y funciones. Todavía no vamos a instalar ni compilar nada. Esta lección no necesita descargar Nixpkgs.

Ejecuta los comandos en la terminal Linux de la VM del curso, desde la raíz de este repositorio. Puedes leer y editar en VS Code de Windows; los comandos siguientes no son de PowerShell.

## Lee el ejemplo

Abre [exercise.nix](exercise.nix). El archivo completo es una expresión que devuelve un conjunto de atributos, parecido a un diccionario.

| Fragmento | Qué significa |
| --- | --- |
| `let … in …` | Define nombres locales antes de calcular el resultado. |
| `project = { … };` | Guarda un conjunto de atributos en `project`. |
| `name = "aula";` | Define texto; el punto y coma termina la asignación. |
| `port = 8080;` | Define un número. |
| `[ "localhost" "127.0.0.1" ]` | Una lista; sus elementos no llevan comas. |
| `host: …` | Una función con un argumento llamado `host`. |
| `${host}` | Inserta texto dentro de una cadena. |
| `toString project.port` | Convierte el número en texto antes de insertarlo. |
| `project.name` | Lee un atributo. |
| `inherit hosts;` | Abreviatura de `hosts = hosts;`. |
| `makeUrl "localhost"` | Llama a la función usando un espacio. |

El `:` de `host:` introduce el cuerpo de una función; no declara un tipo.

## Ejecuta

```bash
nix-instantiate --eval --strict --json lecciones/01-lenguaje/exercise.nix
```

Resultado esperado, sin que importen el orden de las claves o los espacios:

```json
{
  "enabled": true,
  "hosts": ["localhost", "127.0.0.1"],
  "name": "aula",
  "port": 8080,
  "url": "http://localhost:8080"
}
```

`--eval` evalúa la expresión. `--strict` exige también los valores anidados. `--json` facilita leer el resultado. No se crea un servidor web: `url` es solamente texto.

Prueba también:

```bash
nix-instantiate --eval --expr '(x: x * 2) 6'
nix-instantiate --eval --expr 'let name = "Ada"; in "Hola ${name}"'
```

Resultados: `12` y `"Hola Ada"`.

## Ejercicio

Modifica `exercise.nix`:

1. Cambia el puerto a `9090` en un único lugar.
2. Añade `urls`, una URL por elemento de `hosts`, usando `builtins.map makeUrl hosts`.
3. Añade `message` con el texto `"Proyecto aula"`, reutilizando `project.name`.

Vuelve a evaluar. Debes obtener `url = "http://localhost:9090"`, dos elementos en `urls` y el mensaje pedido.

Compara con [solution.nix](solution.nix):

```bash
nix-instantiate --eval --strict --json lecciones/01-lenguaje/solution.nix
```

Antes de continuar, explica la diferencia entre `project`, `project.name` y `makeUrl`.

Referencia: [tutorial oficial del lenguaje Nix](https://nix.dev/tutorials/nix-language).
