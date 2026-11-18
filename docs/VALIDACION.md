# Estado de validación

Revisión del material: 18 de noviembre de 2026.

## Comprobaciones realizadas

- Revisión del lenguaje Nix, referencias entre archivos, ejemplos de puntos fijos, opciones de módulos y separación entre evaluar, construir y activar.
- Comprobación de sintaxis Bash con `bash -n scripts/check.sh`.
- Comprobación de UTF-8 sin BOM, finales de línea LF, JSON de configuración, sintaxis Python y enlaces locales de Markdown.
- Comprobación de que las rutas literales de importación Nix apuntan a archivos existentes.
- Consulta de la revisión fijada de Nixpkgs y de las opciones de red de QEMU y usuarios utilizadas por la VM.

Estas comprobaciones estáticas no equivalen a ejecutar Nix.

## Pendiente de ejecutar en Linux

El entorno de preparación era Windows sin Nix disponible. No se han ejecutado aquí la evaluación Nix, la compilación C, CTest, la construcción de imágenes, Docker, QEMU ni Colmena. Las salidas indicadas en las guías son expectativas del ejemplo, no un registro de ejecución.

Desde la raíz, en Linux con Nix:

```bash
nix-shell --run 'bash scripts/check.sh'
nix-shell --run 'bash scripts/check.sh --build'
```

La primera orden analiza sintaxis, evalúa las soluciones de referencia y comprueba las recetas del proyecto. La segunda añade las construcciones de la aplicación, el sitio y el saludo. CTest se ejecuta dentro de la construcción del paquete.

Estos scripts no arrancan máquinas virtuales ni contenedores y no despliegan configuraciones. Las comprobaciones manuales de HTTP y Colmena están en el [walkthrough](WALKTHROUGH.md).

## Alcance de la publicación

Este repositorio contiene explicaciones y ejemplos originales. Enlaza el curso de referencia y no se presenta como su solución oficial. No incluye la captura del laboratorio, credenciales, cuentas de la VM, archivos personales ni destinos de despliegue reales.

Los ejemplos sirven para practicar. Los puertos publicados por Docker y QEMU se vinculan a `127.0.0.1`. Los destinos de Colmena están desactivados. No existe un flujo automático de despliegue.

Antes de publicar cambios propios, revisa `git diff` y evita añadir claves, tokens o contraseñas: un `.gitignore` no elimina un secreto ya versionado.
