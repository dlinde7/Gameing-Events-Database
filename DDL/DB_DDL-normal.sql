-- ******************************************************** SqlDBM: MySQL ***************************************************************;
-- **************************************************************************************************************************************;
USE master
IF EXISTS(select * from sys.databases where name='TournamentCompanyDB')
DROP DATABASE TournamentCompanyDB;
GO

CREATE DATABASE TournamentCompanyDB;
GO

USE [TournamentCompanyDB];
GO


-- ********************************************************************************************************************** [General Procs]
CREATE PROCEDURE [dbo].[uspGetErrorInfo]
AS
SELECT
    ERROR_NUMBER() AS ErrorNumber
    ,ERROR_SEVERITY() AS ErrorSeverity
    ,ERROR_STATE() AS ErrorState
    ,ERROR_PROCEDURE() AS ErrorProcedure
    ,ERROR_LINE() AS ErrorLine
    ,ERROR_MESSAGE() AS ErrorMessage
GO
-- ********************************************************************************************************************** [General Procs]


-- ********************************************************************************************************************** [Statuses]
CREATE TABLE [dbo].[Statuses]
(
    [StatusId]                      [bigint] NOT NULL IDENTITY(1,1),
    [Name]                          [nvarchar](40) NOT NULL,
    [Description]                   [nvarchar](2000) NULL,
    [AddedBy]                       [bigint] NOT NULL,
    [AddedByDatetime]               [datetime] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL,
    [LastUpdatedByDatetime]         [datetime] NOT NULL,
);
GO
-- ************************************************************** [Statuses Constraints]
ALTER TABLE [dbo].[Statuses]
ADD CONSTRAINT [PK_Statuses] PRIMARY KEY CLUSTERED (
    [StatusId] ASC
) WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , PAD_INDEX = OFF
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO
-- ************************************************************** [Access Indexes]
-- ************************************************************** [Statuses Procs]
CREATE PROCEDURE [dbo].[uspInsertStatus]
    @Name nvarchar(40),
    @Description nvarchar(2000),
    @UserId bigint
AS
BEGIN TRY
    BEGIN TRAN
        INSERT INTO Statuses (Name, Description, AddedBy, AddedByDateTime, LastUpdatedBy, LastUpdatedByDatetime)
        VALUES (@Name, @Description, @UserId, GETDATE(), @UserId, GETDATE());
    COMMIT
END TRY
BEGIN CATCH
    ROLLBACK
    EXECUTE [dbo].[uspGetErrorInfo];
END CATCH
GO

CREATE PROCEDURE [dbo].[uspUpdateStatus]
    @StatusId bigint,
    @Name nvarchar(40),
	@Description nvarchar(2000),
    @UserId bigint
AS
BEGIN TRY
    BEGIN TRAN
        MERGE INTO [dbo].[Statuses] S USING(
            VALUES
                (@StatusId, @Name, @Description)
        )
        AS SE (StatusID, Name, Description)
        ON SE.StatusId = S.StatusId
        WHEN MATCHED THEN
            UPDATE SET
                S.Name = SE.Name,
				S.Description = SE.Description,
                S.LastUpdatedBy = @UserId,
                S.LastUpdatedByDatetime = GETDATE();
    COMMIT
END TRY
BEGIN CATCH
    ROLLBACK
    EXECUTE [dbo].[uspGetErrorInfo];
END CATCH
GO


-- ************************************************************** [Statuses Functions]
-- ************************************************************** [Statuses Views]
-- ************************************************************** [Statuses Base Data]
-- ********************************************************************************************************************** [Statuses]                                                               
 
 

-- ********************************************************************************************************************** [AccountTypes]
CREATE TABLE [dbo].[AccountTypes](
    [AccountTypeId]                 [bigint] NOT NULL IDENTITY(1,1),
    [Name]                          [nvarchar](120) NOT NULL,
    [Description]                   [nvarchar](500) NOT NULL,
    [AddedBy]                       [bigint] NOT NULL,
    [AddedByDatetime]               [datetime] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL,
    [LastUpdatedByDatetime]         [datetime] NOT NULL
);
GO
-- ************************************************************** [AccountType Contraints]
ALTER TABLE [dbo].[AccountTypes]
ADD CONSTRAINT [PK_AccountTypes] PRIMARY KEY CLUSTERED (
    [AccountTypeId] ASC
) WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , PAD_INDEX = OFF
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO
-- ************************************************************** [Access Indexes]
-- ************************************************************* [AccountType Procs]
-- ************************************************************* [AccountType Views]
-- ********************************************************************************************************************** [AccountType]




-- ********************************************************************************************************************** [Users]
CREATE TABLE [dbo].[Users]
(
    [UserId]                        [bigint] NOT NULL IDENTITY(1,1),
    [FirstName]                     [nvarchar](120) NOT NULL,
    [LastName]                      [nvarchar](120) NOT NULL,
    [ProfileImageUrl]               [nvarchar](600) NULL,
    [DateOfBirth]                   [date] NOT NULL,
    [AccountTypeId]                 [bigint] NULL,
    [EmailAddress]                  [nvarchar](180) NOT NULL,
    [ContactNumber]                 [varchar](40) NOT NULL,
    [IsEmailVerified]               [bit] NOT NULL,
    [IsContactNumberVerified]       [bit] NOT NULL,
    [AddedBy]                       [bigint] NULL,
    [AddedByDateTime]               [datetime] NOT NULL,
    [LastUpdatedBy]                 [bigint] NULL,
    [LastUpdatedByDatetime]         [datetime] NOT NULL
)
GO
-- ************************************************************** [Users Constraints]
ALTER TABLE [dbo].[Users]
ADD CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED (
    [UserId] ASC
) WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , PAD_INDEX = OFF
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[Users]  WITH CHECK
ADD CONSTRAINT [FK_Users_AccountType] FOREIGN KEY([AccountTypeId])
REFERENCES [dbo].[AccountTypes] ([AccountTypeId])
GO

