CREATE VIEW EventVenue
AS
SELECT a.Name, a.Description, StartDate, EndDate, b.Name EventStatus, c.Name VenueName, Address FROM Events a
	INNER JOIN Statuses b ON b.StatusId=a.EventStatus
	INNER JOIN Venues c ON c.VenueId=a.VenueId
GO