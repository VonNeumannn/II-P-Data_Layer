-- SP test
-- Filter by article type SP test

DECLARE @inName VARCHAR(128) = 'Jardin'         -- Article name must contain 'Jardin'
DECLARE @inPostIdUser INT = 2
DECLARE @inPostIp VARCHAR(64) = '192.168.12.1'
DECLARE @RC INT
DECLARE @outResult INT							-- SP result code

EXECUTE @RC = dbo.FilterByArticleType
	@inName
	, @inPostIdUser
	, @inPostIp
	, @outResult OUTPUT
SELECT @outResult
SELECT TOP(100)
	E.Id
	, E.LogDescription
	, E.PostIdUser
	, E.PostIp
	, E.PostTime
FROM dbo.EventLog E