-- ************************************************************** [Users Indexes]
CREATE UNIQUE NONCLUSTERED INDEX [UIX_Users_EmailAddress] 
ON [dbo].[Users](
    [EmailAddress] ASC
)  WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , FILLFACTOR = 70
    , PAD_INDEX = ON
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_Users_FirstName_LastName] 
ON [dbo].[Users](
    [FirstName] ASC,
    [LastName] ASC
)
GO
CREATE NONCLUSTERED INDEX [IX_Users_AccountType] 
ON [dbo].[Users](
    [AccountTypeId] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_Users_LastUpdated] 
ON [dbo].[Users](
    [LastUpdatedBy] ASC,
    [LastUpdatedByDatetime] ASC
)
GO
-- ************************************************************** [Users Procs]
-- ************************************************************** [Users Functions]
-- ************************************************************** [Users Views]
-- ********************************************************************************************************************** [Users]
                                                                  


                                                                   
-- ********************************************************************************************************************** [Access]
CREATE TABLE [dbo].[Access](
    [AccessId]                      [bigint] NOT NULL IDENTITY(1,1),
    [UserId]                        [bigint] NOT NULL,
    [Password]                      [binary](1000)NOT NULL,
    [Username]                      [nvarchar](120) NOT NULL,
    [SecurityKey]                   [nvarchar](120) NOT NULL,
    [DateCreated]                   [datetime] NOT NULL,
    [isAdmin]                       [bit] NOT NULL,
    [IsActive]                      [bit] NOT NULL,
    [AddedBy]                       [bigint] NOT NULL,
    [AddedByDatetime]               [datetime] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL,
    [LastUpdatedByDatetime]         [datetime] NOT NULL
)
GO
-- ************************************************************** [Access Contraints]
ALTER TABLE [dbo].[Access]
ADD CONSTRAINT [PK_Access] PRIMARY KEY CLUSTERED (
    [AccessId] ASC
) WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , PAD_INDEX = OFF
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[Access]  WITH CHECK 
ADD CONSTRAINT [FK_Access_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
-- ************************************************************** [Access Indexes]
CREATE UNIQUE NONCLUSTERED INDEX [UIX_Access_Username] 
ON [dbo].[Access](
    [Username] ASC
) WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , FILLFACTOR = 75
    , PAD_INDEX = ON
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_Access_User_Username_IsActive]
ON [dbo].[Access](
    [UserId] ASC,
    [Username] ASC,
    [isActive] ASC
) WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , FILLFACTOR = 75
    , PAD_INDEX = ON
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_Access_LastUpdated] 
ON [dbo].[Access](
    [LastUpdatedBy] ASC,
    [LastUpdatedByDatetime] ASC
) WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , FILLFACTOR = 75
    , PAD_INDEX = ON
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO
-- ************************************************************* [Access Functions]

CREATE FUNCTION [dbo].[udfUserIsAdmin](
    @UserId bigint
)
RETURNS bit
AS
BEGIN
	RETURN
	(
		SELECT isAdmin
		FROM [dbo].[Access]
		WHERE UserId = @UserId
        AND isActive = 1 
	)
END
GO
-- ************************************************************* [Access Procs]
-- ************************************************************* [Access Views]
-- ********************************************************************************************************************** [Access]



-- ********************************************************************************************************************** [SocialNetworks]
CREATE TABLE [dbo].[SocialNetworks]
(
    [SocialNetworkId]               [bigint] NOT NULL IDENTITY(1,1),
    [Name]                          [nvarchar](120) NOT NULL,
    [BaseUrl]                       [nvarchar](120) NOT NULL,
    [AddedBy]                       [bigint] NOT NULL,
    [AddedByDatetime]               [datetime] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL,
    [LastUpdatedByDatetime]         [datetime] NOT NULL
);
GO
-- ************************************************************** [SocialNetworks Constraints]
ALTER TABLE [dbo].[SocialNetworks]
ADD CONSTRAINT [PK_SocialNetworks] PRIMARY KEY CLUSTERED (
    [SocialNetworkId] ASC
) WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , PAD_INDEX = OFF
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO

-- ************************************************************** [SocialNetworks Indexes]
CREATE UNIQUE NONCLUSTERED INDEX [UIX_SocialNetworks_Name] ON [dbo].[SocialNetworks]
(
    [Name] ASC
)  WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , FILLFACTOR = 70
    , PAD_INDEX = ON
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_SocialNetworks_LastUpdated] ON [dbo].[SocialNetworks]
(
    [LastUpdatedBy] ASC,
    [LastUpdatedByDatetime] ASC
)
GO
-- ************************************************************** [SocialNetworks Procs]
-- ************************************************************** [SocialNetworks Views]
-- ********************************************************************************************************************** [SocialNetworks]
                                                                  



-- ********************************************************************************************************************** [Social]
CREATE TABLE [dbo].[Social]
(
    [SocialId]                      [bigint] NOT NULL IDENTITY(1,1),
    [UserId]                        [bigint] NOT NULL,
    [SocialNetworkId]               [bigint] NOT NULL,
    [Handle]                        [nvarchar](120) NOT NULL,
    [Link]                          [nvarchar](120) NULL,
    [AddedBy]                       [bigint] NOT NULL,
    [AddedByDatetime]               [datetime] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL,
    [LastUpdatedByDatetime]         [datetime] NOT NULL
);
GO
-- ************************************************************** [Social Constraints]
ALTER TABLE [dbo].[Social]
ADD CONSTRAINT [PK_Social] PRIMARY KEY CLUSTERED (
    [SocialId] ASC
) WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , PAD_INDEX = OFF
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Social]  WITH CHECK
ADD CONSTRAINT [FK_Social_SocialNetwork] FOREIGN KEY([SocialNetworkId])
REFERENCES [dbo].[SocialNetworks] ([SocialNetworkId])
GO

