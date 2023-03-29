-- SP test
-- Filter by article name SP test

DECLARE @inName VARCHAR(128) = 'ma'         -- Article name must contain 'ma'
DECLARE @RC INT
DECLARE @outResult INT                      -- SP result code

EXECUTE @RC = dbo.FilterByName
	@inName
	, @outResult OUTPUT
    SELECT @outResult