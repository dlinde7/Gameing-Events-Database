CREATE FUNCTION dbo.TeamGamesFilter(@TeamId INT)
RETURNS TABLE
AS 
RETURN
	SELECT a.Name, Description
    FROM Games a, TeamGames b
    WHERE a.GameId=b.GameId
    AND b.TeamId = @TeamId