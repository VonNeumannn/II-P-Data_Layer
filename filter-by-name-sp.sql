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
		SELECT A.Id, A.[Name], A.Price
		FROM dbo.Article A
		WHERE A.[Name] LIKE '%'+@inName+'%'
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