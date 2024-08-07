-- CASE SQL - JUMP START 2024 - TURMA 04
-- PROF. ERYCK DE NORONHA
-- MARCOS RODRIGUES DOS SANTOS GONÇALVES

SET NAMES utf8mb4;
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';
SET SQL_SAFE_UPDATES = 0;

GRANT FILE ON *.* TO 'root'@'localhost';
SET GLOBAL local_infile = 1;
SET GLOBAL sql_mode = '';


DROP SCHEMA IF EXISTS CASE_JUMP_4;
CREATE SCHEMA CASE_JUMP_4;
USE CASE_JUMP_4;

----------------------------------------------------------------------------------------------------
-- CRIAÇÃO DAS TABELAS E IMPORTAÇÃO DOS ARQUIVOS

-- TABELA CASESQL_names 
SELECT count(*) FROM casesql_names; 
-- 297.705 observações

CREATE TABLE CaseSQL_names (
	imdb_name_id VARCHAR (50),
    name VARCHAR (250),
    birth_name VARCHAR(400),
    height VARCHAR(150),
    bio TEXT,
    birth_details TEXT,
    date_of_birth VARCHAR(150),
    place_of_birth VARCHAR(250),
    death_details TEXT,
    date_of_death VARCHAR(100),
    place_of_death VARCHAR(150),
    reason_of_death TEXT,
    spouses_string TEXT,
    spouses INT,
    divorces INT,
    spouses_with_children INT,
    children INT
);

-- usado para carregar o arquivo na pasta local 
-- feito os devidos tratamentos para estruturar os dados e importar o arquivo

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CaseSQL_names.csv"
INTO TABLE CaseSQL_names
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- TABELA CASESQL_movies 
SELECT count(*) FROM casesql_movies; 
--  85.855 observações

CREATE TABLE CaseSQL_movies (
	imdb_title_id VARCHAR(50),
	title VARCHAR(250),
	original_title VARCHAR(250),
	year VARCHAR(50),
	date_published VARCHAR (50),
	genre TEXT,
	duration INT,
	country TEXT,
	language TEXT,
	director VARCHAR(250),
	writer VARCHAR(250),
	production_company VARCHAR(250),
	actors TEXT,
	description TEXT,
	avg_vote TEXT,
	votes INT,
	budget TEXT,
	usa_gross_income TEXT,
	worlwide_gross_income TEXT,
	metascore TEXT,
	reviews_from_users TEXT,
	reviews_from_critics TEXT	
);

-- usado para carregar o arquivo na pasta local 
-- feito os devidos tratamentos para estruturar os dados e importar o arquivo

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CaseSQL_movies.csv"
INTO TABLE CaseSQL_movies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- alterado as colunas que estavam em formato text para float
-- decidido alterar a tabela principal pois não foi possível criar como float diretamente no create table

ALTER TABLE CaseSQL_movies 
MODIFY duration float, 
MODIFY avg_vote float, 
MODIFY metascore float, 
MODIFY reviews_from_users float, 
MODIFY reviews_from_critics float;


-- TABELA CASESQL_ratings 
SELECT count(*) FROM casesql_ratings; 
-- 85.855 observações 

CREATE TABLE CaseSQL_ratings (
	imdb_title_id VARCHAR(50),
    weighted_average_vote FLOAT,
    total_votes INT,
    mean_vote FLOAT,
    median_vote FLOAT,
    votes_10 INT,
    votes_9 INT,
    votes_8 INT,
    votes_7 INT,
    votes_6 INT,
    votes_5 INT,
    votes_4 INT,
    votes_3 INT,
    votes_2 INT,
    votes_1 INT,
    allgenders_0age_avg_vote VARCHAR(50),
    allgenders_0age_votes VARCHAR(50),
    allgenders_18age_avg_vote VARCHAR(50),
    allgenders_18age_votes VARCHAR(50),
    allgenders_30age_avg_vote VARCHAR(50),
    allgenders_30age_votes VARCHAR(50),
    allgenders_45age_avg_vote VARCHAR(50),
    allgenders_45age_votes VARCHAR(50),
    males_allages_avg_vote VARCHAR(50),
    males_allages_votes VARCHAR(50),
    males_0age_avg_vote VARCHAR(50),
    males_0age_votes VARCHAR(50),
    males_18age_avg_vote VARCHAR(50),
    males_18age_votes VARCHAR(50),
    males_30age_avg_vote VARCHAR(50),
    males_30age_votes VARCHAR(50),
    males_45age_avg_vote VARCHAR(50),
    males_45age_votes VARCHAR(50),
    females_allages_avg_vote VARCHAR(50),
    females_allages_votes VARCHAR(50),
    females_0age_avg_vote VARCHAR(50),
    females_0age_votes VARCHAR(50),
    females_18age_avg_vote VARCHAR(50),
    females_18age_votes VARCHAR(50),
    females_30age_avg_vote VARCHAR(50),
    females_30age_votes VARCHAR(50),
    females_45age_avg_vote VARCHAR(50),
    females_45age_votes VARCHAR(50),
    top1000_voters_rating VARCHAR(50),
    top1000_voters_votes VARCHAR(50),
    us_voters_rating VARCHAR(50),
    us_voters_votes VARCHAR(50),
    non_us_voters_rating VARCHAR(50),
    non_us_voters_votes VARCHAR(50)
    );

