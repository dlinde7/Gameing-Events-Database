CREATE FUNCTION dbo.TeamGamesFilter(@TeamId INT)
RETURNS TABLE
AS 
RETURN
    SELECT Name, Description
    From Games a, TeamGames b
    WHERE a.GameId=b.GameId
    AND b.TeamId = @TeamId