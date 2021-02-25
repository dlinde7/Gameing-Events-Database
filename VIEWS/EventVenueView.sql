CREATE VIEW EventVenue
AS SELECT a.Name, a.Description, StartDate, EndDate, b.Name EventStatus, c.Name VenueName, Address
FROM Events a, Statuses b, Venues c
WHERE b.StatusId=a.EventStatus
AND c.VenueId=a.VenueId;