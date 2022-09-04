--LISTA DE EXERCÍCIOS 3
--1 - Criar uma função que recebe dois valores inteiros (a e b) e retorna o resultado da multiplicação desses
--valores.

CREATE FUNCTION fn_mult(a int, b int) RETURNS int AS $$
DECLARE
 mult int = a * b;
BEGIN
 RETURN mult;
END; $$ LANGUAGE plpgsql;
SELECT fn_mult(5,2);

--2 - Criar uma função que receba a base e altura de um retângulo e tenha como saída sua área e perímetro.

CREATE FUNCTION fn_area_perimetro(IN base int, IN
altura int, OUT area int, OUT perimetro int) AS $$
BEGIN
 area := base*altura;
 perimetro := base * 2 + altura * 2;
END; $$ LANGUAGE plpgsql;
--Saída: (area,perimetro) 
SELECT fn_area_perimetro(5,10);

SELECT area, perimetro FROM fn_area_perimetro(5,10);

DROP FUNCTION fn_area_perimetro; --exclui função

--3 - Realizar uma consulta sobre o tipo record resultante da concatenação dos parâmetros da função
--anterior.

SELECT area, perimetro FROM fn_area_perimetro(5,10);


--4 - Crie uma função para determinar se um número é ímpar ou par.

CREATE FUNCTION fn_par_impar(x int)
RETURNS varchar(8) AS $$
BEGIN
 IF (X % 2 !=0) THEN
RETURN 'Ímpar';
 ELSE
 RETURN 'Par';
END IF;
END; 
$$ LANGUAGE plpgsql;

SELECT fn_par_impar(-3); -- Retorna 'Ímpar'

DROP FUNCTION fn_par_impar; --exclui função


--5 - Criar função para determinar se um triângulo é equilátero, isósceles ou escaleno.

CREATE FUNCTION fn_tipo_triangulo(A int, B int, C int)
RETURNS varchar(16) AS $$
BEGIN
 IF (A = B AND B = C) THEN
RETURN 'Equilátero';
 ELSIF (A = B OR B = C OR C = A) THEN
 RETURN 'Isósceles';
 ELSE
 RETURN 'Escaleno';
END IF;
END; $$ LANGUAGE plpgsql;

SELECT fn_tipo_triangulo(4,3,4);
-- Retorna 'Isósceles';

DROP FUNCTION fn_tipo_triangulo; --exclui função


-- 6 - Crie uma função para somar os números inteiros entre 1 e um número x.

CREATE FUNCTION fn_soma_ate(x int) RETURNS int AS $$
DECLARE
 soma int = 0;
BEGIN
FOR i IN 1..x LOOP
 soma:= soma + i;
END LOOP;
 RETURN soma;
END; $$ LANGUAGE plpgsql;
SELECT fn_soma_ate(5);
-- Retorna 15

DROP FUNCTION fn_soma_ate; --exclui função


--7 - Crie uma função para somar todos os valores de um array (parâmetro).

CREATE FUNCTION fn_soma_array(z int[]) RETURNS int AS $$
DECLARE

soma int = 0;
var int;

BEGIN
 FOREACH var IN ARRAY z LOOP
 soma:= soma + var;
 END LOOP;
RETURN soma;
END; $$ LANGUAGE plpgsql;

SELECT fn_soma_array(ARRAY[1,2,3,4]);
-- Retorna 10

DROP FUNCTION fn_soma_array; --exclui função

--8 - Criar uma tabela chamada "ingredientes" com os campos (id_ingrediente, nome, descricao). Criar uma
--função que insira x ingredientes na tabela.

CREATE TABLE ingrediente (
 id_ingrediente integer PRIMARY KEY,
 nome VARCHAR(64),
 descricao VARCHAR(64));

CREATE FUNCTION insereIngrediente(qtd int) RETURNS void
AS $$
DECLARE
 nome varchar(16); descricao text;
BEGIN
 FOR i IN 1..qtd LOOP
 nome = Concat('Ingrediente',i);
 descricao = Concat('Descrição: ', nome);
 
INSERT INTO ingrediente(id_ingrediente, nome, descricao)
VALUES (i, nome, descricao);
END LOOP;
END; $$ LANGUAGE plpgsql;

SELECT insereIngrediente(500);

SELECT * FROM ingrediente;

DROP FUNCTION insereIngrediente; --exclui função


--9 - Incrementar a função de verificação do triângulo, criando uma exceção para caso os lados do triângulo
--não formem um triângulo.
--(A condição de existência é que a soma de dois dos seus lados seja sempre maior que o valor do terceiro
--lado.)

CREATE FUNCTION fn_triangulo(A int, B int, C int)
RETURNS varchar(16) AS $$
BEGIN
IF (A >= B+C OR B >= A+B OR C >= A+B) THEN
RAISE EXCEPTION 'Os lados não formam um

triângulo: % % %',A,B,C;

ELSIF (A = B AND B = C)
THEN RETURN 'Equilátero';
ELSIF (A = B OR B = C OR C = A)
THEN RETURN 'Isósceles';
ELSE RETURN 'Escaleno';
END IF;
END; $$ LANGUAGE plpgsql;

SELECT fn_triangulo(4,3,9);
--ERROR: Os lados informados não formam um triângulo 4 3

DROP FUNCTION fn_triangulo; --exclui função


