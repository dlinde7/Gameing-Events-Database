CREATE FUNCTION dbo.WinRate(@TeamId INT)
RETURNS INT
AS 
BEGIN
    DECLARE @returnvalue INT;

    SELECT
    (SELECT COUNT(Team1Id) FROM Matches WHERE Team1Id = @TeamId)+
    (SELECT COUNT(Team2Id) FROM Matches WHERE Team2Id = @TeamId)
    AS MatchCount

    SELECT COUNT(WinnerId) FROM Matches WHERE WinnerId = @TeamId AS WinCount

    SELECT MatchCount, WinCount, @returnvalue = cast(MatchCount as float)/cast(WinCount as float)*100

    RETURN(@returnvalue);
END