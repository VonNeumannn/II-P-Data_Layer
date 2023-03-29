-- SP test
-- Filter by article type SP test

DECLARE @inName VARCHAR(128) = 'Jardin'         -- Article name must contain 'Jardin'
DECLARE @RC INT
DECLARE @outResult INT							-- SP result code

EXECUTE @RC = dbo.FilterByArticleType
	@inName
	, @outResult OUTPUT
    SELECT @outResult