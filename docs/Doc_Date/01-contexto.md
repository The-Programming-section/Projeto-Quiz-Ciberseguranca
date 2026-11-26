# Passos 1 a 3 — Contexto, minimundo e requisitos

Marco M1. Copiem para `entregas/01-contexto.md`.

## 1. Introdução e contexto

O Tech Trivia deste grupo é o CyberQuiz, um quiz de afirmações sobre cibersegurança voltado à aprendizagem de estudantes e usuários da internet, com temas como senhas, injeção de SQL, XSS e criptografia. O jogador lê uma afirmação e marca Certo ou Errado. O objetivo deste banco de dados é armazenar e organizar perguntas, categorias, idiomas, fontes de referência, publicadores e alternativas, permitindo consultar o conteúdo necessário para apresentar o quiz, identificar a alternativa correta e fornecer explicações educativas com a fonte completa. As alternativas ficam em tabela própria, de modo que a inclusão de mais de duas opções no futuro não obrigue a alterar a estrutura da pergunta.

Escopo. Listem só o que o banco faz e o que fica de fora.

| O banco faz | O banco não faz |
| --- | --- |
| Armazena perguntas, com código estável (fact-001, ...), título, enunciado e explicação educativa. | Não desenha as telas nem controla a navegação do quiz. |
| Organiza perguntas por categoria, sem repetir o nome da categoria em cada pergunta. | Não traduz automaticamente os conteúdos. |
| Registra fontes com título, endereço eletrônico (URL), idioma e publicador responsável, cada URL uma única vez. | Não verifica automaticamente a confiabilidade ou a disponibilidade dos sites de referência. |
| Guarda as alternativas (hoje Certo e Errado) e indica qual é a correta de cada pergunta. | Não exige cadastro, senha ou sessão de jogadores. |
| Permite consultar perguntas, alternativas, explicações e fontes para a aplicação apresentar o quiz e corrigir as respostas. | Não armazena respostas dos jogadores, tentativas, histórico, ranking, pontuação ou resultados individuais nesta versão. |
| Mantém a integridade dos dados e dos relacionamentos (unicidade, obrigatoriedade e chaves estrangeiras). | Não calcula nem apresenta sozinho o resultado final; essa lógica pertence à aplicação. |

Usuários. Quem usa o sistema e o que cada um faz com os dados. Não criem tabela de usuário se nenhum requisito pedir cadastro, senha ou sessão.

| Usuário | O que faz |
| --- | --- |
| Jogador | Consulta, por meio da aplicação, as perguntas e as alternativas, escolhe Certo ou Errado e vê a explicação e a fonte. O placar é processado pela aplicação, sem armazenamento permanente no banco nesta versão. |
| Quem cadastra perguntas | Inclui categorias, publicadores, fontes e perguntas, indicando a alternativa correta de cada uma. Nesta versão não há tela de cadastro: esse cadastro é feito pelo script de carga (`05-dml-consultas.sql`), e os dados entram no banco por ele. Esse papel não implica uma entidade de usuário nem um requisito de autenticação. |

## 2. Minimundo

> Precisamos de um sistema de Quiz sobre Cibersegurança que permita cadastrar e disponibilizar perguntas sobre diferentes temas da área, como phishing, senhas, malware, privacidade e segurança em redes. Cada pergunta tem um código estável, como fact-001, um título, um enunciado e uma explicação, e o código original deve ser preservado. Cada pergunta pertence a uma só categoria, e a mesma categoria reúne várias perguntas; o nome de uma categoria é gravado uma única vez.

> Cada pergunta cita uma fonte de referência, que indica a origem ou a fundamentação da informação. A fonte tem título, endereço eletrônico e idioma, e o mesmo endereço pode amparar mais de uma pergunta sem ser cadastrado duas vezes. Cada fonte é publicada por um publicador, e o nome do publicador é gravado uma única vez, mesmo que ele publique várias fontes. O idioma é um conjunto controlado, com código e descrição, como pt e Português.

> Hoje cada afirmação é respondida com Certo ou Errado, e cada pergunta tem uma única alternativa correta. No futuro, o sistema poderá ter mais de duas alternativas, sem que seja preciso refazer a ficha da pergunta. As perguntas da carga devem entrar sem perda de nenhum campo, e o conteúdo do quiz poderá ser ampliado e atualizado ao longo do tempo.

## 3. Requisitos e regras de negócio

Cada RD01–RD11 e cada RA01–RA07 entra numa linha. Não deixem código de fora.

| Código | Texto do requisito | Tipo |
| --- | --- | --- |
| RD01 | Toda pergunta pertence a exatamente uma categoria. Não há duas categorias com o mesmo nome. | regra de negócio |
| RD02 | Toda pergunta cita exatamente uma fonte. A mesma fonte pode ser citada por várias perguntas. A URL é única. | regra de negócio |
| RD03 | Toda fonte tem exatamente um publicador. O nome do publicador é único. | regra de negócio |
| RD04 | Toda fonte tem um idioma de um conjunto controlado, com código e descrição. | regra de negócio |
| RD05 | As alternativas atuais são Certo e Errado, cada uma com rótulo e valor lógico. | regra de negócio |
| RD06 | Toda pergunta indica qual alternativa é a correta. | regra de negócio |
| RD07 | O banco aceita, no futuro, mais de duas alternativas sem refazer a estrutura da pergunta. | funcional |
| RD08 | O identificador original da pergunta (fact-001, fact-002, ...) é preservado. | regra de negócio |
| RD09 | Título, enunciado e explicação são obrigatórios. Enunciado e explicação podem ser longos. | regra de negócio |
| RD10 | Nome de categoria, nome de publicador e dados da fonte não se repetem em cada pergunta. | regra de negócio |
| RD11 | As perguntas da carga entram sem perda de campo. | funcional |
| RA01 | Listar as categorias em ordem alfabética, com a quantidade de perguntas. | funcional |
| RA02 | Sortear uma pergunta de qualquer categoria ou de uma categoria escolhida. | funcional |
| RA03 | Exibir título, enunciado e as alternativas. | funcional |
| RA04 | Dizer se a alternativa escolhida é a correta. | funcional |
| RA05 | Exibir a explicação e a fonte completa: título, publicador, URL e idioma. | funcional |
| RA06 | Listar os publicadores mais citados, com o número de perguntas. | funcional |
| RA07 | Listar as fontes citadas por mais de uma pergunta. | funcional |
| RNF01 | O SGBD é PostgreSQL. | não funcional |
| RNF02 | Integridade: nome de categoria único, URL única, textos da pergunta obrigatórios, toda chave estrangeira do núcleo preenchida. | não funcional |

Não funcional inclui, no mínimo, o SGBD e a integridade (o que não pode duplicar nem ficar nulo).
