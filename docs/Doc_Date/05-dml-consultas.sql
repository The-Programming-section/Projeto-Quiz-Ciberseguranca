-- Passo 8 — Carga de teste e consultas
-- Rode depois de 04-ddl.sql.
--   psql -d tech_trivia -v ON_ERROR_STOP=1 -f 05-dml-consultas.sql
-- Nomes conforme o dicionário (03-logico.md).
-- Nota sobre os resultados colados abaixo: foram conferidos com a mesma massa em um
-- ambiente SQLite equivalente, pois não havia PostgreSQL disponível na geração deste
-- arquivo. Antes de entregar, rodem no psql e substituam pelos resultados reais
-- (os de sorteio, RA02a e RA02b, mudam a cada execução).

BEGIN;

-- Massa mínima, nesta ordem: categoria, publicador, fonte, pergunta.
-- Cobre o mínimo do template:
--   8 perguntas com id fact-001 a fact-008
--   3 categorias, uma com 4 perguntas
--   2 publicadores, um com 3 fontes e outro com 2
--   3 URLs citadas por 2 perguntas cada
--   perguntas cuja correta é Certo (001, 002, 004, 005, 007) e Errado (003, 006, 008)
-- Quem cadastra perguntas faz isso por este script de carga (não há tela de cadastro).

INSERT INTO categoria (nome) VALUES
    ('Redes e criptografia'),
    ('Segurança de aplicações web'),
    ('Senhas e autenticação');

INSERT INTO publicador (nome) VALUES
    ('CERT.br'),
    ('OWASP Foundation');

INSERT INTO fonte (titulo, url, id_publicador, id_idioma) VALUES
    ('SQL Injection',
     'https://owasp.org/www-community/attacks/SQL_Injection',
     (SELECT id_publicador FROM publicador WHERE nome = 'OWASP Foundation'), 'en'),
    ('Cross Site Scripting (XSS)',
     'https://owasp.org/www-community/attacks/xss/',
     (SELECT id_publicador FROM publicador WHERE nome = 'OWASP Foundation'), 'en'),
    ('OWASP Top 10',
     'https://owasp.org/www-project-top-ten/',
     (SELECT id_publicador FROM publicador WHERE nome = 'OWASP Foundation'), 'en'),
    ('Cartilha de Segurança para Internet – Criptografia',
     'https://cartilha.cert.br/criptografia/',
     (SELECT id_publicador FROM publicador WHERE nome = 'CERT.br'), 'pt'),
    ('Cartilha de Segurança para Internet – Senhas',
     'https://cartilha.cert.br/senhas/',
     (SELECT id_publicador FROM publicador WHERE nome = 'CERT.br'), 'pt');

INSERT INTO pergunta
    (id_pergunta, titulo, enunciado, explicacao, id_categoria, id_fonte, id_alternativa_correta)
