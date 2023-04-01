-- SP
-- Insert in Articles
-- If Article exists, not insert article

CREATE PROCEDURE dbo.InsertArticle
	@inName VARCHAR(64)
	, @inPrice MONEY
	, @inType VARCHAR(64)
	, @inPostIdUser INT
	, @inPostIp VARCHAR(64)
	, @outResultCode INT OUTPUT

AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY

		DECLARE @LogDescription VARCHAR(2000) = '{Action Type = Insert article successfully '
		DECLARE @IdArticleClass INT
		SET @outResultCode = 0;

		-- Validate if article it's already exists
		IF EXISTS (SELECT 1 FROM dbo.Article A WHERE A.[Name] = @inName)
			BEGIN
				SET @outResultCode = 50001;
				RETURN;
			END;

		SELECT @IdArticleClass = T.Id 
		FROM dbo.ArticleType T
		WHERE @inType = [Name];
 
		SET @LogDescription = 
			@LogDescription + 'Description = ' 
			+ CONVERT(VARCHAR, @IdArticleClass) 
			+ ' ,' + @inName + ' ,'
			+ CONVERT(VARCHAR, @inPrice) + '}';

		BEGIN TRANSACTION;
			INSERT [dbo].Article (
				IdArticleType				
				,[Name]
				, [Price])
			VALUES (
				@IdArticleClass
				, @inName
				, @inPrice
				);

			INSERT dbo.EventLog(
				[LogDescription]
				, [PostIdUser]
				, [PostIp]
				, [PostTime])
			VALUES (
				@LogDescription
				, @inPostIdUser
				, @inPostIp
				, GETDATE()
				);
		COMMIT;
	
	END TRY
	
	BEGIN CATCH

		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK;
		END;

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