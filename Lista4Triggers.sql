--LISTA DE EXERCÍCIOS 4

--1 – Criar uma tabela pizza (id_pizza, nome, preco).

CREATE TABLE pizza2(
 id_pizza2 integer PRIMARY KEY,
 nome varchar,
 preco decimal(5,2));
 
 DROP TABLE pizza2;

--2 – Criar uma função para o evento UPDATE na tabela pizza que não permita a inserção de um preço
--menor que o preço atual. Essa função deve ser invocada por uma trigger, antes de realizar o UPDATE no
--novo valor da pizza. 

--Operadores OLD e NEW
--• OLD - registro em estado anterior ao evento
--• NEW - registro em estado posterior ao evento

CREATE FUNCTION verificaPreco()
RETURNS trigger AS $$
BEGIN
 IF NEW.preco <= OLD.preco THEN -- se o novo preço for menor= que o preco anterior
 RAISE EXCEPTION 'O preço deve ser maior que o anterior: % ', OLD.preco;  
END IF;                         --Quando acontece um erro do PostgreSql a exception associada é sinalizada automaticamente.
 RETURN NEW;                    -- Erro gerado pelo PostgreSQL. Uma exception é explicitamente sinalizada
END;							-- através do comando RAISE dentro do bloco PL/pgSQL
$$ language plpgsql	

CREATE TRIGGER garantirPreco -- Momento relativo ao evento
BEFORE UPDATE  -- Evento de disparo
ON pizza2 -- Momento relativo ao evento
FOR EACH ROW  -- Momento relativo ao evento
EXECUTE FUNCTION verificaPreco(); -- Momento relativo ao evento

DROP FUNCTION verificaPreco();

INSERT INTO pizza2 VALUES (1,'Margherita',25);
INSERT INTO pizza2 VALUES (2,'Calabresa',35);
SELECT * FROM pizza2;

-- Altera o preço da pizza de id 1 -> OK!
UPDATE pizza2 SET preco=30 WHERE id_pizza2=1;
SELECT * FROM pizza2;

-- Altera o preço da pizza de id 1 -> EXCEPTION!
UPDATE pizza2 SET preco=25 WHERE id_pizza2=1;

SELECT * FROM pizza2;

--3 – Criar uma tabela pizza_auditoria que possui as mesmas colunas da tabela pizza para armazenar
--os valores alterados e colunas adicionais como um número de identificação serial (id), o instante em que a
--autorização ocorreu (data_hora) e a operação realizada (operacao). 
--Essa tabela deve ser alimentada por
--uma trigger na tabela pizza que verifica cada operação e invoca uma função que realiza a inserção de
--dados na tabela pizza_auditoria.

CREATE TABLE pizza_auditoria2(
 id serial PRIMARY KEY,
 data_hora timestamp,
 operacao varchar,
 id_pizza integer,
 nome varchar,
 preco decimal(5,2));
 
 DROP TABLE pizza_auditoria2;
 
  --Criar a função a ser invocada
CREATE FUNCTION auditoria_pizza2() RETURNS trigger AS $$
BEGIN
 IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
INSERT INTO pizza_auditoria2 VALUES (DEFAULT,
now(), TG_OP, NEW.id_pizza, NEW.nome, NEW.preco);
RETURN NEW;
 ELSE
INSERT INTO pizza_auditoria2 VALUES (DEFAULT,
now(), TG_OP, OLD.id_pizza,OLD.nome,OLD.preco);
 RETURN OLD;
END IF;
END; $$ LANGUAGE plpgsql;

DROP FUNCTION auditoria_pizza2();

 --Criar a trigger que invocará a função
CREATE TRIGGER auditar_pizza2
 AFTER
INSERT OR UPDATE OR DELETE
 ON pizza2
FOR EACH ROW EXECUTE FUNCTION auditoria_pizza2(); -- nome da função

-- Teste de inserção e atualização
INSERT INTO pizza2 VALUES(3,'Calabresa',25);
UPDATE pizza2 SET preco=30 WHERE id_pizza=3;

SELECT * FROM pizza_auditoria;

UPDATE pizza SET preco=30 WHERE id_pizza=3;

SELECT * FROM pizza;
SELECT * FROM pizza_auditoria;