VALUES
    ('fact-001', 'SQL Injection',
     'SQL Injection é um ataque em que dados de entrada não tratados fazem o banco de dados executar comandos SQL que o desenvolvedor não previu.',
     'Certo. Na injeção de SQL, o atacante insere trechos de comando em campos de entrada. Se a aplicação concatena essa entrada à consulta sem tratamento, o banco executa o comando alterado e pode expor ou modificar dados.',
     (SELECT id_categoria FROM categoria WHERE nome = 'Segurança de aplicações web'),
     (SELECT id_fonte FROM fonte WHERE url = 'https://owasp.org/www-community/attacks/SQL_Injection'),
     (SELECT id_alternativa FROM alternativa WHERE rotulo = 'Certo')),

    ('fact-002', 'Consultas parametrizadas',
     'Consultas parametrizadas, que separam o comando SQL dos dados informados pelo usuário, ajudam a prevenir SQL Injection.',
     'Certo. Com consultas parametrizadas (prepared statements), o banco trata o valor informado sempre como dado, nunca como parte do comando, o que impede que a entrada altere a lógica da consulta.',
     (SELECT id_categoria FROM categoria WHERE nome = 'Segurança de aplicações web'),
     (SELECT id_fonte FROM fonte WHERE url = 'https://owasp.org/www-community/attacks/SQL_Injection'),
     (SELECT id_alternativa FROM alternativa WHERE rotulo = 'Certo')),

    ('fact-003', 'XSS no servidor de banco de dados',
     'O Cross-Site Scripting (XSS) é um ataque executado diretamente no servidor de banco de dados.',
     'Errado. No XSS, o script malicioso é injetado em uma página web e executado no navegador da vítima, não no servidor de banco de dados. Quem sofre o efeito é o usuário que abre a página afetada.',
     (SELECT id_categoria FROM categoria WHERE nome = 'Segurança de aplicações web'),
     (SELECT id_fonte FROM fonte WHERE url = 'https://owasp.org/www-community/attacks/xss/'),
     (SELECT id_alternativa FROM alternativa WHERE rotulo = 'Errado')),

    ('fact-004', 'OWASP Top 10',
     'O OWASP Top 10 é um documento de conscientização que lista os riscos mais críticos de segurança em aplicações web.',
     'Certo. O OWASP Top 10 reúne as categorias de risco mais críticas para aplicações web, com base em dados e no consenso da comunidade, e serve como ponto de partida para o desenvolvimento seguro.',
     (SELECT id_categoria FROM categoria WHERE nome = 'Segurança de aplicações web'),
     (SELECT id_fonte FROM fonte WHERE url = 'https://owasp.org/www-project-top-ten/'),
     (SELECT id_alternativa FROM alternativa WHERE rotulo = 'Certo')),

    ('fact-005', 'Criptografia de chave simétrica',
     'Na criptografia de chave simétrica, a mesma chave é usada para cifrar e para decifrar a informação.',
     'Certo. Na criptografia de chave simétrica (ou chave secreta), a mesma chave faz as duas operações e por isso precisa ser compartilhada de forma segura entre as partes. Já a criptografia de chaves assimétricas usa um par de chaves, uma pública e outra privada.',
     (SELECT id_categoria FROM categoria WHERE nome = 'Redes e criptografia'),
     (SELECT id_fonte FROM fonte WHERE url = 'https://cartilha.cert.br/criptografia/'),
     (SELECT id_alternativa FROM alternativa WHERE rotulo = 'Certo')),

    ('fact-006', 'Dados sensíveis sem criptografia',
     'Dados sensíveis podem trafegar sem criptografia em redes públicas, pois o risco de interceptação é desprezível.',
     'Errado. Em redes abertas, como o Wi-Fi público, o tráfego sem criptografia pode ser interceptado por terceiros. Por isso dados sensíveis devem ser protegidos em trânsito, por exemplo com HTTPS. O OWASP Top 10 trata esse problema como falhas criptográficas.',
     (SELECT id_categoria FROM categoria WHERE nome = 'Redes e criptografia'),
     (SELECT id_fonte FROM fonte WHERE url = 'https://owasp.org/www-project-top-ten/'),
     (SELECT id_alternativa FROM alternativa WHERE rotulo = 'Errado')),

    ('fact-007', 'Autenticação em dois fatores',
     'A verificação em duas etapas dificulta o acesso indevido a uma conta mesmo quando a senha é descoberta.',
     'Certo. Com a verificação em duas etapas, além da senha é preciso um segundo fator, como um código gerado no celular. Assim, quem descobrir apenas a senha não consegue entrar na conta.',
     (SELECT id_categoria FROM categoria WHERE nome = 'Senhas e autenticação'),
     (SELECT id_fonte FROM fonte WHERE url = 'https://cartilha.cert.br/senhas/'),
     (SELECT id_alternativa FROM alternativa WHERE rotulo = 'Certo')),

    ('fact-008', 'Reutilização de senhas',
     'Usar a mesma senha em vários serviços é uma boa prática, pois facilita lembrá-la e não aumenta o risco.',
     'Errado. Se uma senha reutilizada vazar em um serviço, atacantes podem testá-la em outros e acessar várias contas. O recomendado é usar uma senha diferente para cada serviço, com apoio de um gerenciador de senhas.',
     (SELECT id_categoria FROM categoria WHERE nome = 'Senhas e autenticação'),
     (SELECT id_fonte FROM fonte WHERE url = 'https://cartilha.cert.br/senhas/'),
     (SELECT id_alternativa FROM alternativa WHERE rotulo = 'Errado'));

