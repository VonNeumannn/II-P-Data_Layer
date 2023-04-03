DECLARE @xmlData XML		-- Stores the xml data

-- load xml data
SET @xmlData = (
	SELECT *
	FROM OPENROWSET(
		BULK 'C:\bulk\data.xml'
		, SINGLE_BLOB)
		AS xmlData
);

-- Insert users from loaded xml data
INSERT INTO dbo.[User]
    ([Name]
    , [Password])
SELECT
    T.Item.value('@Nombre', 'VARCHAR(32)')
    , T.Item.value('@Password', 'VARCHAR(32)')
FROM @xmlData.nodes('root/Usuarios/Usuario') AS T(Item)

-- insert article types from loaded xml data
INSERT INTO dbo.ArticleType
	([Name])
SELECT
	T.Item.value('@Nombre', 'VARCHAR(128)')
FROM @xmlData.nodes('root/ClasesdeArticulos/ClasesdeArticulo') AS T(Item)

-- insert articles from loaded xml data
INSERT INTO dbo.Article
	(
		idArticleType
		, [Name]
		, Price
	)
SELECT
    (
		SELECT C.Id
		FROM dbo.ArticleType C
		WHERE C.[Name] = T.Item.value('@ClasesdeArticulo', 'VARCHAR(128)')
	)
	, T.Item.value('@Nombre', 'VARCHAR(2000)')
	, T.Item.value('@precio', 'MONEY')
FROM @xmlData.nodes('root/Articulos/Articulo') AS T(Item)