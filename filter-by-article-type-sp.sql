-- SP
-- Filter articles by type
CREATE PROCEDURE dbo.FilterByArticleType
    @inName VARCHAR(128)
    , @outResultCode INT OUTPUT             -- SP result code
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SET @outResultCode = 0              -- Succes code
        SELECT A.Id, A.[Name], A.Price, T.Name As 'Type'
        FROM dbo.Article A
        INNER JOIN dbo.ArticleType T
        ON T.Name = @inName
        AND T.Id = A.IdArticleType;
    END TRY
    BEGIN CATCH
        INSERT INTO dbo.Errors
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
            SET @outResultCode = 50008;     -- Error code
    END CATCH
    SET NOCOUNT OFF;
END;