ALTER TABLE [dbo].[Social]  WITH CHECK
ADD CONSTRAINT [FK_Social_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
-- ************************************************************** [Social Indexes]
CREATE NONCLUSTERED INDEX [IX_Social_User_SocialNetwork]
ON [dbo].[Social](
    [UserId] ASC,
    [SocialNetworkId] ASC
)
GO

CREATE UNIQUE NONCLUSTERED INDEX [UIX_Social_SocialNetwork_Handle]
ON [dbo].[Social](
    [SocialNetworkId] ASC,
    [Handle] ASC
)  WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , FILLFACTOR = 70
    , PAD_INDEX = ON
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_Social_LastUpdated] 
ON [dbo].[Social](
    [LastUpdatedBy] ASC,
    [LastUpdatedByDatetime] ASC
)
GO
-- ************************************************************** [Social Procs]
-- ************************************************************** [Social Views]
-- ********************************************************************************************************************** [Social]
                                                                  



-- ********************************************************************************************************************** [Games]
CREATE TABLE [dbo].[Games]
(
    [GameId]                        [bigint] NOT NULL  IDENTITY(1,1),
    [Name]                          [nvarchar](120) NOT NULL,
    [Description]                   [nvarchar](2000) NULL,
    [ReleaseDate]                   [date] NOT NULL,
    [Version]                       [nvarchar](20) NOT NULL,
    [AddedBy]                       [bigint] NOT NULL,
    [AddedByDatetime]               [datetime] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL,
    [LastUpdatedByDatetime]         [datetime] NOT NULL
);
GO
-- ************************************************************** [Games Constraints]
ALTER TABLE [dbo].[Games]
ADD CONSTRAINT [PK_Games] PRIMARY KEY CLUSTERED (
    [GameId] ASC
) WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , PAD_INDEX = OFF
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO

-- ************************************************************** [Games Indexes]
CREATE UNIQUE NONCLUSTERED INDEX [UIX_Games_Name_Version]
ON [dbo].[Games](
    [Name] ASC,
    [Version] ASC
)  WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , FILLFACTOR = 70
    , PAD_INDEX = ON
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_Games_Name]
ON [dbo].[Games](
    [Name] ASC
)
GO
-- ************************************************************** [Games Procs]
-- ************************************************************** [Games Views]
-- ********************************************************************************************************************** [Games]
                                                                  



-- ********************************************************************************************************************** [Provinces]
CREATE TABLE [dbo].[Provinces](
    [ProvinceId]                    [bigint] NOT NULL IDENTITY(1,1),
    [Name]                          [nvarchar](120) NOT NULL,
    [AddedBy]                       [bigint] NOT NULL,
    [AddedByDatetime]               [datetime] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL,
    [LastUpdatedByDatetime]         [datetime] NOT NULL
);
GO
-- ************************************************************** [Provinces Contraints]
ALTER TABLE [dbo].[Provinces]
ADD CONSTRAINT [PK_Provinces] PRIMARY KEY CLUSTERED (
    [ProvinceId] ASC
) WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , PAD_INDEX = OFF
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO
-- ************************************************************** [Provinces Indexes]
CREATE UNIQUE NONCLUSTERED INDEX [UIX_Provinces_Name]
ON [dbo].[Provinces](
    [Name] ASC
) WITH (
    IGNORE_DUP_KEY = ON
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , FILLFACTOR = 70
    , PAD_INDEX = ON
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO
-- ************************************************************** [Provinces Procs]
-- ************************************************************** [Provinces Views]
-- ********************************************************************************************************************** [Provinces]
                                                                  



-- ********************************************************************************************************************** [Cities]
CREATE TABLE [dbo].[Cities](
    [CityId]                        [bigint] NOT NULL IDENTITY(1,1),
    [ProvinceId]                    [bigint] NOT NULL,
    [Name]                          [nvarchar](120) NOT NULL,
    [AddedBy]                       [bigint] NOT NULL,
    [AddedByDatetime]               [datetime] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL,
    [LastUpdatedByDatetime]         [datetime] NOT NULL
);
GO
-- ************************************************************** [Cities Contraints]
ALTER TABLE [dbo].[Cities]
ADD CONSTRAINT [PK_Cities] PRIMARY KEY CLUSTERED (
    [CityId] ASC
) WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , PAD_INDEX = OFF
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Cities]  WITH CHECK ADD  CONSTRAINT [FK_Cities_Province] FOREIGN KEY([ProvinceId])
REFERENCES [dbo].[Provinces] ([ProvinceId])
GO
-- ************************************************************** [Cities Indexes]
CREATE NONCLUSTERED INDEX [IX_Cities_Name]
ON [dbo].[Cities](
    [Name] ASC
)
GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_Cities_Name_Province]
ON [dbo].[Cities](
    [Name] ASC,
    [ProvinceId] ASC
) WITH (
    IGNORE_DUP_KEY = ON
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , FILLFACTOR = 70
    , PAD_INDEX = ON
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Cities_LastUpdated]
ON [dbo].[Cities](
    [LastUpdatedBy] ASC,
    [LastUpdatedByDatetime] ASC
)
GO
-- ************************************************************** [Cities Procs]
-- ************************************************************** [Cities Views]
-- ********************************************************************************************************************** [Cities]
                                                                  



