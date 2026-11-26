# Passos 5 e 6 — Modelo lógico, normalização e dicionário

Marco M2. A entrega do passo 5 é o modelo lógico: o desenho em `entregas/03-logico.pdf` (ou `.png`) e este texto em `entregas/03-logico.md`.

O desenho parte do modelo conceitual e mostra tabelas, colunas, chave primária e chaves estrangeiras. Não é outro DER. Se a normalização achar violação, corrijam o desenho e o texto.

## 5. Modelo lógico

| Relacionamento no DER | Cardinalidade | Vira | Onde fica a FK ou a tabela associativa |
| --- | --- | --- | --- |
| Pergunta pertence a Categoria | 1:N (categoria 1, pergunta N) | FK no lado N | `pergunta.id_categoria` → `categoria.id_categoria` |
| Pergunta cita Fonte | 1:N (fonte 1, pergunta N) | FK no lado N | `pergunta.id_fonte` → `fonte.id_fonte` |
| Fonte é publicada por Publicador | 1:N (publicador 1, fonte N) | FK no lado N | `fonte.id_publicador` → `publicador.id_publicador` |
| Fonte é escrita em Idioma | 1:N (idioma 1, fonte N) | FK no lado N | `fonte.id_idioma` → `idioma.id_idioma` |
| Pergunta tem como correta Alternativa | 1:N (alternativa 1, pergunta N) | FK no lado N | `pergunta.id_alternativa_correta` → `alternativa.id_alternativa` |

N:N vira tabela associativa. 1:N vira chave estrangeira no lado N. O recorte deste projeto não tem relacionamento N:N, então não há tabela associativa. A pergunta guarda as FK; categoria, fonte, publicador, idioma e alternativa não guardam lista de perguntas.

### Normalização

Dependências no formato `determinante → dependente`, com o requisito que sustenta.

| ID | Dependência | Requisito |
| --- | --- | --- |
| DF1 | id_pergunta → titulo, enunciado, explicacao, id_categoria, id_fonte, id_alternativa_correta | RD01, RD02, RD06, RD08, RD09 |
| DF2 | id_categoria → nome (e nome → id_categoria, pois o nome é único) | RD01 |
| DF3 | id_fonte → titulo, url, id_publicador, id_idioma (e url → id_fonte, pois a URL é única) | RD02, RD03, RD04 |
| DF4 | id_publicador → nome (e nome → id_publicador, pois o nome é único) | RD03 |
| DF5 | id_idioma → descricao | RD04 |
| DF6 | id_alternativa → rotulo, valor_logico | RD05 |

| Forma | Por que o esquema atende | Tabela em que isso aparece |
| --- | --- | --- |
| 1FN | Todos os valores são atômicos. Certo e Errado não ficam numa lista dentro da pergunta: são linhas de `alternativa`, e a pergunta guarda só o id da correta. Não há grupo multivalorado. | `pergunta` e `alternativa` |
| 2FN | Nenhuma chave primária é composta (todas têm uma só coluna), então não há dependência parcial a eliminar. | todas as tabelas |
| 3FN | Não há dependência transitiva. Em `pergunta`, o que descreve categoria, fonte, publicador, idioma e alternativa está em tabela própria: nome da categoria em `categoria`; título e URL da fonte em `fonte`; nome do publicador em `publicador`; descrição do idioma em `idioma`; rótulo e valor lógico em `alternativa`. A pergunta só guarda as chaves (DF1 não carrega DF2 a DF6). | `pergunta`, `fonte`, `categoria`, `publicador`, `idioma`, `alternativa` |

Se alguma forma falhar: nenhuma falhou. O esquema atende 1FN, 2FN e 3FN sem alteração do dicionário.

## 6. Dicionário de dados

Repitam o bloco para cada tabela. A descrição diz o que a coluna guarda, em uma linha.

### Tabela: idioma

