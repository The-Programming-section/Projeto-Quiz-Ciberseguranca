import { cp, mkdir } from 'node:fs/promises';
const origem = new URL('../frontend/', import.meta.url);
const destino = new URL('../public/', import.meta.url);
await mkdir(destino, { recursive: true });
await cp(origem, destino, { recursive: true });
