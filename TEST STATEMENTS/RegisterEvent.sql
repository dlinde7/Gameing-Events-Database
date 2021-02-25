SELECT b.Name Event, c.Name TeamName
From EventRegistrations a, Events b, Teams c
WHERE b.EventId=a.EventId
AND c.TeamId=a.TeamId
AND b.EventId = 1