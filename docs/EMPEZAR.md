# Empieza aquí

Tu captura mostraba un editor en el navegador con Nix funcionando y el curso oficial en `~/nixos-usweek`. Esta carpeta `nix-estudio` añade material propio en español.

| Lugar | Uso |
|---|---|
| VS Code de Windows | Leer, editar y estudiar |
| Terminal Linux de la VM | Ejecutar Nix y construir para Linux |

Abrir VS Code local no sincroniza archivos con la VM. Los bloques `bash` se ejecutan en la terminal Linux; los bloques `nix` se escriben en archivos `.nix` o en `nix repl`.

## Llevar la carpeta a la VM

Se entrega también `nix-estudio.zip`. Si el editor web permite subir archivos, sube el ZIP a tu directorio personal y extráelo en una carpeta independiente. Con Python disponible:

```bash
python3 -m zipfile -e nix-estudio.zip .
cd nix-estudio
```

Si necesitas Python temporalmente:

```bash
nix-shell -p python3 --run 'python3 -m zipfile -e nix-estudio.zip .'
```

Si los profesores proporcionan SSH, también puedes usar `scp` con el host y usuario que te indiquen. La URL del navegador no demuestra que haya acceso SSH. Conserva el repositorio oficial sin sustituirlo.

## Primera práctica

Desde la raíz de `nix-estudio` en Linux:

```bash
nix --version
nix-instantiate --eval --strict lecciones/01-lenguaje/exercise.nix
```

Abre [la primera lección](../lecciones/01-lenguaje/README.md), predice qué devuelve y compara. Después consulta `solution.nix`.

## Tres comandos diferentes

- `nix repl`: intérprete del lenguaje. Prueba `1 + 2`, usa `:p` para imprimir un valor completo y `:q` para salir.
- `nix-shell lecciones/02-shells/shell.nix`: herramientas en una sesión. `exit` sale de esa sesión; tus archivos siguen ahí.
- `nix-build`: desde la raíz construye la aplicación y crea `result`. No activa una configuración del sistema.

## Si algo falla

| Síntoma | Qué revisar |
|---|---|
| `nix: command not found` | Que estés en la terminal de la VM con Nix |
| Primera descarga lenta | Nixpkgs y paquetes todavía no están en caché |
| `<nixpkgs>` no se encuentra | Este repo usa `nix/source.nix`; sigue los comandos concretos |
| Error de virtualización | Puedes evaluar y compilar; arrancar una VM depende del soporte del laboratorio |
| Código Nix sin colores en VS Code | Se puede leer igualmente; no se ha instalado ninguna extensión |

Antes de arrancar una VM o desplegar, lee las instrucciones de su carpeta. Para las primeras seis lecciones basta con evaluar y construir ejemplos locales.