-- ********************************************************************************************************************** [Teams]
CREATE TABLE [dbo].[Teams]
(
    [TeamId]                        [bigint] NOT NULL IDENTITY(1,1),
    [Slogan]                        [nvarchar](200) NOT NULL,
    [Name]                          [nvarchar](120) NOT NULL,
    [LogoUrl]                       [nvarchar](600) NULL,
    [ReceieveNotifications]         [bit] NOT NULL,
    [isActive]                      [bit] NOT NULL,
    [AddedBy]                       [bigint] NOT NULL,
    [AddedByDatetime]               [datetime] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL,
    [LastUpdatedByDatetime]         [datetime] NOT NULL
)
GO
-- ************************************************************** [Teams Constraints]
ALTER TABLE [dbo].[Teams]
ADD CONSTRAINT [PK_Teams] PRIMARY KEY CLUSTERED (
    [TeamId] ASC
) WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , PAD_INDEX = OFF
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO
-- ************************************************************** [Teams Indexes]
CREATE UNIQUE NONCLUSTERED INDEX [UIX_Teams_Name]
ON [dbo].[Teams](
    [Name] ASC
) WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , FILLFACTOR = 70
    , PAD_INDEX = ON
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Teams_LastUpdated]
ON [dbo].[Teams](
    [LastUpdatedBy] ASC,
    [LastUpdatedByDatetime] ASC
)
GO
-- ************************************************************** [Teams Procs]
-- ************************************************************** [Teams Views]
-- ********************************************************************************************************************** [Teams]
                                                                  


-- ********************************************************************************************************************** [TeamGames]
CREATE TABLE [dbo].[TeamGames]
(
    [TeamGameId]                    [bigint] NOT NULL IDENTITY(1,1),
    [GameId]                        [bigint] NOT NULL,
    [TeamId]                        [bigint] NOT NULL,
    [AddedBy]                       [bigint] NOT NULL,
    [AddedByDatetime]               [datetime] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL,
    [LastUpdatedByDatetime]         [datetime] NOT NULL
);
GO
-- ************************************************************** [TeamGames Constraints]
ALTER TABLE [dbo].[TeamGames]
ADD CONSTRAINT [PK_TeamGames] PRIMARY KEY CLUSTERED (
    [TeamGameId] ASC
) WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , PAD_INDEX = OFF
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TeamGames]  WITH CHECK ADD  CONSTRAINT [FK_TeamGames_Game] FOREIGN KEY([GameId])
REFERENCES [dbo].[Games] ([GameId])
GO

ALTER TABLE [dbo].[TeamGames]  WITH CHECK ADD  CONSTRAINT [FK_TeamGames_Team] FOREIGN KEY([TeamId])
REFERENCES [dbo].[Teams] ([TeamId])
GO
-- ************************************************************** [TeamGames Indexes]
CREATE NONCLUSTERED INDEX [IX_TeamGames_Game]
ON [dbo].[TeamGames](
    [GameId] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_TeamGames_TeamId]
ON [dbo].[TeamGames](
    [TeamId] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_TeamGames_LastUpdated]
ON [dbo].[TeamGames](
    [LastUpdatedBy] ASC,
    [LastUpdatedByDatetime] ASC
)
GO
-- ************************************************************** [TeamGames Procs]
-- ************************************************************** [TeamGames Views]
-- ********************************************************************************************************************** [TeamGames]
                                                                  

                                                                   
-- ********************************************************************************************************************** [userTeams]
CREATE TABLE [dbo].[UserTeams]
(
    [UserTeamId]                    [bigint] NOT NULL IDENTITY(1,1),
    [UserId]                        [bigint] NOT NULL,
    [TeamId]                        [bigint] NOT NULL,
    [IsActive]                      [bit] NOT NULL,
    [HasEditPrivilages]             [bit] NOT NULL,
    [IsTeamCaptain]                 [bit] NOT NULL,
    [LastUpdatedByDatetime]         [datetime] NULL,
    [AddedBy[DateTime]              [datetime] NULL,
    [AddedBy]                       [bigint] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL
);
GO
-- ************************************************************** [UserTeams Contraints]
ALTER TABLE [dbo].[UserTeams]
ADD CONSTRAINT [PK_UserTeams] PRIMARY KEY CLUSTERED (
    [UserTeamId] ASC
) WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , PAD_INDEX = OFF
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserTeams]  WITH CHECK
ADD CONSTRAINT [FK_UserTeams_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO

ALTER TABLE [dbo].[UserTeams]  WITH CHECK
ADD CONSTRAINT [FK_UserTeams_Team] FOREIGN KEY([TeamId])
REFERENCES [dbo].[Teams] ([TeamId])
GO
-- ************************************************************** [UserTeams Indexes]
CREATE NONCLUSTERED INDEX [IX_UserTeams_User]
ON [dbo].[UserTeams] (
    [UserId] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_UserTeams_Team]
ON [dbo].[UserTeams] (
    [TeamId] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_UserTeams_LastUpdated]
ON [dbo].[UserTeams] (
    [LastUpdatedBy] ASC,
    [LastUpdatedByDatetime] ASC
)
GO
-- ************************************************************* [UserTeams Procs]
-- ************************************************************* [UserTeams Views]
-- ********************************************************************************************************************** [userTeams]
                                                                  

                                                                   

-- ********************************************************************************************************************** [AddressDetails]
CREATE TABLE [dbo].[AddressDetails](
    [AddressDetailId]               [bigint] NOT NULL IDENTITY(1,1),
    [Address]                       [nvarchar](500) NOT NULL,
    [CityId]                        [bigint] NULL,
    [UserId]                        [bigint] NOT NULL,
    [IsActive]                      [bit] NOT NULL,
    [AddedBy]                       [bigint] NOT NULL,
    [AddedByDatetime]               [datetime] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL,
    [LastUpdatedByDatetime]         [datetime] NOT NULL
);
GO
-- ************************************************************** [AddressDetails Contraints]
ALTER TABLE [dbo].[AddressDetails]
ADD CONSTRAINT [PK_AddressDetails] PRIMARY KEY CLUSTERED (
    [AddressDetailId] ASC
) WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , PAD_INDEX = OFF
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO
-- ************************************************************** [AddressDetails Indexes]
CREATE NONCLUSTERED INDEX [IX_AddressDetails_User]
ON [dbo].[AddressDetails](
    [UserId] ASC
)
GO

CREATE UNIQUE NONCLUSTERED INDEX [UIX_AddressDetails_Address]
ON [dbo].[AddressDetails](
    [Address] ASC
) WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , FILLFACTOR = 70
    , PAD_INDEX = ON
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_AddressDetails_City]
ON [dbo].[AddressDetails] (
    [CityId] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_AddressDetails_Address_City]
