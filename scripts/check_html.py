#!/usr/bin/env python3
"""Comprueba el contenido y la estructura básica del sitio generado."""
from html.parser import HTMLParser
from pathlib import Path
import sys

class Page(HTMLParser):
    def __init__(self):
        super().__init__()
        self.tags = []
        self.text = []
    def handle_starttag(self, tag, attrs):
        self.tags.append(tag)
    def handle_data(self, data):
        self.text.append(data)

def main():
    if len(sys.argv) != 2:
        raise SystemExit('Uso: python3 scripts/check_html.py RUTA/index.html')
    html = Path(sys.argv[1]).read_text(encoding='utf-8')
    page = Page()
    page.feed(html)
    visible = ' '.join(page.text)
    assert html.lstrip().lower().startswith('<!doctype html>'), 'Falta doctype'
    assert all(tag in page.tags for tag in ('html', 'head', 'body', 'h1')), 'Falta estructura HTML'
    assert 'nix-estudio 1.0.0' in visible, 'Versión de la aplicación inesperada'
    assert 'zlib' in visible and 'correcta' in visible, 'No consta una inicialización correcta de zlib'
    print('HTML: OK')

if __name__ == '__main__':
    main()
