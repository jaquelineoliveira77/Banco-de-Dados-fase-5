
--
-- Dumping data for table 'cepbr_bairro'
--

CREATE TABLE "cepbr_bairro" (
  "id_bairro" INTEGER NOT NULL, 
  "bairro" VARCHAR(255), 
  "id_cidade" INTEGER, 
  PRIMARY KEY ("id_bairro")
); 

--
-- Dumping data for table 'cepbr_cidade'
--

CREATE TABLE "cepbr_cidade" (
  "id_cidade" INTEGER NOT NULL, 
  "cidade" VARCHAR(255), 
  "uf" VARCHAR(255), 
  "cod_ibge" VARCHAR(255), 
  "area" VARCHAR(255), 
  PRIMARY KEY ("id_cidade")
);
--
-- Dumping data for table 'cepbr_endereco'
--

CREATE TABLE "cepbr_endereco" (
  "cep" VARCHAR(255) NOT NULL, 
  "logradouro" VARCHAR(255), 
  "tipo_logradouro" VARCHAR(255), 
  "complemento" VARCHAR(255), 
  "local" VARCHAR(255), 
  "id_cidade" INTEGER, 
  "id_bairro" INTEGER, 
  PRIMARY KEY ("cep")
);

--
-- Dumping data for table 'cepbr_estado'
--

CREATE TABLE "cepbr_estado" (
  "uf" VARCHAR(255) NOT NULL, 
  "estado" VARCHAR(255), 
  "cod_ibge" VARCHAR(255), 
  PRIMARY KEY ("uf")
);

--
-- Dumping data for table 'cepbr_faixa_bairros'
--

CREATE TABLE "cepbr_faixa_bairros" (
  "cep_inicial" VARCHAR(255), 
  "cep_final" VARCHAR(255), 
  "id_bairro" INTEGER, 
  "id_cidade" INTEGER, 
  "uf" VARCHAR(255)
);

--
-- Dumping data for table 'cepbr_faixa_cidades'
--

CREATE TABLE "cepbr_faixa_cidades" (
  "cep_inicial" VARCHAR(255), 
  "cep_final" VARCHAR(255), 
  "id_cidade" INTEGER, 
  "uf" VARCHAR(255)
);

--
-- Dumping data for table 'cepbr_geo'
--

CREATE TABLE "cepbr_geo" (
  "cep" VARCHAR(255) NOT NULL, 
  "latitude" VARCHAR(255), 
  "longitude" VARCHAR(255), 
  PRIMARY KEY ("cep")
);