COMMIT;

-- RA01. Categorias em ordem alfabética, com a quantidade de perguntas.
-- LEFT JOIN para que uma categoria ainda sem perguntas apareça com 0.
SELECT c.nome AS categoria,
       COUNT(p.id_pergunta) AS qtd_perguntas
  FROM categoria c
  LEFT JOIN pergunta p ON p.id_categoria = c.id_categoria
 GROUP BY c.id_categoria, c.nome
 ORDER BY c.nome;
-- Resultado:
--           categoria          | qtd_perguntas
-- -----------------------------+---------------
--  Redes e criptografia        |             2
--  Segurança de aplicações web |             4
--  Senhas e autenticação       |             2
-- (3 rows)

-- RA02a. Uma pergunta aleatória, de qualquer categoria.
SELECT p.id_pergunta, p.titulo, c.nome AS categoria
  FROM pergunta p
  JOIN categoria c ON c.id_categoria = p.id_categoria
 ORDER BY random()
 LIMIT 1;
-- Resultado (id sorteado; muda a cada execução):
--  id_pergunta |              titulo              |      categoria
-- -------------+----------------------------------+----------------------
--  fact-006    | Dados sensíveis sem criptografia | Redes e criptografia
-- (1 row)

-- RA02b. Uma pergunta aleatória de uma categoria recebida por parâmetro.
-- O parâmetro é a variável do psql "categoria".
\set categoria 'Redes e criptografia'
SELECT p.id_pergunta, p.titulo, c.nome AS categoria
  FROM pergunta p
  JOIN categoria c ON c.id_categoria = p.id_categoria
 WHERE c.nome = :'categoria'
 ORDER BY random()
 LIMIT 1;
-- Resultado (fact-005 ou fact-006; muda a cada execução):
--  id_pergunta |              titulo             |      categoria
-- -------------+---------------------------------+----------------------
--  fact-005    | Criptografia de chave simétrica | Redes e criptografia
-- (1 row)

-- RA03. Título, enunciado e alternativas de uma pergunta.
-- As alternativas (Certo e Errado) formam um domínio comum a todas as perguntas;
-- o valor lógico não é exibido, para não entregar o gabarito.
SELECT p.titulo, p.enunciado, a.id_alternativa, a.rotulo
  FROM pergunta p
 CROSS JOIN alternativa a
 WHERE p.id_pergunta = 'fact-001'
 ORDER BY a.id_alternativa;
-- Resultado:
--      titulo    |                                                                  enunciado                                                                  | id_alternativa | rotulo
-- ---------------+---------------------------------------------------------------------------------------------------------------------------------------------+----------------+--------
--  SQL Injection | SQL Injection é um ataque em que dados de entrada não tratados fazem o banco de dados executar comandos SQL que o desenvolvedor não previu. |              1 | Certo
--  SQL Injection | SQL Injection é um ataque em que dados de entrada não tratados fazem o banco de dados executar comandos SQL que o desenvolvedor não previu. |              2 | Errado
-- (2 rows)

-- RA04. Dada a pergunta e a alternativa escolhida, se acertou.
-- Prova 1: fact-001 tem como correta "Certo"; escolhida a alternativa 1 (Certo) -> acertou.
SELECT p.id_pergunta,
       a.rotulo AS escolhida,
       (p.id_alternativa_correta = a.id_alternativa) AS acertou
  FROM pergunta p
  JOIN alternativa a ON a.id_alternativa = 1
 WHERE p.id_pergunta = 'fact-001';