ON [dbo].[AddressDetails] (
    [Address] ASC,
    [CityId] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_AddressDetails_LastUpdated]
ON [dbo].[AddressDetails] (
    [LastUpdatedBy] ASC,
    [LastUpdatedByDatetime] ASC
)
GO
-- ************************************************************** [AddressDetails Procs]
-- ************************************************************** [AddressDetails Views]
-- ********************************************************************************************************************** [AddressDetails]



                                                                   
-- ********************************************************************************************************************** [Venues]
CREATE TABLE [dbo].[Venues]
(
    [VenueId]                       [bigint] NOT NULL IDENTITY(1,1),
    [Name]                          [nvarchar](120) NOT NULL,
    [Address]                       [nvarchar](400) NULL,
    [Website]                       [nvarchar](120) NULL,
    [CityId]                        [bigint] NOT NULL,
    [IsActive]                      [bit] NOT NULL,
    [AddedBy]                       [bigint] NOT NULL,
    [AddedByDatetime]               [datetime] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL,
    [LastUpdatedByDatetime]         [datetime] NOT NULL
);
GO
-- ************************************************************** [Venues Contraints]
ALTER TABLE [dbo].[Venues]
ADD CONSTRAINT [PK_Venues] PRIMARY KEY CLUSTERED (
    [VenueId] ASC
) WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , PAD_INDEX = OFF
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Venues]  WITH CHECK
ADD CONSTRAINT [FK_Venues_City] FOREIGN KEY([CityId])
REFERENCES [dbo].[Cities] ([CityId])
GO
-- ************************************************************** [Venues Indexes]
CREATE UNIQUE NONCLUSTERED INDEX [UIX_Venues_Name]
ON [dbo].[Venues] (
    [Name] ASC
) WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , FILLFACTOR = 70
    , PAD_INDEX = ON
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_Venues_City]
ON [dbo].[Venues] (
    [CityId] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_Venues_LastUpdated]
ON [dbo].[Venues] (
    [LastUpdatedBy] ASC,
    [LastUpdatedByDatetime] ASC
)
GO
-- ************************************************************* [Venues Procs]
-- ************************************************************* [Venues Views]
-- ********************************************************************************************************************** [Venues]
                                                                  


                                                                   
-- ********************************************************************************************************************** [Events]
CREATE TABLE [dbo].[Events]
(
    [EventId]                       [bigint] NOT NULL IDENTITY(1,1),
    [VenueId]                       [bigint] NOT NULL,
    [GameId]                        [bigint] NOT NULL,
    [Name]                          [nvarchar](240) NOT NULL,
    [Description]                   [nvarchar](240) NOT NULL,
    [StartDate]                     [datetime] NOT NULL,
    [EndDate]                       [datetime] NOT NULL,
    [TeamCount]                     [int] NOT NULL,
    [EventStatus]                   [bigint] NOT NULL,
    [AddedBy]                       [bigint] NOT NULL,
    [AddedByDatetime]               [datetime] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL,
    [LastUpdatedByDatetime]         [datetime] NOT NULL
);
GO
-- ************************************************************** [Events Constraints]
ALTER TABLE [dbo].[Events]
ADD CONSTRAINT [PK_Events] PRIMARY KEY CLUSTERED (
    [EventId] ASC
) WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , PAD_INDEX = OFF
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Events]  WITH CHECK 
ADD CONSTRAINT [FK_Events_Game] FOREIGN KEY([GameId])
REFERENCES [dbo].[Games] ([GameId])
GO

ALTER TABLE [dbo].[Events]  WITH CHECK 
ADD CONSTRAINT [FK_Events_Venue] FOREIGN KEY([VenueId])
REFERENCES [dbo].[Venues] ([VenueId])
GO

