import { readFile } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
const raiz = fileURLToPath(new URL('../../frontend/', import.meta.url));
const tipos = { '.html': 'text/html; charset=utf-8', '.js': 'text/javascript; charset=utf-8', '.css': 'text/css; charset=utf-8', '.svg': 'image/svg+xml' };
export async function servirFrontend(req, res) {
  if (!['GET', 'HEAD'].includes(req.method)) { res.writeHead(405); res.end(); return; }
  try {
    const nome = decodeURIComponent(new URL(req.url, 'http://localhost').pathname);
    const arquivo = path.resolve(raiz, '.' + (nome === '/' ? '/index.html' : nome));
    const relativo = path.relative(raiz, arquivo);
    if (relativo.startsWith('..') || path.isAbsolute(relativo) || !tipos[path.extname(arquivo)]) { res.writeHead(404); res.end(); return; }
    const dados = await readFile(arquivo);
    res.writeHead(200, { 'Content-Type': tipos[path.extname(arquivo)], 'X-Content-Type-Options': 'nosniff' });
    res.end(req.method === 'HEAD' ? undefined : dados);
  } catch { res.writeHead(404); res.end(); }
}