-- usado para carregar o arquivo na pasta local 
-- feito os devidos tratamentos para estruturar os dados e importar o arquivo

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CaseSQL_ratings.csv"
INTO TABLE CaseSQL_ratings
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- TABELA CASESQL_title_principals 
SELECT count(*) FROM casesql_title_principals; 
-- 340.836 observações 

CREATE TABLE CaseSQL_title_principals (
	imdb_title_id VARCHAR(250),
    ordering varchar(250),
    imdb_name_id VARCHAR(250),
    category VARCHAR(250),
    job VARCHAR(250),
    characters VARCHAR(250)
);

-- usado para carregar o arquivo na pasta local 
-- feito os devidos tratamentos para estruturar os dados e importar o arquivo

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CaseSQL_title_principals.csv"
INTO TABLE CaseSQL_title_principals
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

----------------------------------------------------------------------------------------------------
-- CRIADO UMA VIEW PARA FACILITAR AS CONSULTAS NA TABELA MOVIES

-- coluna 'year' e 'date_published' possui uma das observações com a informação:'TV Movie 2019' (criado coluna 'ano_tratado')
-- coluna 'date_published' tem observações que possui apenas o ano, não está com a data completa (criado coluna 'data_completa')

CREATE OR REPLACE VIEW movies_tratados AS
	SELECT *,
		CASE
			WHEN year LIKE 'TV Movie 2019' THEN '2019'
			ELSE year
        END AS ano_tratado,
        CASE 
			WHEN CHAR_LENGTH(date_published) = 4 THEN concat(date_published, '-01-01')
            WHEN date_published = 'TV Movie 2019' THEN '2019-01-01'
            ELSE date_published
		END AS data_completa
	FROM casesql_movies;

-- visualização da tabela
SELECT * FROM movies_tratados;


-- criado uma view para trabalhar com os valores em dolar
-- usado o replace para tirar o $ e converter para float em uma nova coluna
-- filtrado apenas as colunas que tinham o $ no budget e no worlwide_gross_income

CREATE OR REPLACE VIEW valores_dolar AS(
	SELECT
		*,
		cast(replace(budget, '$','') as float) as budget_tratado,
		cast(replace(worlwide_gross_income,'$','') as float) as worlwide_gross_income_tratado
	FROM (SELECT
			*
		FROM movies_tratados
		WHERE budget LIKE '$%' and worlwide_gross_income LIKE '$%') AS sub
        );

-- visualização da tabela
SELECT * FROM valores_dolar;


----------------------------------------------------------------------------------------------------
-- EX.01
/*
Gerar um relatório contendo os 10 filmes mais lucrativos de todos os tempos, e identificar em qual faixa de idade/gênero eles foram mais bem avaliados
*/

CREATE OR REPLACE VIEW filmes_avaliacoes AS(
SELECT
	T1.imdb_title_id,
    T1.title,
    T1.original_title,
    T1.budget_tratado,
    T1.worlwide_gross_income_tratado,
    (T1.worlwide_gross_income_tratado - T1.budget_tratado) AS lucro,
    T2.weighted_average_vote,
    T2.allgenders_0age_avg_vote,
    T2.allgenders_18age_avg_vote,
    T2.allgenders_30age_avg_vote,
    T2.allgenders_45age_avg_vote,
    T2.males_allages_avg_vote,
    T2.males_0age_avg_vote,
    T2.males_18age_avg_vote,
    T2.males_30age_avg_vote,
    T2.males_45age_avg_vote,
    T2.females_allages_avg_vote,
    T2.females_0age_avg_vote,
    T2.females_18age_avg_vote,
    T2.females_30age_avg_vote,
    T2.females_45age_avg_vote
FROM valores_dolar T1
	INNER JOIN casesql_ratings T2
		ON T1.imdb_title_id = T2.imdb_title_id
);

