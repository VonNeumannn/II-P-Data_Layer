-- SP test
-- Filter by article name SP test

DECLARE @inName VARCHAR(128) = 'ma'         -- Article name must contain 'ma'
DECLARE @RC INT
DECLARE @outResult INT                    -- SP result code
DECLARE @inPostIdUser INT = 1
DECLARE @inPostIp VARCHAR(64) = '192.168.1.2'

EXECUTE @RC = dbo.FilterByName
	@inName
	, @inPostIdUser
	, @inPostIp
	, @outResult OUTPUT

SELECT @outResult AS OutResultCode

SELECT TOP(100)
	E.Id
	, E.LogDescription
	, E.PostIdUser
	, E.PostIp
	, E.PostTime
FROM dbo.EventLog E