-- Resultado:
--  id_pergunta | escolhida | acertou
-- -------------+-----------+---------
--  fact-001    | Certo     | t
-- (1 row)

-- Prova 2: mesma pergunta; escolhida a alternativa 2 (Errado) -> errou.
SELECT p.id_pergunta,
       a.rotulo AS escolhida,
       (p.id_alternativa_correta = a.id_alternativa) AS acertou
  FROM pergunta p
  JOIN alternativa a ON a.id_alternativa = 2
 WHERE p.id_pergunta = 'fact-001';
-- Resultado:
--  id_pergunta | escolhida | acertou
-- -------------+-----------+---------
--  fact-001    | Errado    | f
-- (1 row)

-- Prova 3: fact-003 tem como correta "Errado"; escolhida a alternativa 2 -> acertou.
SELECT p.id_pergunta,
       a.rotulo AS escolhida,
       (p.id_alternativa_correta = a.id_alternativa) AS acertou
  FROM pergunta p
  JOIN alternativa a ON a.id_alternativa = 2
 WHERE p.id_pergunta = 'fact-003';
-- Resultado:
--  id_pergunta | escolhida | acertou
-- -------------+-----------+---------
--  fact-003    | Errado    | t
-- (1 row)

-- RA05. Explicação e fonte: título, publicador, URL e idioma.
SELECT p.explicacao,
       f.titulo    AS fonte,
       pu.nome     AS publicador,
       f.url,
       i.descricao AS idioma
  FROM pergunta p
  JOIN fonte f       ON f.id_fonte       = p.id_fonte
  JOIN publicador pu ON pu.id_publicador = f.id_publicador
  JOIN idioma i      ON i.id_idioma      = f.id_idioma
 WHERE p.id_pergunta = 'fact-008';
-- Resultado (formato expandido do psql, \x):
-- -[ RECORD 1 ]-----
-- explicacao | Errado. Se uma senha reutilizada vazar em um serviço, atacantes podem testá-la em outros e acessar várias contas. O recomendado é usar uma senha diferente para cada serviço, com apoio de um gerenciador de senhas.
-- fonte      | Cartilha de Segurança para Internet – Senhas
-- publicador | CERT.br
-- url        | https://cartilha.cert.br/senhas/
-- idioma     | Português

-- RA06. Publicadores mais citados, com o número de perguntas.
SELECT pu.nome AS publicador,
       COUNT(p.id_pergunta) AS qtd_perguntas
  FROM publicador pu
  JOIN fonte f    ON f.id_publicador = pu.id_publicador
  JOIN pergunta p ON p.id_fonte      = f.id_fonte
 GROUP BY pu.id_publicador, pu.nome
 ORDER BY qtd_perguntas DESC, pu.nome;
-- Resultado:
--     publicador    | qtd_perguntas
-- ------------------+---------------
--  OWASP Foundation |             5
--  CERT.br          |             3
-- (2 rows)

-- RA07. Fontes citadas por mais de uma pergunta.
SELECT f.titulo AS fonte,
       f.url,
       COUNT(p.id_pergunta) AS qtd_perguntas
  FROM fonte f
  JOIN pergunta p ON p.id_fonte = f.id_fonte
 GROUP BY f.id_fonte, f.titulo, f.url
HAVING COUNT(p.id_pergunta) > 1
 ORDER BY qtd_perguntas DESC, f.titulo;
-- Resultado:
--                     fonte                     |                          url                          | qtd_perguntas
-- ----------------------------------------------+-------------------------------------------------------+---------------
--  Cartilha de Segurança para Internet – Senhas | https://cartilha.cert.br/senhas/                      |             2
--  OWASP Top 10                                 | https://owasp.org/www-project-top-ten/                |             2
--  SQL Injection                                | https://owasp.org/www-community/attacks/SQL_Injection |             2
-- (3 rows)