WITH top_10_filmes AS(
	SELECT
		*
	FROM (SELECT 
			*,
            row_number() over(order by lucro desc) as row_num
		 FROM filmes_avaliacoes) as sub
	WHERE row_num <=10
)
SELECT
	imdb_title_id,
    title,
    lucro,
    CASE
		WHEN males_18age_avg_vote >= males_30age_avg_vote and males_18age_avg_vote >= males_45age_avg_vote THEN '18_anos'
        WHEN males_30age_avg_vote >= males_18age_avg_vote and males_30age_avg_vote >= males_45age_avg_vote THEN '30_anos'
        ELSE '45_anos'
END AS Masculino_idade,
	greatest(males_18age_avg_vote, males_30age_avg_vote, males_45age_avg_vote) as maior_voto_masculino,
CASE
		WHEN females_18age_avg_vote >= females_30age_avg_vote and females_18age_avg_vote >= females_45age_avg_vote THEN '18_anos'
        WHEN females_30age_avg_vote >= females_18age_avg_vote and females_30age_avg_vote >= females_45age_avg_vote THEN '30_anos'
        ELSE '45_anos'
END AS Feminino_idade,
    greatest(females_18age_avg_vote,females_30age_avg_vote, females_45age_avg_vote) as maior_voto_feminino
FROM top_10_filmes;

--------------------------------------------------------------------------------------------
-- EX.02
/*
Quais os gêneros que mais aparecem entre os Top 10 filmes mais bem avaliados de cada ano, nos últimos 10 anos.
*/

-- criado um View para adicionar uma coluna com a marcação da classificação para cada avaliação

-- filtrado apenas os ultimos 10 anos
CREATE OR REPLACE VIEW classificacao_avg_vote AS (
	SELECT
		title,
		genre,
		avg_vote,
		ano_tratado,
		row_number() over(partition by ano_tratado order by avg_vote desc) AS row_num
	FROM movies_tratados
    WHERE (ano_tratado) >= (YEAR(current_date()) - 10));

SELECT * FROM classificacao_avg_vote;

-- filtrando os top filmes
SELECT
	title,
	genre,
	avg_vote,
	ano_tratado,
	row_num
FROM classificacao_avg_vote
WHERE row_num <=10;

-- fazendo a contagem dos generos para cada ano e criando uma classificação de ranking
SELECT
	genre,
	count(genre) as contagem_genero,
	ano_tratado,
    row_number() over(partition by ano_tratado order by count(genre) desc) as row_num
FROM classificacao_avg_vote
WHERE row_num <=10
GROUP BY ano_tratado, genre
ORDER BY ano_tratado,count(genre) desc;

-- feito a contagem do genero que aparece mais de 1 vez e ordenado por ano:
SELECT 
	genre,
    contagem_genero,
    ano_tratado as ano
FROM (SELECT
		genre,
		count(genre) as contagem_genero,
		ano_tratado,
		row_number() over(partition by ano_tratado order by count(genre) desc) as row_num
	FROM classificacao_avg_vote
	WHERE row_num <=10
	GROUP BY ano_tratado, genre
	ORDER BY ano_tratado,count(genre) desc) AS sub
WHERE contagem_genero >1
ORDER BY ano_tratado;

-- verificando de modo geral nos 10 anos, qual genero mais apareceu entre os filmes top 10
SELECT
	genre,
	count(genre) as contagem_genero
FROM classificacao_avg_vote
WHERE row_num <=10
GROUP BY genre
ORDER BY count(genre) desc;

---------------------------------------------------------------------------------------------

-- EX. 03
/*
Quais os 50 filmes com menor lucratividade ou que deram prejuízo, nos últimos 30 anos. Considerar apenas valores em dólar ($).
*/

-- Usar a view criada anteriormente valores_dolar

SELECT * from valores_dolar;
DESCRIBE valores_dolar;

-- realizado a consulta dos ultimos 30 anos, ordenando pelo menor valor (negativo) e limitando aos 50 filmes
SELECT
	imdb_title_id,
	title,
	budget_tratado as budget_em_dolar,
	worlwide_gross_income_tratado as bilheteria_mundial_em_dolar,
    (worlwide_gross_income_tratado - budget_tratado) as lucro_prejuizo,
    ano_tratado as ano
FROM valores_dolar
WHERE (ano_tratado) >= (YEAR(current_date()) - 30)
	ORDER BY (worlwide_gross_income_tratado - budget_tratado)
	LIMIT 50;
	
---------------------------------------------------------------------------------------------
-- EX.04
/*
Selecionar os top 10 filmes baseados nas avaliações dos usuários, para cada ano, nos últimos 20 anos.
*/

