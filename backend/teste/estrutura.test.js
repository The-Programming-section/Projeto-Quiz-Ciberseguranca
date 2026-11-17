import assert from 'node:assert/strict';
import { test } from 'node:test';
import { readFile } from 'node:fs/promises';
import { criarAplicacao } from '../src/aplicacao.js';
import { lerConfiguracao } from '../src/configuracao.js';

test('frontend e API compartilham origem; assets e erros preservados', async () => {
  const banco = { consultar: async () => [], encerrar: async () => {} };
  const app = criarAplicacao({ servirFrontend: true, banco: {}, limiteRequisicoesPorMinuto: 1000 }, { banco, silencioso: true });
  try {
    await new Promise(r => app.servidor.listen(0, '127.0.0.1', r));
    const base = 'http://127.0.0.1:' + app.servidor.address().port;
    const html = await (await fetch(base)).text();
    for (const asset of ['css/estilo.css', 'js/main.js', 'js/api.js', 'img/logo.svg']) {
      assert.equal((await fetch(base + '/' + asset)).status, 200);
    }
    assert.ok(html.includes('js/main.js'));
    assert.match(await (await fetch(base + '/js/api.js')).text(), /API_URL = '\/api'/);
    assert.deepEqual(await (await fetch(base + '/api/saude')).json(), { status: 'ok' });
    assert.equal((await fetch(base + '/backend/.env')).status, 404);
    assert.equal((await fetch(base + '/api/inexistente')).status, 404);
    assert.equal((await fetch(base + '/api/resposta')).status, 405);
  } finally { await app.encerrar(); }
});

test('POSTGRES_URL e CA TLS preservados sem conex?o remota', () => {
  const anterior = { ...process.env };
  try {
    delete process.env.BANCO_URL;
    process.env.POSTGRES_URL = 'postgresql://teste:teste@teste.pooler.supabase.com:6543/teste?sslmode=require';
    process.env.VERCEL = '1';
    const config = lerConfiguracao();
    assert.equal(config.banco.ssl.rejectUnauthorized, true);
    assert.ok(config.banco.ssl.ca.some(ca => ca.includes('BEGIN CERTIFICATE')));
    assert.equal(new URL(config.banco.connectionString).searchParams.has('sslmode'), false);
    assert.equal(config.confiarNoProxy, true);
  } finally { for (const k of Object.keys(process.env)) if (!(k in anterior)) delete process.env[k]; Object.assign(process.env, anterior); }
});

test('manifesto, lockfile, build e Vercel apontam para arquivos existentes', async () => {
  const raiz = new URL('../../', import.meta.url);
  const json = async f => JSON.parse(await readFile(new URL(f, raiz)));
  const pkg = await json('package.json'), lock = await json('package-lock.json'), vercel = await json('vercel.json');
  assert.deepEqual(pkg.dependencies, lock.packages[''].dependencies);
  assert.deepEqual(pkg.engines, lock.packages[''].engines);
  await readFile(new URL(vercel.functions['api/index.js'].includeFiles, raiz));
  await import('../../api/index.js');
  await import('../../scripts/build.mjs');
  assert.equal(await readFile(new URL('frontend/js/api.js', raiz), 'utf8'), await readFile(new URL('public/js/api.js', raiz), 'utf8'));
});
