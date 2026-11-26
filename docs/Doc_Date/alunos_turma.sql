CREATE TABLE turma(
	codigo		SERIAL PRIMARY KEY,
	turma 		VARCHAR(50),
	descricao	VARCHAR(50)
);

CREATE TABLE alunos(
	rgm 		INTEGER PRIMARY KEY,
	nome		VARCHAR(50),
	telefone 	VARCHAR(11),
	cod_turma 	INTEGER,
	CONSTRAINT codturmafk FOREIGN KEY(cod_turma)
		REFERENCES turma(codigo)
);

INSERT INTO turma(turma, descricao) VALUES
('SisInfo',	'Sistemas de Informação'),
('TDS',		'Tecnólogo de Processamento de Dados'),
('CIECO', 	'Ciências da Computação');

INSERT INTO alunos(rgm, nome, telefone, cod_turma) VALUES
(27989, 	'Antônio José', 	'11-99998888', 01),
(899090, 	'Luiza Rossi', 		'11-99992222', 02),
(785214, 	'Renato Faria', 	'11-99997777', 03);

SELECT Rgm, Nome, Telefone, Cod_turma, Codigo, Turma, Descricao
	FROM alunos, turma
	WHERE cod_turma = codigo;

SELECT Rgm, Nome, Telefone, Cod_turma, Codigo, Turma, Descricao FROM Alunos, Turma;