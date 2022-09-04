--1- Fazer consultas nas tabelas e verificar o plano e custo de execução.
--2 Criar índices nas tabelas e realizar as mesmas consultas, verificando o novo plano e custo de execução.
--3 Criar uma consulta envolvendo pelo menos 4 tabelas da base de dados cepbr.
--4 Medir e registrar o custo da consulta.
--5 Otimizar a consulta, medir e registrar novamente o desempenho.
--6 Gravar as evidências (textual ou prints) e enviar para o Sigaa nesta tarefa em um arquivo compactado.

SELECT * FROM cepbr_estado;
SELECT * FROM cepbr_cidade;
SELECT * FROM cepbr_bairro;
SELECT * FROM cepbr_endereco;
SELECT * FROM cepbr_geo;
SELECT * FROM cepbr_faixa_cidades;
SELECT * FROM cepbr_faixa_bairros;

--Fazer consultas nas tabelas e verificar o plano e custo de execução.

--1) Qual a cidade de id 2174
EXPLAIN
SELECT * FROM cepbr_bairro WHERE id_cidade = 2174;
    --Tempo e custo de execução
--"Seq Scan on cepbr_bairro (cost=0.00..75.50 rows=71 width=23)"
--"Filter: (id_cidade = 2174)"

--Criar índices nas tabelas e realizar as mesmas consultas, verificando o novo plano e custo de execução.
CREATE INDEX "id_cidade" ON "cepbr_bairro" ("id_cidade");
    --Tempo e custo de execução
--"Bitmap Heap Scan on cepbr_bairro  (cost=4.83..32.72 rows=71 width=23)"
--"  Recheck Cond: (id_cidade = 2174)"
--"  ->  Bitmap Index Scan on id_cidade (cost=0.00..4.81 rows=71 width=0)"
--"  Index Cond: (id_cidade = 2174)"

--2) Qual o bairro/logradouro de id 1239
EXPLAIN
SELECT * FROM cepbr_endereco WHERE id_bairro = 1239;
--"Seq Scan on cepbr_endereco  (cost=0.00..107.50 rows=8 width=76)"
--"  Filter: (id_bairro = 1239)"

CREATE INDEX "id_bairro" ON "cepbr_endereco" ("id_bairro");
--"Bitmap Heap Scan on cepbr_endereco  (cost=4.34..26.33 rows=8 width=76)"
--"  Recheck Cond: (id_bairro = 1239)"
--"  ->  Bitmap Index Scan on id_bairro  (cost=0.00..4.34 rows=8 width=0)"
--"        Index Cond: (id_bairro = 1239)"

--3 Mostre o estado com código de ibge 42
EXPLAIN
SELECT * FROM cepbr_estado WHERE cod_ibge = '42';

CREATE INDEX "cod_ibge" ON "cepbr_estado" ("cod_ibge");
--"Seq Scan on cepbr_estado  (cost=0.00..1.34 rows=1 width=1548)"
--"  Filter: ((cod_ibge)::text = '42'::text)"


--4 Mostre a área de todas as cidades e as cidades ordenadas em ordem alfabética
EXPLAIN
SELECT cepbr_cidade.cidade, cepbr_cidade.area
FROM cepbr_cidade
ORDER BY cepbr_cidade.cidade;

CREATE INDEX "area" ON "cepbr_cidade" ("area");


--5 Mostre todas as cidades, e o seu logradouro, cidades ordenadas em ordem alfabética
EXPLAIN
SELECT cepbr_cidade.cidade, cepbr_endereco.logradouro
 FROM cepbr_endereco
  INNER JOIN cepbr_cidade
	ON cepbr_cidade.id_cidade = cepbr_endereco.id_cidade
	ORDER BY cepbr_cidade.cidade;
	

CREATE INDEX "logradouro" ON "cepbr_endereco" ("logradouro");

--Criar uma consulta envolvendo pelo menos 4 tabelas da base de dados cepbr.
	
--6) Mostre o id, nome da cidade, bairro, endereço e geo da cidade de São Paulo ?

