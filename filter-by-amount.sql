-- SP
-- Filter the first @amount elements from table
-- Order by name 
-- If is empty show all articles

CREATE PROCEDURE dbo.FilterByAmount
	@inAmount INT
	, @inPostUser VARCHAR(64)
	, @inPostIp VARCHAR(64)
	, @outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		DECLARE @LogDescription VARCHAR(256) = '{Action Type = Consult by amount '
												+ 'Description = ' 
												+ CONVERT(VARCHAR, @inAmount) + '}'
		DECLARE @postIdUser INT;
        SET @outResultCode = 0;                     -- No error code

			IF @inAmount IS NULL OR (@inAmount = '')
			BEGIN
				SELECT  A.id			-- Show only @inAmout articles
						, T.[Name] AS 'Type'
						, A.[Name]
						, A.Price
				FROM dbo.Article A
				INNER JOIN dbo.ArticleType T 
				ON A.IdArticleType = T.id 
				ORDER BY A.[Name];
			END
		ELSE
			BEGIN
				SELECT TOP(@inAmount)A.Id			-- Show only @inAmout articles
						, T.[Name] AS 'Type'
						, A.[Name]
						, A.Price
				FROM dbo.Article A
				INNER JOIN dbo.ArticleType T 
				ON A.IdArticleType = T.Id 
				ORDER BY A.[Name];
			END
		--Select Id from ArticleType
		SELECT @postIdUser = U.Id
		FROM dbo.[User] U
		WHERE @inPostUser = [Name];

		--Insert in EventLog table
		INSERT dbo.EventLog(
			[LogDescription]
			, [PostIdUser]
			, [PostIp]
			, [PostTime])
		VALUES (
			@LogDescription
			, @postIdUser
			, @inPostIp
			, GETDATE()
			);
    END TRY
    BEGIN CATCH
        INSERT INTO dbo.DBErrors	VALUES (
            SUSER_SNAME(),
            ERROR_NUMBER(),
            ERROR_STATE(),
            ERROR_SEVERITY(),
            ERROR_LINE(),
            ERROR_PROCEDURE(),
            ERROR_MESSAGE(),
            GETDATE()
        );

        Set @outResultCode=50009;                   -- Error code
    END CATCH
	SET NOCOUNT OFF;
END;