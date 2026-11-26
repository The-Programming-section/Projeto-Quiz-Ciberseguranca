-- Passo 9 — Testes das regras de negócio
-- Rode depois da carga. Cada bloco deve falhar.
-- Colem a mensagem de erro do PostgreSQL no comentário Resultado.
-- Nomes conforme o dicionário (03-logico.md).
-- Nota: as mensagens abaixo são as esperadas do PostgreSQL para as restrições nomeadas no
-- 04-ddl.sql (não havia PostgreSQL disponível na geração deste arquivo). Rodem cada
-- INSERT sozinho, no psql, e confiram/substituam pela saída real antes de entregar.
-- Os valores 1 e 'en' abaixo existem depois do 04 e do 05 (id_publicador 1 = CERT.br).

-- Regra: não existem duas categorias com o mesmo nome (RD01).
-- Resultado: ERROR:  duplicate key value violates unique constraint "uq_categoria_nome"
--            DETAIL:  Key (nome)=(Redes e criptografia) already exists.
-- INSERT INTO categoria (nome) VALUES ('Redes e criptografia');

-- Regra: não existem duas fontes com a mesma URL (RD02).
-- Resultado: ERROR:  duplicate key value violates unique constraint "uq_fonte_url"
--            DETAIL:  Key (url)=(https://cartilha.cert.br/senhas/) already exists.
-- INSERT INTO fonte (titulo, url, id_publicador, id_idioma)
-- VALUES ('outra', 'https://cartilha.cert.br/senhas/', 1, 'en');

-- Regra: pergunta sem título, enunciado ou explicação não entra (RD09).
-- Resultado: ERROR:  null value in column "titulo" of relation "pergunta" violates not-null constraint
--            DETAIL:  Failing row contains (fact-999, null, enunciado, explicacao, 1, 1, 1).
-- INSERT INTO pergunta (id_pergunta, titulo, enunciado, explicacao, id_categoria, id_fonte, id_alternativa_correta)
-- VALUES ('fact-999', NULL, 'enunciado', 'explicacao', 1, 1, 1);

-- Regra: não existem dois publicadores com o mesmo nome (RD03).
-- Resultado: ERROR:  duplicate key value violates unique constraint "uq_publicador_nome"
--            DETAIL:  Key (nome)=(CERT.br) already exists.
-- INSERT INTO publicador (nome) VALUES ('CERT.br');

-- Regra: o código original da pergunta não se repete (RD08).
-- Resultado: ERROR:  duplicate key value violates unique constraint "pk_pergunta"
--            DETAIL:  Key (id_pergunta)=(fact-001) already exists.
-- INSERT INTO pergunta (id_pergunta, titulo, enunciado, explicacao, id_categoria, id_fonte, id_alternativa_correta)
-- VALUES ('fact-001', 't', 'e', 'x', 1, 1, 1);

-- Regra: o código da pergunta segue o formato fact-NNN (RD08).
-- Resultado: ERROR:  new row for relation "pergunta" violates check constraint "ck_pergunta_id"
--            DETAIL:  Failing row contains (pergunta-1, t, e, x, 1, 1, 1).
-- INSERT INTO pergunta (id_pergunta, titulo, enunciado, explicacao, id_categoria, id_fonte, id_alternativa_correta)
-- VALUES ('pergunta-1', 't', 'e', 'x', 1, 1, 1);

-- Regra: toda pergunta aponta para uma categoria que existe (RD01, RNF02).
-- Resultado: ERROR:  insert or update on table "pergunta" violates foreign key constraint "fk_pergunta_categoria"
--            DETAIL:  Key (id_categoria)=(999) is not present in table "categoria".
-- INSERT INTO pergunta (id_pergunta, titulo, enunciado, explicacao, id_categoria, id_fonte, id_alternativa_correta)
-- VALUES ('fact-998', 't', 'e', 'x', 999, 1, 1);

-- Regra: enunciado em branco não entra (RD09).
-- Resultado: ERROR:  new row for relation "pergunta" violates check constraint "ck_pergunta_enunciado"
--            DETAIL:  Failing row contains (fact-997, t,    , x, 1, 1, 1).
-- INSERT INTO pergunta (id_pergunta, titulo, enunciado, explicacao, id_categoria, id_fonte, id_alternativa_correta)
-- VALUES ('fact-997', 't', '   ', 'x', 1, 1, 1);
