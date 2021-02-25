CREATE FUNCTION dbo.TeamMembers(@TeamId INT)
RETURNS TABLE
AS 
RETURN
    SELECT FirstName, LastName, TeamCaptianStatus
    From Users a, UserTeams b
    WHERE a.UserId=b.UserId
    AND b.TeamId = @TeamId