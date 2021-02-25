-- [EventRegistrations Funcs] ********************************************************************************************************************** 
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