ALTER TABLE [dbo].[Events]  WITH CHECK 
ADD CONSTRAINT [FK_Events_Event_Status] FOREIGN KEY([EventStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
GO
-- ************************************************************** [Events Indexes]
CREATE UNIQUE NONCLUSTERED INDEX [UIX_Events_Name]
ON [dbo].[Events](
    [Name] ASC
)  WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , FILLFACTOR = 70
    , PAD_INDEX = ON
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_Events_Game_StartDate_EventStatus]
ON [dbo].[Events](
    [GameId] ASC,
    [StartDate] ASC,
    [EventStatus] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_Events_StartDate_EndDate]
ON [dbo].[Events](
    [StartDate] ASC,
    [EndDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_Events_StartDate]
ON [dbo].[Events](
    [StartDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_Events_EventStatus]
ON [dbo].[Events](
    [EventStatus] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_Events_Venue]
ON [dbo].[Events](
    [VenueId] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_Events_LastUpdated]
ON [dbo].[Events](
    [LastUpdatedBy] ASC,
    [LastUpdatedByDatetime] ASC
)
GO
-- ************************************************************** [Events Procs]
-- ************************************************************** [Events Views]
-- ********************************************************************************************************************** [Events]
                                                                  



-- ********************************************************************************************************************** [EventRegistrations]
CREATE TABLE [dbo].[EventRegistrations]
(
    [EventRegistrationId]           [bigint] NOT NULL IDENTITY(1,1),
    [EventId]                       [bigint] NOT NULL,
    [UserTeamId]                    [bigint] NOT NULL,
    [Placement]                     [int] NULL,
    [IsApproved]                    [bit] NOT NULL,
    [IsVerified]                    [bit] NOT NULL,
    [AddedBy]                       [bigint] NOT NULL,
    [AddedByDatetime]               [datetime] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL,
    [LastUpdatedByDatetime]         [datetime] NOT NULL
);
GO
-- ************************************************************** [EventRegistrations Constraints]
ALTER TABLE [dbo].[EventRegistrations]
ADD CONSTRAINT [PK_EventRegistrations] PRIMARY KEY CLUSTERED (
    [EventRegistrationId] ASC
) WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , PAD_INDEX = OFF
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[EventRegistrations]  WITH CHECK
ADD CONSTRAINT [FK_EventRegistration_Event] FOREIGN KEY([EventId])
REFERENCES [dbo].[Events] ([EventId])
GO

ALTER TABLE [dbo].[EventRegistrations]  WITH CHECK
ADD CONSTRAINT [FK_EventRegistration_UserTeam] FOREIGN KEY([UserTeamId])
REFERENCES [dbo].[UserTeams] ([UserTeamId])
GO
-- ************************************************************** [EventRegistrations Indexes]
CREATE NONCLUSTERED INDEX [IX_EventRegistrations_Event]
ON [dbo].[EventRegistrations](
    [EventId] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_EventRegistrations_Event_IsApproved_IsVerified]
ON [dbo].[EventRegistrations](
    [EventId] ASC,
    [IsApproved] ASC,
    [IsVerified] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_EventRegistrations_UserTeam]
ON [dbo].[EventRegistrations](
    [UserTeamId] ASC
)
GO

CREATE UNIQUE NONCLUSTERED INDEX [UIX_EventRegistrations_UserTeam_Event]
ON [dbo].[EventRegistrations](
    [UserTeamId] ASC,
    [EventId] ASC
) WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , FILLFACTOR = 70
    , PAD_INDEX = ON
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_EventRegistrations_LastUpdated]
ON [dbo].[EventRegistrations](
    [LastUpdatedBy] ASC,
    [LastUpdatedByDatetime] ASC
)
GO
-- ************************************************************** [EventRegistrations Procs]
-- ************************************************************** [EventRegistrations Views]
-- ********************************************************************************************************************** [EventRegistrations]



                                                                   
-- ********************************************************************************************************************** [Matches]
CREATE TABLE [dbo].[Matches]
(
    [MatchId]                       [bigint] NOT NULL IDENTITY(1,1),
    [Team1RegistrationId]           [bigint] NOT NULL,
    [Team2RegistrationId]           [bigint] NOT NULL,
    [WinnerId]                      [bigint] NULL,
    [Team1Score]                    [int] NULL,
    [Team2Score]                    [int] NULL,
    [AddedBy]                       [bigint] NOT NULL,
    [AddedByDatetime]               [datetime] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL,
    [LastUpdatedByDatetime]         [datetime] NOT NULL
);
GO
-- ************************************************************** [Matches Constraints]
ALTER TABLE [dbo].[Matches]
ADD CONSTRAINT [PK_Matches] PRIMARY KEY CLUSTERED (
    [MatchId] ASC
) WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , PAD_INDEX = OFF
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Matches]  WITH CHECK
ADD CONSTRAINT [FK_Matches_Team1RegistrationId] FOREIGN KEY([Team1RegistrationId])
REFERENCES [dbo].[EventRegistrations] ([EventRegistrationId])
GO

ALTER TABLE [dbo].[Matches]  WITH CHECK
ADD CONSTRAINT [FK_Matches_Team2RegistrationId] FOREIGN KEY([Team2RegistrationId])
REFERENCES [dbo].[EventRegistrations] ([EventRegistrationId])
GO

ALTER TABLE [dbo].[Matches]  WITH CHECK
ADD CONSTRAINT [FK_Matches_Winner] FOREIGN KEY([WinnerId])
REFERENCES [dbo].[EventRegistrations] ([EventRegistrationId])
GO
-- ************************************************************** [Matches Indexes]
CREATE NONCLUSTERED INDEX [IX_Matches_Team1RegistrationId]
ON [dbo].[Matches](
    [Team1RegistrationId] ASC
) 
GO

CREATE NONCLUSTERED INDEX [IX_Matches_Team2RegistrationId]
ON [dbo].[Matches](
    [Team2RegistrationId] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_Matches_Team1RegistrationId_Team2RegistrationId_EventRegistration]
ON [dbo].[Matches](
    [Team1RegistrationId] ASC,
    [Team2RegistrationId] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_Matches_Winner]
ON [dbo].[Matches](
    [WinnerId] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_Matches_LastUpdated]
ON [dbo].[Matches](
    [LastUpdatedBy] ASC,
    [LastUpdatedByDatetime] ASC
)
GO
-- ************************************************************** [Matches Procs]
-- ************************************************************** [Matches Views]
-- ********************************************************************************************************************** [Matches]











-- *************************************************************** [Clean Up]
-- *************************************************************** [Drop Procedures and Functions]

DROP PROCEDURE [dbo].[uspGetErrorInfo]
GO

DROP PROCEDURE [dbo].[uspInsertStatus]
GO

DROP PROCEDURE [dbo].[uspUpdateStatus]
GO

DROP FUNCTION [dbo].[udfUserIsAdmin]
GO


-- *************************************************************** [Drop Constraints]

ALTER TABLE [dbo].[Statuses]  DROP CONSTRAINT [PK_Statuses] 
GO

ALTER TABLE [dbo].[AccountTypes]  DROP CONSTRAINT [PK_AccountTypes] 
GO

ALTER TABLE [dbo].[Access]  DROP CONSTRAINT [PK_Access] 
GO

ALTER TABLE [dbo].[Users]  DROP CONSTRAINT [PK_Users] 
GO

ALTER TABLE [dbo].[Users] DROP CONSTRAINT [FK_Users_AccessId]
GO

ALTER TABLE [dbo].[Users] DROP CONSTRAINT [FK_Users_AccountType]
GO

ALTER TABLE [dbo].[SocialNetworks]  DROP CONSTRAINT [PK_SocialNetworks] 
GO

ALTER TABLE [dbo].[Social]  DROP CONSTRAINT [PK_Social] 
GO

ALTER TABLE [dbo].[Social] DROP CONSTRAINT [FK_Social_SocialNetwork]
GO

ALTER TABLE [dbo].[Social] DROP CONSTRAINT [FK_Social_User]
GO

ALTER TABLE [dbo].[Games]  DROP CONSTRAINT [PK_Games] 
GO

ALTER TABLE [dbo].[Provinces]  DROP CONSTRAINT [PK_Provinces] 
GO

ALTER TABLE [dbo].[Cities]  DROP CONSTRAINT [PK_Cities] 
GO

ALTER TABLE [dbo].[Teams]  DROP CONSTRAINT [PK_Teams] 
GO

ALTER TABLE [dbo].[TeamGames]  DROP CONSTRAINT [PK_TeamGames] 
GO

ALTER TABLE [dbo].[UserTeams]  DROP CONSTRAINT [PK_UserTeams] 
GO

ALTER TABLE [dbo].[UserTeams] DROP CONSTRAINT [FK_UserTeams_User]
GO

ALTER TABLE [dbo].[UserTeams] DROP CONSTRAINT [FK_UserTeams_Team]
GO

ALTER TABLE [dbo].[AddressDetails]  DROP CONSTRAINT [PK_AddressDetails] 
GO

ALTER TABLE [dbo].[Venues]  DROP CONSTRAINT [PK_Venues] 
GO

ALTER TABLE [dbo].[Venues] DROP CONSTRAINT [FK_Venues_City]
GO

ALTER TABLE [dbo].[Events]  DROP CONSTRAINT [PK_Events] 
GO

ALTER TABLE [dbo].[Events] DROP CONSTRAINT [FK_Events_Game]
GO

ALTER TABLE [dbo].[Events] DROP CONSTRAINT [FK_Events_Venue]
GO

ALTER TABLE [dbo].[Events_Event_Status] DROP CONSTRAINT [FK_Events_Event_Status]
GO

ALTER TABLE [dbo].[EventRegistrations]  DROP CONSTRAINT [PK_EventRegistrations] 
GO

ALTER TABLE [dbo].[EventRegistration] DROP CONSTRAINT [FK_EventRegistration_Event]
GO

ALTER TABLE [dbo].[EventRegistration] DROP CONSTRAINT [FK_EventRegistration_UserTeam]
GO

ALTER TABLE [dbo].[Matches]  DROP CONSTRAINT [PK_Matches] 
GO

ALTER TABLE [dbo].[Matches] DROP CONSTRAINT [FK_Matches_Team1RegistrationId]
GO

ALTER TABLE [dbo].[Matches] DROP CONSTRAINT [FK_Matches_Team2RegistrationId]
GO

ALTER TABLE [dbo].[Matches] DROP CONSTRAINT [FK_Matches_Winner]
GO



-- *************************************************************** [Drop Indexes]

ALTER TABLE [dbo].[Access] DROP INDEX [UIX_Access_Username] 
GO

ALTER TABLE [dbo].[Access] DROP INDEX [IX_Access_Username_IsActive]
GO

ALTER TABLE [dbo].[Access] DROP INDEX [IX_Access_LastUpdated] 
GO

ALTER TABLE [dbo].[Access] DROP INDEX [UIX_Users_EmailAddress] 
GO

ALTER TABLE [dbo].[Access] DROP INDEX [UIX_Users_Access] 
GO

ALTER TABLE [dbo].[Users] DROP INDEX [IX_Users_FirstName_LastName] 
GO

ALTER TABLE [dbo].[Users] DROP INDEX [IX_Users_AccountType] 
GO

ALTER TABLE [dbo].[Users] DROP INDEX [IX_Users_LastUpdated] 
GO

ALTER TABLE [dbo].[SocialNetworks] DROP INDEX [UIX_SocialNetworks_Name] ON [dbo].[SocialNetworks]
GO

ALTER TABLE [dbo].[SocialNetworks] DROP INDEX [IX_SocialNetworks_LastUpdated] ON [dbo].[SocialNetworks]
GO

ALTER TABLE [dbo].[Social] DROP INDEX [IX_Social_User_SocialNetwork]
GO

ALTER TABLE [dbo].[Social] DROP INDEX [UIX_Social_SocialNetwork_Handle]
GO

ALTER TABLE [dbo].[Social] DROP INDEX [IX_Social_LastUpdated] 
GO

ALTER TABLE [dbo].[Games] DROP INDEX [UIX_Games_Name_Version]
GO

ALTER TABLE [dbo].[Games] DROP INDEX [IX_Games_Name]
GO

ALTER TABLE [dbo].[Provinces] DROP INDEX [UIX_Provinces_Name]
GO

ALTER TABLE [dbo].[Cities] DROP INDEX [IX_Cities_Name]
GO

ALTER TABLE [dbo].[Cities] DROP INDEX [UIX_Cities_Name_Province]
GO

ALTER TABLE [dbo].[Cities] DROP INDEX [IX_Cities_LastUpdated]
GO

ALTER TABLE [dbo].[Teams] DROP INDEX [UIX_Teams_Name]
GO

ALTER TABLE [dbo].[Teams] DROP INDEX [IX_Teams_LastUpdated]
GO

ALTER TABLE [dbo].[TeamGames] DROP INDEX [IX_TeamGames_Game]
GO

ALTER TABLE [dbo].[TeamGames] DROP INDEX [IX_TeamGames_TeamId]
GO

ALTER TABLE [dbo].[TeamGames] DROP INDEX [IX_TeamGames_LastUpdated]
GO

ALTER TABLE [dbo].[UserTeams] DROP INDEX [IX_UserTeams_User]
GO

ALTER TABLE [dbo].[UserTeams] DROP INDEX [IX_UserTeams_Team]
GO

ALTER TABLE [dbo].[UserTeams] DROP INDEX [IX_UserTeams_LastUpdated]
GO

ALTER TABLE [dbo].[AddressDetails] DROP INDEX [IX_AddressDetails_User]
GO

ALTER TABLE [dbo].[AddressDetails] DROP INDEX [UIX_AddressDetails_Address]
GO

ALTER TABLE [dbo].[AddressDetails] DROP INDEX [IX_AddressDetails_City]
GO

ALTER TABLE [dbo].[AddressDetails] DROP INDEX [IX_AddressDetails_Address_City]
GO

ALTER TABLE [dbo].[AddressDetails] DROP INDEX [IX_AddressDetails_LastUpdated]
GO

ALTER TABLE [dbo].[Venues] DROP INDEX [UIX_Venues_Name]
GO

ALTER TABLE [dbo].[Venues] DROP INDEX [IX_Venues_City]
GO

ALTER TABLE [dbo].[Venues] DROP INDEX [IX_Venues_LastUpdated]
GO

ALTER TABLE [dbo].[Events] DROP INDEX [UIX_Events_Name]
GO

ALTER TABLE [dbo].[Events] DROP INDEX [IX_Events_Game_StartDate_EventStatus]
GO

ALTER TABLE [dbo].[Events] DROP INDEX [IX_Events_StartDate_EndDate]
GO

ALTER TABLE [dbo].[Events] DROP INDEX [IX_Events_StartDate]
GO

ALTER TABLE [dbo].[Events] DROP INDEX [IX_Events_EventStatus]
GO

ALTER TABLE [dbo].[Events] DROP INDEX [IX_Events_Venue]
GO

ALTER TABLE [dbo].[Events] DROP INDEX [IX_Events_LastUpdated]
GO

ALTER TABLE [dbo].[EventRegistrations] DROP INDEX [IX_EventRegistrations_Event]
GO

ALTER TABLE [dbo].[EventRegistrations] DROP INDEX [IX_EventRegistrations_Event_IsApproved_IsVerified]
GO

ALTER TABLE [dbo].[EventRegistrations] DROP INDEX [IX_EventRegistrations_UserTeam]
GO

ALTER TABLE [dbo].[EventRegistrations] DROP INDEX [UIX_EventRegistrations_UserTeam_Event]
GO

ALTER TABLE [dbo].[EventRegistrations] DROP INDEX [IX_EventRegistrations_LastUpdated]
GO

ALTER TABLE [dbo].[Matches] DROP INDEX [IX_Matches_Team1RegistrationId]
GO

ALTER TABLE [dbo].[Matches] DROP INDEX [IX_Matches_Team2RegistrationId]
GO

ALTER TABLE [dbo].[Matches] DROP INDEX [IX_Matches_Team1RegistrationId_Team2RegistrationId_EventRegistration]
GO

ALTER TABLE [dbo].[Matches] DROP INDEX [IX_Matches_Winner]
GO

ALTER TABLE [dbo].[Matches] DROP INDEX [IX_Matches_LastUpdated]
GO


-- *************************************************************** [Drop Tables]
DROP TABLE [dbo].[Statuses]
GO

DROP TABLE [dbo].[AccountTypes]
GO

DROP TABLE [dbo].[Access]
GO

DROP TABLE [dbo].[Users]
GO

DROP TABLE [dbo].[SocialNetworks]
GO

DROP TABLE [dbo].[Social]
GO

DROP TABLE [dbo].[Games]
GO

DROP TABLE [dbo].[AddressDetails]
GO

DROP TABLE [dbo].[Provinces]
GO

DROP TABLE [dbo].[Cities]
GO

DROP TABLE [dbo].[Teams]
GO

DROP TABLE [dbo].[TeamGames]
GO

DROP TABLE [dbo].[UserTeams]
GO

DROP TABLE [dbo].[Venues]
GO

DROP TABLE [dbo].[Events]
GO

DROP TABLE [dbo].[EventRegistrations]
GO

DROP TABLE [dbo].[Matches]
GO

