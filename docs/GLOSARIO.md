# Glosario y errores frecuentes

| Término | Explicación |
|---|---|
| Nix | Lenguaje y herramientas para describir y construir software |
| Nixpkgs | Paquetes y biblioteca de funciones escritos en Nix |
| NixOS | Linux configurado mediante módulos de Nix |
| Evaluar | Calcular el valor de una expresión; no equivale a activar servicios |
| Derivación | Descripción de una construcción: entradas, entorno y builder |
| Store | Almacén de resultados, normalmente `/nix/store` |
| Closure | Un resultado y sus referencias transitivas en el store |
| Pin | Revisión concreta que fija qué definiciones de dependencias usamos |
| Sandbox | Restricción de lo que puede ver una construcción |
| Perfil | Conjunto seleccionado de paquetes accesible al usuario o sistema |
| Generación | Versión retenida de un perfil/configuración |
| Módulo | Contribución a una configuración con opciones, tipos y reglas de combinación |
| Punto fijo | Valor `x` que satisface `x = f x` |
| Activación | Aplicar al sistema una configuración ya construida |

## Tres distinciones que ahorran confusión

1. `nix-shell` proporciona herramientas. Una compilación manual dentro de ella depende también de lo que ejecutes. Una derivación registra la receta de construcción.
2. El hash de un store path habitual depende de la receta y sus entradas; no es simplemente el checksum del ejecutable resultante.
3. Una generación antigua permite volver a una configuración de sistema. No restaura el contenido anterior de una base de datos ni tus archivos borrados.

## Lenguaje

- `self:` define un argumento de función; `self` es un nombre convencional, no una palabra reservada.
- `${...}` dentro de una cadena interpola un valor. Fuera de una cadena tiene otros usos sintácticos; no es una instrucción de Bash.
- `{ ... }` construye un conjunto de atributos. `[ ... ]` construye una lista.
- `import ./archivo.nix` evalúa ese archivo. `imports = [ ./modulo.nix ];` es una opción del sistema de módulos: son mecanismos diferentes.
- `//` combina solo el primer nivel. `lib.recursiveUpdate` combina conjuntos anidados. El sistema de módulos añade tipos y reglas que no tienen esos operadores.

## Diagnóstico

| Error | Causa habitual | Próximo paso |
|---|---|---|
| `undefined variable 'lib'` | No has introducido la biblioteca en ese ámbito | Importa la biblioteca o pásala como argumento |
| `attribute ... missing` | El conjunto no tiene esa clave | Examina el valor con `:p` |
| `infinite recursion encountered` | Una definición necesita su propio valor sin base | Sigue qué atributo pide cuál; revisa condiciones sobre `config` |
| `option ... does not exist` | Error de nombre o falta importar una declaración | Revisa `options`, `imports` y el nombre exacto |
| Conflicting definitions | Dos módulos dan valores incompatibles | Decide si debe haber un valor por defecto, uno explícito o una prioridad especial |
| Builder failed | La receta se evaluó pero falló un paso de construcción | Lee las últimas líneas del log; identifica compilación, prueba o instalación |

Fuentes: [glosario oficial](https://nix.dev/manual/nix/latest/glossary), [lenguaje](https://nix.dev/tutorials/nix-language), [módulos](https://nix.dev/tutorials/module-system/a-basic-module/).
