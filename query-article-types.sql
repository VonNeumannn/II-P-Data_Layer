-- SP
-- Get article types order by name
CREATE PROCEDURE getArticleTypes
    @outResultCode INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SET @outResultCode = 0
        SELECT T.[Name]
        FROM dbo.ArticleType T
        ORDER BY T.[Name];
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
        SET @outResultCode = 50009;
    END CATCH
    SET NOCOUNT OFF;
END;