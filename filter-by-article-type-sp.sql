-- SP
-- Filter articles by type
CREATE PROCEDURE dbo.FilterByArticleType
    @inName VARCHAR(128)
	, @inPostUser VARCHAR(64)
	, @inPostIp VARCHAR(64)
    , @outResultCode INT OUTPUT             -- SP result code
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		DECLARE @logDescription VARCHAR(2000) =
			'{'
			+ '"ActionType"="Filter by article type" '
			+ '"Description"="' +@inName+ '"'
			+ '}';
		DECLARE @postIdUser INT;
        SET @outResultCode = 0              -- Succes code

        SELECT A.Id
            , A.[Name]
            , A.Price
            , T.Name As 'Type'
        FROM dbo.Article A
        INNER JOIN dbo.ArticleType T
        ON T.Name = @inName
        AND T.Id = A.IdArticleType;

		--Select Id from ArticleType
		SELECT @postIdUser = U.Id
		FROM dbo.[User] U
		WHERE @inPostUser = [Name];

		INSERT INTO dbo.EventLog
			VALUES (
			@logDescription
			, @postIdUser
			, @inPostIp
			, GETDATE()
			);
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