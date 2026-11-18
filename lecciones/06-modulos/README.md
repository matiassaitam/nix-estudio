# 06 · Módulos: opciones, valores y reglas de combinación

**Objetivo:** repartir una configuración entre archivos y entender cómo se obtiene el resultado final. Duración orientativa: 60 minutos. Necesitas funciones, conjuntos de atributos y la idea de evaluación perezosa de la lección 05.

Todos los comandos se ejecutan desde la raíz de `nix-estudio` en Linux con Nix. Trabajamos con una máquina ficticia descrita como datos. La lista `tools` contiene textos: esta lección no instala esos programas.

## 1. Distingue declarar una opción y darle un valor

En [base.nix](base.nix), `options.hostName` declara que existe una opción llamada `hostName`. Le asigna un tipo, una descripción y un valor por defecto. En [host.nix](host.nix), `hostName = "aula"` aporta un valor para esa opción.

Una declaración es parecida a un campo de un formulario: define qué se admite. Una definición es la respuesta que escribes en ese campo.

Un módulo puede ser un conjunto de atributos o una función que devuelve uno. En `{ lib, config, ... }:`, la función recibe un conjunto y extrae `lib` y `config`. Los puntos suspensivos permiten que le lleguen otros argumentos. [Introducción oficial a módulos](https://nix.dev/tutorials/module-system/a-basic-module/).

## 2. Sigue los tres archivos

| Archivo | Responsabilidad |
|---|---|
| [base.nix](base.nix) | Declara opciones y aporta un mensaje con prioridad de valor por defecto. |
| [host.nix](host.nix) | Importa el módulo base y define el nombre y herramientas del equipo. |
| [eval.nix](eval.nix) | Llama a `lib.evalModules` y devuelve su configuración calculada. |

~~~bash
nix-instantiate --eval --strict lecciones/06-modulos/eval.nix
~~~

Resultado esperado:

~~~nix
{
  hostName = "aula";
  motd = "Bienvenido a aula";
  tools = [ "git" ];
}
~~~

`imports` indica qué módulos incluir. No equivale al `import` del lenguaje: `import` evalúa un archivo; el sistema de módulos interpreta la lista `imports` y combina sus contribuciones.

El argumento `config` de `base.nix` permite leer el resultado final. Aunque el nombre se define en otro archivo, el mensaje usa `config.hostName` y obtiene `"aula"`. Esto conecta con los puntos fijos.

**Prueba:** cambia el nombre en `host.nix` a `"biblioteca"`, evalúa y predice el mensaje. Restaura `"aula"` antes de ejecutar las comprobaciones de referencia.

## 3. Aprende las reglas que importan

Las definiciones se combinan según sus tipos y prioridades. No se trata simplemente de que el último archivo gane.

- Las listas suelen reunir las contribuciones de varios módulos.
- Dos textos distintos con la misma prioridad producen un conflicto.
- Una definición normal supera a `lib.mkDefault`.
- `lib.mkForce` supera a las definiciones normales.
- `lib.mkIf` hace condicionales las definiciones dentro del sistema de módulos.

En `base.nix`, `config.motd = lib.mkDefault ...` permite que el módulo del saludo proponga después un mensaje normal. Si ambos fueran valores normales distintos, habría conflicto.

`mkIf` conserva las condiciones para que el sistema pueda procesarlas con las definiciones. Evita rodear el módulo completo con un `if config...` que necesite conocer ese mismo módulo antes de poder evaluarlo. [Reglas y evaluación del sistema de módulos](https://nix.dev/tutorials/module-system/deep-dive).

## 4. Ejercicio: activa un saludo

[greeter.nix](greeter.nix) ya declara dos opciones:

- `greeter.enable`: un booleano, desactivado por defecto.
- `greeter.message`: un texto.

`cfg` es solo un nombre local para `config.greeter`. Completa el bloque `config` para que, si `cfg.enable` es verdadero, aporte la herramienta `"saludo"` y use `cfg.message` como `motd`. Si está desactivado, no debe aportar ninguno de esos valores.

[ejercicio.nix](ejercicio.nix) conecta tus módulos y activa el saludo:

~~~bash
nix-instantiate --eval --strict lecciones/06-modulos/ejercicio.nix -A motd
~~~

Antes de resolverlo: `"Bienvenido a aula"`. Después: `"Hola, aula"`.

~~~bash
nix-instantiate --eval --strict --expr 'let c = import ./lecciones/06-modulos/ejercicio.nix; in builtins.elem "saludo" c.tools'
~~~

Antes devuelve `false`; después, `true`. La herramienta `"git"` también debe seguir presente.

Para probar la rama desactivada, cambia temporalmente `greeter.enable` a `false` en `ejercicio.nix`: debe volver el mensaje base y desaparecer `"saludo"`. Después restaura `true`.

## 5. Compara la solución y comprueba el comportamiento

Abre [la solución del módulo](soluciones/greeter.nix) después de intentarlo. Puedes evaluarla sin modificar tu ejercicio:

~~~bash
nix-instantiate --eval --strict lecciones/06-modulos/soluciones/eval.nix -A motd
nix-instantiate --eval --strict lecciones/06-modulos/checks.nix
~~~

Resultados: `"Hola, aula"` y `true`, respectivamente.

`checks.nix` comprueba la solución activada y desactivada, la unión de herramientas y el efecto de `mkForce` sobre la activación y sobre el mensaje. No depende de que hayas terminado el ejercicio. El orden de las herramientas no se usa como requisito: se comprueba su contenido.

**Pregunta final:** ¿por qué el módulo del saludo cambia el mensaje pero conserva Git? Porque la definición normal del texto supera al `mkDefault`, mientras que las dos contribuciones a la lista de herramientas se combinan.

## 6. Relación con NixOS

En esta práctica inventamos `hostName`, `tools` y `greeter`. NixOS aporta opciones reales como `networking.hostName`, `environment.systemPackages` y `services.openssh.enable`. El mecanismo de módulos es el mismo, pero sus resultados participan en la construcción del sistema operativo.

Conexión con el curso: [ejemplo 10-modules](https://gitlab.com/viperML/nixos-usweek/-/tree/main/10-modules) y [diapositivas](https://viperml.gitlab.io/nixos-usweek/overview). Este laboratorio es un ejemplo original de estudio, no una copia de la solución oficial.