-- Utilizado a View movies_tratados
SELECT * FROM movies_tratados;

-- Criado uma CTE para realizar a consulta

WITH top_20anos AS (
	SELECT
		imdb_title_id,
		title,
		original_title,
		ano_tratado,
		avg_vote,
		row_number() over (partition by ano_tratado order by avg_vote desc) as row_num
	FROM movies_tratados
    WHERE (ano_tratado) >= (YEAR(current_date()) -20)
    )
    SELECT
		imdb_title_id,
        title,
        original_title,
        ano_tratado as ano,
        avg_vote
    FROM top_20anos
    WHERE row_num <=10;

---------------------------------------------------------------------------------------------
-- EX. 05
/*
Gerar um relatório com os top 10 filmes mais bem avaliados pela crítica e os top 10 pela avaliação de usuário, contendo também o budget dos filmes.
*/

SELECT * FROM movies_tratados;

-- criado uma CTE para top 10 avaliacao pela critica
WITH avaliacao_critica AS (
	SELECT 
		imdb_title_id,
		title,
		original_title,
		reviews_from_critics,
		cast(replace(budget, '$','') as float) as budget_em_dolar,
		row_number() over(order by reviews_from_critics DESC) as row_num
	FROM movies_tratados
    )
    SELECT
		imdb_title_id,
		title,
		original_title,
		reviews_from_critics,
		budget_em_dolar
	FROM avaliacao_critica
	WHERE row_num <=10;

-- criado uma CTE para top 10 avaliacao por usuario
WITH avaliacao_usuario AS (
	SELECT 
		imdb_title_id,
		title,
		original_title,
		reviews_from_users,
		cast(replace(budget, '$','') as float) as budget_em_dolar,
		row_number() over(order by reviews_from_users DESC) as row_num
	FROM movies_tratados
    )
    SELECT 
		imdb_title_id,
		title,
		original_title,
		reviews_from_users,
		budget_em_dolar
	FROM avaliacao_usuario
		WHERE row_num <=10;
        
---------------------------------------------------------------------------------------------
-- EX. 06
/*
Gerar um relatório contendo a duração média de 5 gêneros a sua escolha.
*/

-- Escolhido os 5 generos com média de duração mais longa

-- visualizando a tabela
SELECT * FROM movies_tratados;

DESCRIBE movies_tratados;

WITH genero_maior_duracao AS (
	SELECT 
		genre,
        duration,
		ROUND(AVG(duration)) as media_duracao,
		row_number() over (order by avg(duration) desc) as row_num
	FROM movies_tratados
		GROUP BY genre
	)
    SELECT
		genre,
        media_duracao
	FROM genero_maior_duracao
    WHERE row_num <=5;
    
---------------------------------------------------------------------------------------------
-- EX. 07
/*
Gerar um relatório sobre os 5 filmes mais lucrativos de um ator/atriz(que podemos filtrar), trazendo o nome, ano de exibição, e Lucro obtido. Considerar apenas valores em dólar($).
*/

SELECT * FROM valores_dolar;


SELECT * FROM valores_dolar; -- T1
SELECT * FROM casesql_title_principals; -- T2 Necessario usar apenas para conexão das colunas name e valores_dolar (antiga tabela casesql_movies)
SELECT * FROM casesql_names; -- T3

-- Criado uma view fazendo inner join para que só buscasse o que tivesse relação

CREATE OR REPLACE VIEW filmes_lucrativos AS (
SELECT
	T1.imdb_title_id,
    T1.title,
    T1.original_title,
    T1.ano_tratado,
    (T1.worlwide_gross_income_tratado - T1.budget_tratado) as lucro,
    T3.name,
    T3.imdb_name_id
FROM valores_dolar T1
	INNER JOIN casesql_title_principals T2
		ON T1.imdb_title_id = T2.imdb_title_id
	INNER JOIN casesql_names T3
		ON T3.imdb_name_id = T2.imdb_name_id
);

-- Criado uma Cte para filtrar o resultado, sendo apenas os top 5 e também a opção de filtrar por atriz/ ator
-- usado o UPPER para não ter problemas nas buscas usando formato diferente (minuscular, misto, etc)

-- usado no exemplo ator 50 CENT

WITH top_5_filmes_lucrativos AS(
	SELECT 
		*,
		row_number() over(partition by name order by lucro desc) as row_num
	FROM  filmes_lucrativos
    WHERE lucro >0
    )
    SELECT
		title,
		UPPER(name) as ator_atriz,
        ano_tratado as ano_exibicao,
        lucro
    FROM top_5_filmes_lucrativos
    WHERE row_num <=5 AND name = '50 cent';
		