-- select nas colunas, from especifica a primeira tabela que tem as chaves estrangeiras da relação, no caso tabela cepbr_endereco
EXPLAIN
SELECT cepbr_cidade.id_cidade, cepbr_cidade.cidade, cepbr_bairro.bairro, cepbr_endereco.logradouro, cepbr_geo.cep
FROM cepbr_endereco
   INNER JOIN cepbr_cidade --nome da tabela que está relacionada com a primeira / -- condição de junção
     ON cepbr_cidade.id_cidade = cepbr_endereco.id_cidade  --especifica como elas estão unidas - 
	--on, especifica na tabela 1 qual a coluna que equivale na tabela 2 / uma delas é chave primária, na outra é chave estrangeira
   INNER JOIN cepbr_bairro
     ON cepbr_bairro.id_bairro = cepbr_endereco.id_bairro -- chave primária da tabela bairro, é chave estrangeira na tabela endereço 
   INNER JOIN cepbr_geo
	 ON cepbr_geo.cep = cepbr_endereco.cep -- chave primária (cep) da tabela geo, é chave estrangeira na tabela endereço
	WHERE cepbr_cidade.cidade = 'São Paulo'
	ORDER BY cepbr_bairro.bairro;

  --consulta sem índice
--"Sort  (cost=124.92..124.95 rows=10 width=56)"
--"  Sort Key: cepbr_bairro.bairro"
--"  ->  Nested Loop  (cost=10.61..124.76 rows=10 width=56)"
--"        ->  Nested Loop  (cost=10.33..121.58 rows=10 width=56)"
--"              ->  Hash Join  (cost=10.05..118.29 rows=10 width=45)"
--"                    Hash Cond: (cepbr_endereco.id_cidade = cepbr_cidade.id_cidade)"
--"                    ->  Seq Scan on cepbr_endereco  (cost=0.00..95.00 rows=5000 width=32)"
--"                    ->  Hash  (cost=10.04..10.04 rows=1 width=17)"
--"                          ->  Seq Scan on cepbr_cidade  (cost=0.00..10.04 rows=1 width=17)"
--"                                Filter: ((cidade)::text = 'São Paulo'::text)"
--"              ->  Index Scan using cepbr_bairro_pkey on cepbr_bairro  (cost=0.28..0.33 rows=1 width=19)"
--"                    Index Cond: (id_bairro = cepbr_endereco.id_bairro)"
--"        ->  Index Only Scan using cepbr_geo_pkey on cepbr_geo  (cost=0.28..0.32 rows=1 width=9)"
--"              Index Cond: (cep = (cepbr_endereco.cep)::text)"

	
	--CREATE INDEX idx_nome ON tabela USING tipo_indice(coluna);
	CREATE INDEX "cidade" ON "cepbr_cidade" ("cidade");
	CREATE INDEX "id_endereco" ON cepbr_bairro ("id_bairro");
	CREATE INDEX "cep" ON "cepbr_geo" ("cep");
	
	--consulta com índice
--	"Sort  (cost=123.18..123.20 rows=10 width=56)"
--"  Sort Key: cepbr_bairro.bairro"
--"  ->  Nested Loop  (cost=8.87..123.01 rows=10 width=56)"
--"        ->  Nested Loop  (cost=8.58..119.83 rows=10 width=56)"
--"              ->  Hash Join  (cost=8.30..116.54 rows=10 width=45)"
--"                    Hash Cond: (cepbr_endereco.id_cidade = cepbr_cidade.id_cidade)"
--"                    ->  Seq Scan on cepbr_endereco  (cost=0.00..95.00 rows=5000 width=32)"
--"                    ->  Hash  (cost=8.29..8.29 rows=1 width=17)"
--"                          ->  Index Scan using cidade on cepbr_cidade  (cost=0.27..8.29 rows=1 width=17)"
--"                                Index Cond: ((cidade)::text = 'São Paulo'::text)"
--"              ->  Index Scan using id_endereco on cepbr_bairro  (cost=0.28..0.33 rows=1 width=19)"
--"                    Index Cond: (id_bairro = cepbr_endereco.id_bairro)"
--"        ->  Index Only Scan using cep on cepbr_geo  (cost=0.28..0.32 rows=1 width=9)"
--"              Index Cond: (cep = (cepbr_endereco.cep)::text)"

	
	--Para remover índices
	DROP INDEX "logradouro";
	DROP INDEX "cidade";
	DROP INDEX "id_endereco";
	DROP INDEX "cep";
	DROP INDEX "id_cidade";
	DROP INDEX "id_bairro";
	DROP INDEX "estado";
	DROP INDEX "area";
	DROP INDEX "cod_ibge";
	


