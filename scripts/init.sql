
--=======================================================================
--CRIAR UM BANCO DE DADOS MODELADO
--ABAIXO TEMOS TODOS OS SCRIPTS DE CRIAÇÃO DO DB
--=======================================================================
---------------------------------------------------------------------
--CRIAÇÃO DO BANCO DE DADOS
CREATE DATABASE EMPRESA;
GO
---------------------------------------------------------------------
--O BANCO DE DADOS (EMPRESA) TERÁ 3 SCHEMAs: 
--VEN(VENDAS)-TODAS AS TABELAS DE VENDAS, 
--FIN(FINANCEIRO)-TABELAS DO FINANCEIRO, 
--FIS(FISCAL)-TABELAS DO FISCAL

--USAR O DATABASE CRIADO
USE EMPRESA;
GO
-----------------------------------------------------------
-- 1. Cria o Schema 1 (ex: VEN)
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'VEN')
BEGIN
    EXEC('CREATE SCHEMA VEN AUTHORIZATION dbo');
END
GO

-- 2. Cria o Schema 2 (ex: FIS)
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'FIS')
BEGIN
    EXEC('CREATE SCHEMA FIS AUTHORIZATION dbo');
END
GO

-- 3. Cria o Schema 3 (ex: FIN)
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'FIN')
BEGIN
    EXEC('CREATE SCHEMA FIN AUTHORIZATION dbo');
END
GO

-----------------------------------------------------------------------
--CRIAÇÃO DAS TABELAS DO SCHEMA VENDAS(VEN)
--CRIAÇÃO TABELA CLIENTE
IF NOT EXISTS (SELECT * FROM sys.tables t 
               JOIN sys.schemas s ON t.schema_id = s.schema_id 
               WHERE s.name = 'VEN' AND t.name = 'CLIENTE')
BEGIN
    CREATE TABLE VEN.CLIENTE (
		ID_CLIENTE INT IDENTITY (1,1) NOT NULL,
		NOME_CLIENTE VARCHAR (50) NOT NULL
    );
END
GO
-----------------------------------------------------------------
--CRIAÇÃO TABELA REGIÃO
IF NOT EXISTS (SELECT * FROM sys.tables t 
               JOIN sys.schemas s ON t.schema_id = s.schema_id 
               WHERE s.name = 'VEN' AND t.name = 'REGIAO')
BEGIN
    CREATE TABLE VEN.REGIAO (
		ID_REGIAO INT IDENTITY (1,1) NOT NULL,
		NOME_ESTADO VARCHAR (50) NOT NULL,
		SIGLA_ESTADO VARCHAR(2) NOT NULL
    );
END
GO
------------------------------------------------------------------
--CRIAÇÃO TABELA PRODUTO
IF NOT EXISTS (SELECT * FROM sys.tables t 
               JOIN sys.schemas s ON t.schema_id = s.schema_id 
               WHERE s.name = 'VEN' AND t.name = 'PRODUTO')
BEGIN
    CREATE TABLE VEN.PRODUTO (
		ID_PRODUTO INT IDENTITY (1,1) NOT NULL,
		NOME_PRODUTO VARCHAR (50) NOT NULL
    );
END
GO

----------------------------------------------------------------------
--CRIAÇÃO TABELA VENDEDOR
IF NOT EXISTS (SELECT * FROM sys.tables t 
               JOIN sys.schemas s ON t.schema_id = s.schema_id 
               WHERE s.name = 'VEN' AND t.name = 'VENDEDOR')
BEGIN
    CREATE TABLE VEN.VENDEDOR (
		ID_VENDEDOR INT IDENTITY (1,1) NOT NULL,
		NOME_VENDEDOR VARCHAR (50) NOT NULL
    );
END
GO
---------------------------------------------------------------------
--CRIAÇÃO TABELA EMPRESA
IF NOT EXISTS (SELECT * FROM sys.tables t 
               JOIN sys.schemas s ON t.schema_id = s.schema_id 
               WHERE s.name = 'VEN' AND t.name = 'EMPRESA')
BEGIN
    CREATE TABLE VEN.EMPRESA (
		ID_EMPRESA INT IDENTITY (1,1) NOT NULL,
		NOME_EMPRESA VARCHAR (50) NOT NULL,
		FK_PRODUTO INT
    );
END
GO

-----------------------------------------------------------------------
--CRIAÇÃO TABELA PEDIDO
IF NOT EXISTS (SELECT * FROM sys.tables t 
               JOIN sys.schemas s ON t.schema_id = s.schema_id 
               WHERE s.name = 'VEN' AND t.name = 'PEDIDO')
BEGIN
    CREATE TABLE VEN.PEDIDO (
		ID_PEDIDO INT IDENTITY (1,1) NOT NULL,
		FK_CLIENTE INT NOT NULL,
		FK_PRODUTO INT NOT NULL,
		QTD_VENDIDA INT NOT NULL,
		PRECO_VENDA FLOAT NOT NULL,
		FK_VENDEDOR INT NOT NULL,
		DATA_PEDIDO DATETIME NOT NULL,
		FK_REGIAO INT NOT NULL,
		DESCONTO FLOAT NOT NULL
    );
