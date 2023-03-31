-- SP
-- Filter articles that contains @inName chars order by name
-- If empty shows all articles
CREATE PROCEDURE dbo.FilterByName
	@inName VARCHAR(128)
	, @outResultCode INT OUTPUT 			--SP result code
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0;				-- Succes result code
		SELECT A.Id
			, A.[Name]
			, A.Price
			, T.[Name] AS 'Type'
		FROM dbo.Article A
		INNER JOIN dbo.ArticleType T
		ON A.[Name] LIKE '%'+@inName+'%'
		COLLATE Latin1_general_CI_AI
		AND A.idArticleType = T.Id
		ORDER BY A.[Name];
	END TRY
	BEGIN CATCH
		INSERT INTO dbo.DBErrors
			VALUES(
			SUSER_SNAME()
			, ERROR_NUMBER()
			, ERROR_STATE()
			, ERROR_SEVERITY()
			, ERROR_LINE()
			, ERROR_PROCEDURE()
			, ERROR_MESSAGE()
			, GETDATE()
			);
			SET @outResultCode = 50009;		-- Error result code
	END CATCH
	SET NOCOUNT OFF;
END;