---------------------------------------------------------------------------------------------     
-- EX. 08
/*
Baseado em um filme que iremos selecionar, trazer um relatório contendo quais os atores/atrizes participantes, e pra cada ator trazer um campo com a média de avaliação da crítica dos últimos 5 filmes em que esse ator/atriz participou.
*/

SELECT * FROM movies_tratados; -- T1
SELECT * FROM casesql_names; -- T2
SELECT * FROM casesql_title_principals; -- T3

-- metascore para avaliacao da critica e avg_vote para avaliação do usuário

-- criado uma view com a tabela de filmes incluindo os atores/ atrizes
CREATE OR REPLACE VIEW filmes_names AS(
	SELECT 
		T1.imdb_title_id,
		T1.title,
		T1.original_title,
		T1.metascore,
        T1.ano_tratado as ano,
        T1.data_completa,
		T2.name,
		T2.imdb_name_id,
        row_number() over(partition by t2.name order by t1.ano_tratado desc) as row_num 
	FROM movies_tratados T1
		LEFT JOIN casesql_title_principals T3
			ON T1.imdb_title_id = T3.imdb_title_id
		LEFT JOIN  casesql_names T2
			ON T2.imdb_name_id = T3.imdb_name_id
		);

select * from filmes_names;


-- criado uma segunda view com uma coluna da media dos 5 ultimos filmes por ator/ atriz
create or replace view media_last5_filmes AS(
	SELECT
		imdb_title_id
		title,
        original_title,
        imdb_name_id,
		name,
        metascore,
        ano,
        data_completa,
		avg(metascore) as media_ultimos_5filmes
	FROM filmes_names
    where row_num <=5
    group by name);
    
--  realizando a consulta através de um filme

SELECT 
	upper(t1.title),
    t1.name as atriz_ator,
    t2.media_ultimos_5filmes
FROM filmes_names t1
LEFT JOIN media_last5_filmes t2
	ON t1.imdb_name_id = t2.imdb_name_id
WHERE UPPER(t1.title) = 'RoboCop';


 ---------------------------------------------------------------------------------------------  
 -- EX.09
 
 /*
 Gerar mais duas análises a sua escolha, baseado nessas tabelas (em uma delas deve incluir a análise exploratória de dois campos, um quantitativo e um qualitativo, respectivamente). 
 */
 
 -- Verificar o TOP 10 piores filmes nos ultimos 10 anos e qual genero mais aparece
 
-- criado um View para adicionar uma coluna com a marcação da classificação para cada avaliação
-- filtrado apenas os ultimos 10 anos
CREATE OR REPLACE VIEW classificacao_piores_filmes AS (
	SELECT
		imdb_title_id,
		title,
		genre,
		avg_vote,
		ano_tratado,
		row_number() over(partition by ano_tratado order by avg_vote) AS row_num
	FROM movies_tratados
    WHERE (ano_tratado) >= (YEAR(current_date()) - 10));

SELECT * FROM classificacao_piores_filmes;

-- filtrando os top 10 piores filmes
SELECT
	imdb_title_id,
	title,
	genre,
	avg_vote,
	ano_tratado,
	row_num
FROM classificacao_piores_filmes
WHERE row_num <=10;

-- fazendo a contagem dos generos para cada ano e criando uma classificação de ranking por ano
SELECT
	genre,
	count(genre) as contagem_genero,
	ano_tratado,
    row_number() over(partition by ano_tratado order by count(genre) desc) as row_num
FROM classificacao_piores_filmes
WHERE row_num <=10
GROUP BY ano_tratado, genre
ORDER BY ano_tratado,count(genre) desc;


-- feito a contagem do genero que aparece mais de 1 vez e ordenado por ano:
SELECT 
	genre,
    contagem_genero,
    ano_tratado as ano
FROM (SELECT
		genre,
		count(genre) as contagem_genero,
		ano_tratado,
		row_number() over(partition by ano_tratado order by count(genre) desc) as row_num
	FROM classificacao_piores_filmes
	WHERE row_num <=10
	GROUP BY ano_tratado, genre
	ORDER BY ano_tratado,count(genre) desc) AS sub
WHERE contagem_genero >1
ORDER BY ano_tratado;

-- verificando de modo geral nos 10 anos, qual genero mais apareceu entre os top 10 piores filmes
SELECT
	genre,
	count(genre) as contagem_genero
FROM classificacao_piores_filmes
WHERE row_num <=10
GROUP BY genre
ORDER BY count(genre) desc;


