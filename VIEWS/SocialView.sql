CREATE VIEW SocialMedia
AS
SELECT FirstName, LastName, Handle, Link, Name FROM Social a
	INNER JOIN Users b ON b.UserId=a.UserId
	INNER JOIN SocialNetworks c ON c.SocialNetworkId=a.SocialNetworkId
GO