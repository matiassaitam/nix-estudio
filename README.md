# Nix: tu repositorio de estudio

Guía práctica en español para estudiar **NixOS: Reproducible, Declarative Software Development and Deployment** por tu cuenta. Incluye ejemplos originales, ejercicios, soluciones y un proyecto completo. No es una copia del repositorio oficial ni un solucionario publicado por los profesores.

**Empieza por el [walkthrough paso a paso](docs/WALKTHROUGH.md).** Si necesitas preparar el entorno, consulta [EMPEZAR.md](docs/EMPEZAR.md). En VS Code, `Ctrl+Shift+V` abre la vista previa de Markdown.

## Qué vas a construir

```text
Código C + zlib
      ├── shell.nix: herramientas para desarrollar
      └── default.nix: receta de construcción
                └── ejecutable → HTML
                                  ├── servidor en una VM NixOS
                                  └── imagen de contenedor
```

La idea que conecta todo es describir requisitos y configuración en archivos que puedas revisar y versionar. **Evaluar Nix, construir un paquete y activar un sistema son operaciones diferentes.**

## Ruta de estudio

| Orden | Lección | Qué debes poder explicar |
|---|---|---|
| 1 | [Lenguaje](lecciones/01-lenguaje/README.md) | `let`, `in`, `x:`, listas y atributos |
| 2 | [Shells](lecciones/02-shells/README.md) | Herramientas y `shellHook` |
| 3 | [Paquetes](lecciones/03-paquetes/README.md) | Desarrollar frente a construir un resultado |
| 4 | [Store y dependencias](lecciones/04-store/README.md) | Store paths, closures y sandbox |
| 5 | [Biblioteca y puntos fijos](lecciones/05-lib-y-puntos-fijos/README.md) | Por qué `self` refiere al resultado final |
| 6 | [Módulos](lecciones/06-modulos/README.md) | Opciones, tipos, prioridades y condiciones |
| 7 | [Proyecto completo](proyecto/README.md) | Desde código C hasta VM y contenedor |
| 8 | [Despliegue y Colmena](despliegue/README.md) | Construir, copiar, activar y revertir |
| 9 | [Ampliaciones](docs/AMPLIACIONES.md) | Python, parches, compilación cruzada, perfiles y CI |

Dedica una sesión a cada fila. Predice el resultado, ejecuta, modifica una cosa y explica qué cambia. Compara después tu intento con la solución.

## Cómo usarlo

**Windows + VS Code:** puedes leer y editar. Los comandos Nix y los scripts Bash se ejecutan en Linux con Nix, por ejemplo la VM del curso. Abrir esta carpeta en VS Code no la conecta automáticamente a la VM.

**VM del curso:** conserva su repositorio `~/nixos-usweek`. Este es material adicional. [EMPEZAR.md](docs/EMPEZAR.md) explica cómo llevarlo allí.

Desde la raíz de esta carpeta en una terminal Linux con Nix:

```bash
nix-shell
bash scripts/check.sh
```

La primera evaluación que usa Nixpkgs descarga una revisión fijada y requiere Internet o caché. La lección de lenguaje puro no requiere esa descarga. `nix-build` en la raíz construye la aplicación; sigue las instrucciones del [proyecto](proyecto/README.md) para ejecutarla.

## Validación y fuentes

- [Qué se ha comprobado y qué está pendiente](docs/VALIDACION.md)
- [Mapa del curso original y fuentes](docs/FUENTES-Y-MAPA.md)
- [Glosario y errores frecuentes](docs/GLOSARIO.md)
- [Dónde están las soluciones](docs/SOLUCIONES.md)
- [Plan de repaso](docs/PLAN.md)

Todos los ejemplos comparten [nix/source.nix](nix/source.nix), una revisión exacta de Nixpkgs. No hay publicación ni despliegue automático. El archivo de Colmena usa destinos desactivados para estudiar la configuración.
