REATE FUNCTION dbo.SocialMediaPercentage(@SocialName VARCHAR)
RETURNS INT
AS 
BEGIN
    DECLARE @returnvalue INT;

    SELECT
    COUNT(Name) FROM SocialView WHERE Name = @SocialName)
    AS SocialCount

    SELECT COUNT(UserId) FROM Users AS UserCount

    SELECT MatchCount, WinCount, @returnvalue = cast(SocialCount as float)/cast(UserCount as float)*100

    RETURN(@returnvalue);
END