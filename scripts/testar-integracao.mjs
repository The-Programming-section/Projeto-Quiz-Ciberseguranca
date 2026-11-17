import { spawnSync } from 'node:child_process';
// A su?te existente exige a massa acad?mica espec?fica. N?o usa credenciais do .env.
if (!process.env.BANCO_TESTE_URL) {
  console.error('Defina BANCO_TESTE_URL para um PostgreSQL LOCAL e descart?vel com a massa de testes.');
  process.exit(1);
}
const url = new URL(process.env.BANCO_TESTE_URL);
if (!['localhost', '127.0.0.1', '[::1]'].includes(url.hostname)) {
  console.error('Testes de integra??o restritos ao PostgreSQL local.');
  process.exit(1);
}
const resultado = spawnSync(process.execPath, ['--test', 'backend/teste/api.test.js'], {
  cwd: new URL('../', import.meta.url), stdio: 'inherit',
  env: { ...process.env, BANCO_URL: url.toString(), POSTGRES_URL: '', BANCO_SSL: 'false' },
});
process.exit(resultado.status ?? 1);
