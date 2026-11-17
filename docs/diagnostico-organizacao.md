# Diagnostico e verificacao

Repositorio interno inicialmente limpo, branch chore/organizacao-repositorio. Main e repositorio externo Career Dreamer intocados.

Copias de aplicacao, banco, consultas, erros, limitador, rotas, utilitarios, validacao, testes, HTML, CSS, logo, main e manifesto backend equivalentes apos normalizar CRLF/LF e linhas finais. Apenas copias equivalentes removidas. Configuracao raiz preservada com POSTGRES_URL, proxy Vercel e CA TLS; frontend usa /api relativo. Configuracao antiga e manifesto/lockfile backend arquivados. Lockfile raiz mantido, sem atualizar dependencias.

Backend, frontend e database consolidados na raiz; documentos e doc_date em docs/; adaptador em api/; build em scripts/. Inventario por arquivo em inventario-movimentacao.md. Scripts npm, imports serverless e includeFiles corrigidos. Servidor local serve frontend na mesma origem. README atualizado.

Verificacao: npm ci --ignore-scripts instalou 13 pacotes, auditoria sem vulnerabilidades. npm test: 3 testes passaram (HTTP com banco simulado, TLS offline, caminhos e build). Runner bloqueado por EPERM no sandbox; repeticao autorizada passou. npm run build passou. git diff --check passou, com avisos LF/CRLF. ZIP e DOCX identicos a HEAD por git hash-object.

Integracao original nao executada: executor recusou ausencia de BANCO_TESTE_URL. Nao existe entregas/; SQL sao templates TODO. Suite exige 3 categorias/8 perguntas, enquanto historico de producao menciona 20. Sem massa completa nao ha validacao PostgreSQL. Rede, pooler, CA aceita e empacotamento Vercel precisam de preview autorizado. Limitador e pool por instancia serverless. Nenhum commit, push, merge, deploy ou acesso Supabase foi realizado.
