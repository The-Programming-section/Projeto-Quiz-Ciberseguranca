-- Passo 7 — Modelo físico
-- Equipe: CyberQuiz (Tech Trivia) — João Forastieri, Maria Eduarda Queiroz Corrêa e Felipe Carvalho Pereira
-- PostgreSQL. Por que este SGBD: é o SGBD exigido pela disciplina (RNF01) e oferece PK, FK, UNIQUE, CHECK e NOT NULL declarativos para proteger a integridade no próprio banco.
-- Contrato com Aplicativos para Web: os nomes abaixo são os acordados.
-- Banco vazio:
--   createdb tech_trivia
--   psql -d tech_trivia -v ON_ERROR_STOP=1 -f 04-ddl.sql
-- Só esquema e domínio fixo (idiomas, alternativas).
-- Categorias, publicadores, fontes e perguntas ficam no passo 8.

BEGIN;

-- Ordem de criação: primeiro as tabelas que ninguém referencia (idioma, categoria,
-- publicador, alternativa), depois fonte, e por último pergunta, que referencia as demais.

-- RD04 — conjunto controlado de idiomas. O código (pt, en) é identificador natural e estável.
CREATE TABLE idioma (
    id_idioma   VARCHAR(5)  NOT NULL,
    descricao   VARCHAR(40) NOT NULL,
    CONSTRAINT pk_idioma           PRIMARY KEY (id_idioma),
    CONSTRAINT uq_idioma_descricao UNIQUE (descricao),
    CONSTRAINT ck_idioma_codigo    CHECK (id_idioma = lower(btrim(id_idioma)) AND length(id_idioma) >= 2),
    CONSTRAINT ck_idioma_descricao CHECK (btrim(descricao) <> '')
);

-- RD01 — categoria com nome único.
CREATE TABLE categoria (
    id_categoria INTEGER      GENERATED ALWAYS AS IDENTITY,
    nome         VARCHAR(80)  NOT NULL,
    CONSTRAINT pk_categoria      PRIMARY KEY (id_categoria),
    CONSTRAINT uq_categoria_nome UNIQUE (nome),
    CONSTRAINT ck_categoria_nome CHECK (btrim(nome) <> '')
);

-- RD03 — publicador com nome único.
CREATE TABLE publicador (
    id_publicador INTEGER       GENERATED ALWAYS AS IDENTITY,
    nome          VARCHAR(120)  NOT NULL,
    CONSTRAINT pk_publicador      PRIMARY KEY (id_publicador),
    CONSTRAINT uq_publicador_nome UNIQUE (nome),
    CONSTRAINT ck_publicador_nome CHECK (btrim(nome) <> '')
);

-- RD05 e RD07 — alternativas como linhas (domínio), não como colunas fixas da pergunta.
CREATE TABLE alternativa (
    id_alternativa INTEGER      GENERATED ALWAYS AS IDENTITY,
    rotulo         VARCHAR(20)  NOT NULL,
    valor_logico   BOOLEAN      NOT NULL,
    CONSTRAINT pk_alternativa        PRIMARY KEY (id_alternativa),
    CONSTRAINT uq_alternativa_rotulo UNIQUE (rotulo),
    CONSTRAINT ck_alternativa_rotulo CHECK (btrim(rotulo) <> '')
);

-- RD02, RD03 e RD04 — fonte com URL única, um publicador e um idioma.
CREATE TABLE fonte (
    id_fonte       INTEGER       GENERATED ALWAYS AS IDENTITY,
    titulo         VARCHAR(200)  NOT NULL,
    url            VARCHAR(500)  NOT NULL,
    id_publicador  INTEGER       NOT NULL,
    id_idioma      VARCHAR(5)    NOT NULL,
    CONSTRAINT pk_fonte           PRIMARY KEY (id_fonte),
    CONSTRAINT uq_fonte_url       UNIQUE (url),
    CONSTRAINT ck_fonte_titulo    CHECK (btrim(titulo) <> ''),
    CONSTRAINT ck_fonte_url       CHECK (url ~ '^https?://'),
    CONSTRAINT fk_fonte_publicador FOREIGN KEY (id_publicador) REFERENCES publicador (id_publicador),
    CONSTRAINT fk_fonte_idioma     FOREIGN KEY (id_idioma)     REFERENCES idioma (id_idioma)
);

-- RD01, RD02, RD06, RD08 e RD09 — pergunta. O código original (fact-001, ...) é a chave primária.
CREATE TABLE pergunta (
    id_pergunta            VARCHAR(10)  NOT NULL,
    titulo                 VARCHAR(150) NOT NULL,
    enunciado              TEXT         NOT NULL,
    explicacao             TEXT         NOT NULL,
    id_categoria           INTEGER      NOT NULL,
    id_fonte               INTEGER      NOT NULL,
    id_alternativa_correta INTEGER      NOT NULL,
    CONSTRAINT pk_pergunta            PRIMARY KEY (id_pergunta),
    CONSTRAINT ck_pergunta_id         CHECK (id_pergunta ~ '^fact-[0-9]{3,}$'),
    CONSTRAINT ck_pergunta_titulo     CHECK (btrim(titulo) <> ''),
    CONSTRAINT ck_pergunta_enunciado  CHECK (btrim(enunciado) <> ''),
    CONSTRAINT ck_pergunta_explicacao CHECK (btrim(explicacao) <> ''),
    CONSTRAINT fk_pergunta_categoria   FOREIGN KEY (id_categoria)           REFERENCES categoria (id_categoria),
    CONSTRAINT fk_pergunta_fonte       FOREIGN KEY (id_fonte)               REFERENCES fonte (id_fonte),
    CONSTRAINT fk_pergunta_alternativa FOREIGN KEY (id_alternativa_correta) REFERENCES alternativa (id_alternativa)
);

-- Domínio fixo: idiomas e alternativas (RD04, RD05).
INSERT INTO idioma (id_idioma, descricao) VALUES
    ('pt', 'Português'),
    ('en', 'Inglês');

INSERT INTO alternativa (rotulo, valor_logico) VALUES
    ('Certo',  TRUE),
    ('Errado', FALSE);

COMMIT;
