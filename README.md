# Tech Trivia — Quiz de Cibersegurança

Projeto acadêmico 2026.2 de João, Maria e Felipe. HTML, CSS e JavaScript sem frameworks, API Node.js e PostgreSQL. Quiz Certo/Errado, categorias, explicações, fontes e estatísticas. Placar temporário no navegador; ranking e persistência de pontuações são objetivos históricos ainda não implementados.

## Estrutura

- frontend/: HTML, js/, css/ e img/.
- backend/src/: API, servidor local, configuração e certificado TLS.
- backend/teste/: testes locais e suíte original de integração.
- api/index.js: adaptador serverless Vercel.
- scripts/: build e executor da integração.
- database/: documentação e script de usuário PostgreSQL.
- docs/: documentação acadêmica, ZIP, DOCX e templates em doc_date/.
- docs/historico/: documentos e configurações anteriores.

## Instalação e execução

Requer Node.js 24.x e npm. Execute na raiz de Projeto-Quiz-Ciberseguranca, não no Career Dreamer externo:

~~~powershell
npm.cmd ci
Copy-Item backend/.env.example backend/.env
# Preencha backend/.env com as credenciais do banco local.
npm.cmd start
~~~

Abra http://localhost:3000. Use npm.cmd run dev para reinício automático. Em outros sistemas, use npm. Frontend e API compartilham a origem e usam /api em desenvolvimento e produção. Não abra o HTML via file://.

A configuração aceita BANCO_URL (prioridade), POSTGRES_URL ou BANCO_HOST, BANCO_PORTA, BANCO_NOME, BANCO_USUARIO e BANCO_SENHA. PORTA tem padrão 3000. BANCO_SSL=true ativa TLS; hosts Supabase usam backend/src/supabase-ca.crt com validação de cadeia e hostname. Variáveis do processo prevalecem sobre backend/.env. CORS_ORIGEM permite outra origem; o cliente padrão usa a mesma origem. Credenciais ficam exclusivamente no backend.

**Limitação:** entregas/ não existe. Os SQL em docs/doc_date/templates_origem/ contêm TODO e não criam o esquema e a massa usados pela API. Solicite as entregas completas à equipe para preparar um PostgreSQL local. Nenhum script de banco foi executado.

## Testes e build

~~~powershell
npm.cmd test
npm.cmd run build
# Apenas com PostgreSQL local descartável e a massa original carregada:
$env:BANCO_TESTE_URL = 'postgresql://usuario:senha@localhost:5432/tech_trivia_teste'
npm.cmd run test:integracao
~~~

Os testes locais usam banco simulado e HTTP real para verificar assets, API, configuração TLS e caminhos. O build copia apenas frontend/ para public/. A suíte original foi preservada integralmente e exige exatamente 3 categorias e 8 perguntas. O executor exige URL local explícita. A massa de produção mencionada no histórico (20 perguntas) é incompatível com essas expectativas.

## Deploy — somente após aprovação

Vercel: raiz deste repositório, Node 24.x, instalação npm ci, build npm run build e saída public/. O rewrite /api/:path* aponta para api/index.js; o bundle inclui o certificado TLS. Configure BANCO_URL ou POSTGRES_URL no ambiente autorizado, sem publicar .env.

Antes de publicar, confira projeto, ambiente, credenciais de menor privilégio e validade da CA. Em preview autorizado, valide /api/saude, categorias e uma rodada completa. Testes locais não comprovam empacotamento remoto, rede ou acesso ao pooler. O limitador em memória atua por instância serverless. Nenhum push, merge, deploy ou acesso ao banco remoto foi realizado.

## Documentação preservada

- [Documentação geral](docs/documentacao.md), [requisitos](docs/requisitos.md) e [arquitetura](docs/arquitetura.md).
- [Banco](docs/banco-de-dados.md), [casos de uso](docs/casos-de-uso.md) e [minimundo](docs/minimundo.md).
- [Conceitos](docs/conceitos-ciberseguranca.md) e [responsabilidades](docs/responsabilidades-banco-e-aplicacao.md).
- [Templates e orientação](docs/doc_date/templates_origem/).
- [Histórico Vercel](docs/INTEGRACAO-VERCEL.md), [diagnóstico](docs/diagnostico-organizacao.md) e [inventário](docs/inventario-movimentacao.md).

Documentos acadêmicos originais foram preservados integralmente, inclusive referências históricas a caminhos ausentes. Este README contém as instruções operacionais atuais.
