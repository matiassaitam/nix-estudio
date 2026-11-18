# Plan de estudio

Cada sesión: lee → predice → ejecuta → cambia una cosa → explica el resultado → compara con la solución.

| Sesión | Material | Entregable personal |
|---|---|---|
| 1 | Lección 01 | Una expresión que devuelva un conjunto con tres atributos |
| 2 | Lección 02 y pin en nix/source.nix | Una shell con un programa añadido y un mensaje de entrada |
| 3 | Lecciones 03 y 04 | Un paquete propio y una explicación de su closure |
| 4 | Lección 05 | Explicar `self:` y por qué una extensión cambia un valor dependiente |
| 5 | Lección 06 | Resolver el módulo del saludo sin mirar la solución |
| 6 | Proyecto: C, CMake, default.nix, site.nix | Construir la aplicación y comprobar el HTML |
| 7 | Proyecto: configuración de VM y Docker | Encontrar dónde se decide contenido, servicio y puerto |
| 8 | Despliegue y ampliaciones | Explicar construcción, copia, activación y límites del rollback |

## Preguntas de autoevaluación

1. ¿Salir de `nix-shell` borra tus archivos? **No.** Se abandona esa sesión.
2. ¿Una receta que usa `<nixpkgs>` siempre selecciona la misma revisión? **No.** Depende de la configuración del entorno.
3. ¿El compilador tiene que viajar siempre junto al programa compilado? **No.** Las dependencias de construcción y ejecución pueden diferir.
4. ¿`lib.fix` itera hasta que el valor deja de cambiar? **No.** Establece una referencia recursiva evaluada de forma perezosa.
5. ¿Los módulos siempre aplican “gana el último archivo”? **No.** Intervienen el tipo y las prioridades.
6. ¿Construir una VM cambia la configuración del equipo anfitrión? **No.** Construir y activar son operaciones distintas.
7. ¿Un rollback del sistema revierte las filas de una base de datos? **No.** Los datos necesitan su propia estrategia.

## Proyecto de modificación

Cambia el texto visible de la página, reconstruye el sitio y explica qué archivos has modificado. Después cambia el puerto del anfitrión usado al arrancar el contenedor, sin cambiar el puerto interno. Por último, sigue la referencia del sitio hasta la configuración de la VM. Tu objetivo es poder explicar la misma aplicación a través de tres capas: programa, paquete y máquina.
