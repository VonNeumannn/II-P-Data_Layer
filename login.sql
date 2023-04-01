-- SP
-- Login by User and password
-- 
-- 

CREATE PROCEDURE dbo.LoginDB
	@inUser VARCHAR(64)
	, @inPassword VARCHAR(64)
	, @inPostIdUser INT
	, @inPostIp VARCHAR(64)
	, @outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		DECLARE @LogDescription VARCHAR(256) = '{Action Type= '
		DECLARE @IdUser INT

        SET @outResultCode = 0;  

		SELECT @IdUser = U.Id
		FROM dbo.UserLogin U
		WHERE U.[Name] = @inUser
		AND U.[Password] = @inPassword;

		IF @IdUser IS NOT NULL
		BEGIN
			SET @LogDescription = @LogDescription + 'Successful login ' 
							+ 'Description= ' + ' }'
		END
		ELSE
		BEGIN
			SET @LogDescription = @LogDescription + 'Unsuccessful login ' 
							+ 'Description= ' + ' }'
		END;

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

	END TRY
	BEGIN CATCH
        INSERT INTO dbo.DBErrors VALUES (
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