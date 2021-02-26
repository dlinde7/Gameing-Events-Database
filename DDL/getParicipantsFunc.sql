CREATE FUNCTION getParticipants (@EventId bigint)
RETURNS TABLE
AS
RETURN
	SELECT b.Name Event, c.Name TeamName
	From EventRegistrations a, Events b, Teams c
	WHERE b.EventId=a.EventId
	AND c.TeamId=a.TeamId
	AND a.EventId = @EventId 