| Coluna | Tipo e tamanho | Nulo | Restrição | Descrição |
| --- | --- | --- | --- | --- |
| id_idioma | VARCHAR(5) | NOT NULL | PK; CHECK (minúsculo, mínimo 2 caracteres) | Código do idioma (pt, en). Identificador natural e estável. |
| descricao | VARCHAR(40) | NOT NULL | UNIQUE; CHECK (não vazio) | Nome do idioma por extenso (Português, Inglês). |

### Tabela: categoria

| Coluna | Tipo e tamanho | Nulo | Restrição | Descrição |
| --- | --- | --- | --- | --- |
| id_categoria | INTEGER (identity) | NOT NULL | PK | Identificador da categoria. |
| nome | VARCHAR(80) | NOT NULL | UNIQUE; CHECK (não vazio) | Nome do tema, gravado uma só vez. |

### Tabela: publicador

| Coluna | Tipo e tamanho | Nulo | Restrição | Descrição |
| --- | --- | --- | --- | --- |
| id_publicador | INTEGER (identity) | NOT NULL | PK | Identificador do publicador. |
| nome | VARCHAR(120) | NOT NULL | UNIQUE; CHECK (não vazio) | Nome de quem publica a fonte, gravado uma só vez. |

### Tabela: alternativa

| Coluna | Tipo e tamanho | Nulo | Restrição | Descrição |
| --- | --- | --- | --- | --- |
| id_alternativa | INTEGER (identity) | NOT NULL | PK | Identificador da alternativa. |
| rotulo | VARCHAR(20) | NOT NULL | UNIQUE; CHECK (não vazio) | Texto exibido ao jogador (Certo, Errado). |
| valor_logico | BOOLEAN | NOT NULL | — | Valor lógico que a alternativa representa (Certo = verdadeiro, Errado = falso). |

### Tabela: fonte

| Coluna | Tipo e tamanho | Nulo | Restrição | Descrição |
| --- | --- | --- | --- | --- |
| id_fonte | INTEGER (identity) | NOT NULL | PK | Identificador da fonte. |
| titulo | VARCHAR(200) | NOT NULL | CHECK (não vazio) | Título da página ou do documento de referência. |
| url | VARCHAR(500) | NOT NULL | UNIQUE; CHECK (começa com http:// ou https://) | Endereço eletrônico da fonte, cadastrado uma só vez. |
| id_publicador | INTEGER | NOT NULL | FK → publicador.id_publicador | Publicador responsável pela fonte. |
| id_idioma | VARCHAR(5) | NOT NULL | FK → idioma.id_idioma | Idioma em que a fonte está escrita. |

### Tabela: pergunta

| Coluna | Tipo e tamanho | Nulo | Restrição | Descrição |
| --- | --- | --- | --- | --- |
| id_pergunta | VARCHAR(10) | NOT NULL | PK; CHECK (formato fact-NNN) | Código original da pergunta (fact-001, ...). Identificador natural, preservado (RD08). |
| titulo | VARCHAR(150) | NOT NULL | CHECK (não vazio) | Título curto da pergunta. |
| enunciado | TEXT | NOT NULL | CHECK (não vazio) | Afirmação apresentada ao jogador; texto longo. |
| explicacao | TEXT | NOT NULL | CHECK (não vazio) | Explicação educativa exibida após a resposta; texto longo. |
| id_categoria | INTEGER | NOT NULL | FK → categoria.id_categoria | Categoria da pergunta. |
| id_fonte | INTEGER | NOT NULL | FK → fonte.id_fonte | Fonte citada pela pergunta. |
| id_alternativa_correta | INTEGER | NOT NULL | FK → alternativa.id_alternativa | Alternativa que é a resposta correta da pergunta. |

Justificativa da exceção ao padrão `id_<tabela>`: em `idioma`, o código (pt, en) já é um identificador natural estável; em `pergunta`, o código fact-001 é o identificador original que o RD08 manda preservar. Em ambos os casos a coluna segue o nome `id_<tabela>`, mas guarda o valor natural em vez de um número gerado.
