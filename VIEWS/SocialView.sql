CREATE VIEW SocialMedia
AS SELECT FirstName, LastName, Handle, Link, Name
FROM Users a, Social b, SocialNetworks c
WHERE a.UserId=b.UserId
AND c.SocialNetworkId=b.SocialNetworkId;