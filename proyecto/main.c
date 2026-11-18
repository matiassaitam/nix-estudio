#include <stdio.h>
#include <string.h>
#include <zlib.h>

#define APP_VERSION "1.0.0"

int main(int argc, char **argv) {
  if (argc == 2 && strcmp(argv[1], "--version") == 0) {
    printf("nix-estudio %s\n", APP_VERSION);
    return 0;
  }
  if (argc != 1) {
    fprintf(stderr, "Uso: %s [--version]\n", argv[0]);
    return 2;
  }

  /* Una dependencia real: el programa comprueba que puede usar zlib. */
  z_stream stream = {0};
  int status = deflateInit(&stream, Z_DEFAULT_COMPRESSION);
  if (status != Z_OK) {
    fprintf(stderr, "No se pudo inicializar zlib: %d\n", status);
    return 1;
  }
  /* No comprimimos datos: solo probamos la dependencia y liberamos recursos. */
  status = deflateEnd(&stream);
  if (status != Z_OK) {
    fprintf(stderr, "No se pudo finalizar zlib: %d\n", status);
    return 1;
  }

  /* Sin fecha, azar ni red: las mismas entradas producen el mismo HTML. */
  printf("<!doctype html>\n"
         "<html lang=\"es\">\n"
         "<head>\n"
         "  <meta charset=\"utf-8\">\n"
         "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n"
         "  <title>Mi proyecto con Nix</title>\n"
         "  <style>body{font:18px/1.6 system-ui,sans-serif;max-width:48rem;"
         "margin:4rem auto;padding:0 1rem;background:#f8fafc;color:#172033}"
         "code{background:#e2e8f0;padding:.1rem .3rem;border-radius:.2rem}"
         "h1{line-height:1.2;color:#245b91}</style>\n"
         "</head>\n"
         "<body>\n"
         "  <h1>Del código al servidor con Nix</h1>\n"
         "  <p>Esta página la genera un programa en C empaquetado con Nix.</p>\n"
         "  <ul>\n"
         "    <li>Aplicación: <code>nix-estudio %s</code></li>\n"
         "    <li>Dependencia zlib: <code>%s</code></li>\n"
         "    <li>Inicialización de zlib: <strong>correcta</strong></li>\n"
         "  </ul>\n"
         "  <p>El mismo sitio se sirve con Caddy en un contenedor o en una VM NixOS.</p>\n"
         "</body>\n"
         "</html>\n",
         APP_VERSION, zlibVersion());
  return ferror(stdout) ? 1 : 0;
}
