CREATE FUNCTION [dbo].[udfTotalTeamsApprovedForEvent](
    @EventId bigint
)
RETURNS int
AS
BEGIN
	RETURN
	(
		SELECT count(*)
		FROM [dbo].[EventRegistrations]
		WHERE EventId = @EventId
        AND isApproved = 1
        AND isVerified = 1
	)
END
GO

CREATE FUNCTION [dbo].[udfEventsByStatus](
    @StatusId bigint
)
RETURNS int
AS
BEGIN
	RETURN
	(
		SELECT count(*)
		FROM [dbo].[vEventsInfo]
		WHERE Status = (SELECT Name FROM Statuses WHERE StatusId = @StatusId)
	)
END
GO

CREATE FUNCTION [dbo].[udfEventsInfoByStatus](
    @StatusId bigint
)
RETURNS TABLE
AS
RETURN
	SELECT EventName, Description, StartDate, EndDate, Status, GameName, Venue
	FROM [dbo].[vEventsInfo]
	WHERE Status = (SELECT Name FROM Statuses WHERE StatusId = @StatusId)
GO