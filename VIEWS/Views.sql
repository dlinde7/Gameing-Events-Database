CREATE VIEW [dbo].[vEventsInfo]
AS
SELECT E.Name AS EventName, E.Description, E.StartDate, E.EndDate, S.Name AS Status, G.Name AS GameName, V.Name AS Venue FROM Events E
	INNER JOIN Venues V ON E.VenueId=V.VenueId
	INNER JOIN Games G ON E.GameId = G.GameId
	INNER JOIN Statuses S ON E.EventStatus = S.StatusId
GO