END
GO

---------------------------------------------------------------------
/* CRIAÇÃO DAS CONSTRAINTS CHAVE PRIMÁRIA DAS TABELAS(6) DO DB  */

ALTER TABLE VEN.CLIENTE
ADD PRIMARY KEY (ID_CLIENTE)
;
GO

ALTER TABLE VEN.REGIAO
ADD PRIMARY KEY (ID_REGIAO)
;
GO

ALTER TABLE VEN.PRODUTO
ADD PRIMARY KEY (ID_PRODUTO)
;
GO

ALTER TABLE VEN.VENDEDOR
ADD PRIMARY KEY (ID_VENDEDOR)
;
GO

ALTER TABLE VEN.EMPRESA
ADD PRIMARY KEY (ID_EMPRESA)
;
GO

ALTER TABLE VEN.PEDIDO
ADD PRIMARY KEY (ID_PEDIDO)
;
GO
----------------------------------------------------------------------------
/* CRIAÇÃO DAS CONSTRAINTS CHAVE ESTRANGEIRA DAS TABELAS(6) DO DB  */

ALTER TABLE VEN.EMPRESA
ADD CONSTRAINT FK_ID_PRODUTO FOREIGN KEY(FK_PRODUTO) REFERENCES VEN.PRODUTO (ID_PRODUTO)
;
GO

ALTER TABLE VEN.PEDIDO
ADD CONSTRAINT FK_ID_CLIENTE FOREIGN KEY(FK_CLIENTE) REFERENCES VEN.CLIENTE (ID_CLIENTE)
;
GO

ALTER TABLE VEN.PEDIDO
ADD CONSTRAINT FK_ID_PRODUTO_VENDAS FOREIGN KEY(FK_PRODUTO) REFERENCES VEN.PRODUTO (ID_PRODUTO)
;
GO

ALTER TABLE VEN.PEDIDO
ADD CONSTRAINT FK_ID_VENDEDOR FOREIGN KEY(FK_VENDEDOR) REFERENCES VEN.VENDEDOR (ID_VENDEDOR)
;
GO

ALTER TABLE VEN.PEDIDO
ADD CONSTRAINT FK_ID_REGIAO FOREIGN KEY(FK_REGIAO) REFERENCES VEN.REGIAO (ID_REGIAO)
;
GO
---------------------------------------------------------------------------------------
--CRIAÇÃO DAS TABELAS DO SCHEMA FISCAL(FIS)
--CRIAÇÃO TABELA NOTA_FISCAL
IF NOT EXISTS (SELECT * FROM sys.tables t 
               JOIN sys.schemas s ON t.schema_id = s.schema_id 
               WHERE s.name = 'FIS' AND t.name = 'NOTA_FISCAL')
BEGIN
    CREATE TABLE FIS.NOTA_FISCAL (
        ID_NOTA_FISCAL INT IDENTITY (1,1) NOT NULL,
		ID_PEDIDO INT NOT NULL,
		FK_CLIENTE INT NOT NULL,
		FK_PRODUTO INT NOT NULL,
		QTD_VENDIDA INT NOT NULL,
		PRECO_VENDA FLOAT NOT NULL,
		FK_VENDEDOR INT NOT NULL,
		DATA_PEDIDO DATETIME NOT NULL,
		FK_REGIAO INT NOT NULL,
		DESCONTO FLOAT NOT NULL,
        DATA_VENCTO DATETIME NOT NULL
    );
END
GO
---------------------------------------------------------------------------------------
--CRIAÇÃO DAS TABELAS DO SCHEMA FINANCEIRO(FIN)
--CRIAÇÃO TABELA CONTAS A RECEBER
IF NOT EXISTS (SELECT * FROM sys.tables t 
               JOIN sys.schemas s ON t.schema_id = s.schema_id 
               WHERE s.name = 'FIN' AND t.name = 'CONTAS_RECEBER')
BEGIN
    CREATE TABLE FIN.CONTAS_RECEBER (
		ID_CONTAS_RECEBER INT IDENTITY (1,1) NOT NULL,
        ID_NOTA_FISCAL INT NOT NULL,
		ID_PEDIDO INT NOT NULL,
		FK_CLIENTE INT NOT NULL,
		FK_PRODUTO INT NOT NULL,
		QTD_VENDIDA INT NOT NULL,
		PRECO_VENDA FLOAT NOT NULL,
		FK_VENDEDOR INT NOT NULL,
		DATA_PEDIDO DATETIME NOT NULL,
		FK_REGIAO INT NOT NULL,
		DESCONTO FLOAT NOT NULL,
        DATA_VENCTO DATETIME NOT NULL
    );
END
GO
-------------------------------------------------------------------------------------


