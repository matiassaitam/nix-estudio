# 05 · La biblioteca y los puntos fijos

**Objetivo:** transformar datos y entender por qué una configuración puede referirse a su propio resultado. Duración orientativa: 45–60 minutos. Antes, completa las lecciones de sintaxis y paquetes.

Ejecuta los comandos desde la raíz de `nix-estudio`, en una terminal Linux con Nix. La primera evaluación puede descargar la revisión fijada de Nixpkgs. Esta lección solo calcula valores: no instala servicios.

## 1. Lee self: como una función

Ya conoces una función como esta:

~~~nix
x: x + 1
~~~

Recibe un argumento llamado `x`. Del mismo modo:

~~~nix
self: { name = "web"; }
~~~

recibe un argumento llamado `self` y devuelve un conjunto de atributos. `self` es un nombre elegido por quien escribe el programa: podrías llamarlo `final` o `resultado`. Los dos puntos separan el argumento del cuerpo de la función.

`lib` es la biblioteca de Nixpkgs. En los archivos de esta lección la importamos directamente desde la fuente fijada en `nix/source.nix`, sin cargar todos los paquetes.

## 2. Transforma un inventario

Abre [datos.nix](datos.nix). El inventario tiene tres máquinas, pero una está desactivada.

| Operación | Pregunta que responde |
|---|---|
| `filterAttrs` | ¿Qué máquinas cumplen una condición? |
| `mapAttrs` | ¿Qué valor calculo para cada nombre? |
| `mapAttrsToList` | ¿Cómo convierto el inventario en una lista? |
| `foldl'` | ¿Cómo acumulo todos los valores en un resultado? |

En `_name: machine: ...` hay dos funciones anidadas: una recibe el nombre y la siguiente recibe el valor. El prefijo `_` solo avisa al lector de que no usamos ese nombre.

~~~bash
nix-instantiate --eval --strict lecciones/05-lib-y-puntos-fijos/datos.nix
~~~

El resultado contiene:

~~~nix
{
  activeCores = 6;
  activeNames = [ "api" "web" ];
  inventory = [ "api:4" "batch:8" "web:2" ];
  workers = { api = 8; batch = 16; web = 4; };
}
~~~

`workers` incluye las tres máquinas porque transforma el inventario original. `activeCores` solo suma las activas porque recibe el inventario filtrado. Antes de ejecutar, explica por qué el total no es 14.

## 3. Compara dos formas de combinar conjuntos

~~~bash
nix-instantiate --eval --strict lecciones/05-lib-y-puntos-fijos/mezclas.nix
~~~

`shallow.server` solo contiene `name = "docs"`. `recursive.server` conserva `port = 8080` y cambia el nombre a `"docs"`.

El operador `//` sustituye atributos al primer nivel. `recursiveUpdate` entra en conjuntos anidados. Ninguno de ellos aplica las reglas de tipos y prioridades del sistema de módulos que veremos después.

## 4. Calcula un resultado que se refiere a sí mismo

Una función tiene un punto fijo cuando devuelve el mismo valor que recibe: `f(x) = x`. En este ejemplo ese valor es un conjunto con un nombre y una dirección:

~~~nix
lib.fix (self: {
  name = "web";
  fqdn = "${self.name}.example.org";
})
~~~

`lib.fix` pasa como `self` el propio resultado final de esa función. Al pedir `fqdn`, Nix necesita `self.name`; puede obtenerlo porque `name` tiene el valor concreto `"web"`. La interpolación produce `"web.example.org"`. FQDN significa nombre de dominio completo.

Nix evalúa los valores cuando hacen falta. No está ejecutando repetidamente la función hasta que los resultados se estabilizan. Una relación circular sin ningún valor que la resuelva, como `name = self.name`, provoca recursión infinita al intentar leer ese atributo. No incluimos esa expresión en los archivos ejecutables.

Abre [puntos-fijos.nix](puntos-fijos.nix) y ejecuta:

~~~bash
nix-instantiate --eval --strict lecciones/05-lib-y-puntos-fijos/puntos-fijos.nix
~~~

| Resultado | `name` | `fqdn` |
|---|---|---|
| `original` | `web` | `web.example.org` |
| `updatedAfter` | `docs` | `web.example.org` |
| `extended` | `docs` | `docs.example.org` |

La segunda fila es importante: cambiar `name` en un conjunto ya definido no redirige las referencias internas de `fqdn`. En la tercera fila, el cambio forma parte de la función a la que aplicamos `fix`. Por eso `self.name` consulta el nombre extendido. Esto explica la utilidad de mantener la configuración como una función antes de cerrarla con un punto fijo.

## 5. Ejercicio y solución

Edita únicamente el bloque marcado `TODO` en [ejercicio.nix](ejercicio.nix). Queremos `name = "tienda"` y `domain = "curso.test"`. No escribas manualmente `fqdn` ni `url`.

~~~bash
nix-instantiate --eval --strict lecciones/05-lib-y-puntos-fijos/ejercicio.nix -A url
~~~

Antes del cambio devuelve `"https://web.example.org"`. Después debe devolver `"https://tienda.curso.test"`.

Para comparar al terminar:

~~~bash
nix-instantiate --eval --strict lecciones/05-lib-y-puntos-fijos/soluciones/ejercicio.nix
~~~

La [solución](soluciones/ejercicio.nix) cambia solo dos atributos dentro de la función extendida.

## 6. Comprueba lo aprendido

~~~bash
nix-instantiate --eval --strict lecciones/05-lib-y-puntos-fijos/checks.nix
~~~

Resultado esperado: `true`. Estas comprobaciones validan los ejemplos y la solución de referencia; tu ejercicio se comprueba con el comando del apartado anterior.

Deberías poder explicar qué recibe `self`, por qué `//` pierde el puerto anidado y por qué las dos formas de cambiar `name` producen direcciones diferentes.

Referencia: [biblioteca de Nixpkgs y lib.fix](https://nixos.org/manual/nixpkgs/stable/#function-library-lib.fixedPoints.fix). Conexión con el curso: [diapositivas originales](https://viperml.gitlab.io/nixos-usweek/overview). Los ejemplos de esta carpeta son material de estudio original.
