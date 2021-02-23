-- ****************** SqlDBM: MySQL ******************;
-- *******************************************************************************************;

USE master
IF EXISTS(select * from sys.databases where name="GameTorunamentCompanyDB")
DROP DATABASE GameTorunamentCompanyDB

CREATE DATABASE GameTorunamentCompanyDB;
GO

USE GameTorunamentCompanyDB;
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
    [StatusId]                      [bigint] NOT NULL,
    [Name]                          [nvarchar](40) NOT NULL,
    [Description]                   [nvarchar](2000) NULL,
    [AddedBy]                       [bigint] NOT NULL,
    [AddedByDatetime]               [datetime] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL,
    [LastUpdatedByDatetime]         [datetime] NOT NULL
);
GO
-- ************************************************************** [Statuses Constraints]
ALTER TABLE [dbo].[Statuses]
ADD CONSTRAINT [PK_Statuses] PRIMARY KEY CLUSTERED ([StatusId] ASC)
GO

CREATE SEQUENCE [dbo].[seqStatusId]
    AS bigint
    START WITH 1
    INCREMENT BY 1;
GO
-- ************************************************************** [Access Indexes]
CREATE UNIQUE NONCLUSTERED INDEX [UIX_Statuses_Name] 
ON [dbo].[Statuses](
    [Name] ASC
)
GO
-- ************************************************************** [Statuses Procs]
CREATE PROCEDURE [dbo].[uspInsertStatus]
    @Name nvarchar(40),
    @Description nvarchar(2000) = NULL,
    @UserId bigint
AS
BEGIN TRY
    BEGIN TRAN
        MERGE INTO [dbo].[Statuses] s USING(
            VALUES
                (@Name, @Description)
        )
        AS se (Name, Description)
        AND se.Name = s.Name
        WHEN MATCHED THEN
            UPDATE SET
                s.Description = s.Description,
                s.LastUpdatedBy = @UserId,
                s.LastUpdatedByDatetime = GETDATE()
        WHEN NOT MATCHED THEN 
            INSERT (StatusId, Name, Description, AddedBy, AddedByDateTime, LastUpdatedBy, LastUpdatedByDatetime)
            VALUES (NEXT VALUE FOR [dbo].[seqStatuses], se.Name, se.Description, @UserId, GETDATE(), @UserId, GETDATE())
    COMMIT
END TRY
BEGIN CATCH
    ROLLBACK
    EXECUTE [dbo].[uspGetErrorInfo];
END CATCH
GO 
-- ************************************************************** [Statuses Views]
-- ************************************************************** [Statuses Base Data]
-- ********************************************************************************************************************** [Statuses]                                                               
  
  
-- ********************************************************************************************************************** [AccountTypes]
CREATE TABLE [dbo].[AccountTypes](
    [AccountTypeId]                 [bigint] NOT NULL,
    [Name]                          [nvarchar](120) NOT NULL,
    [Description]                   [nvarchar](4000) NOT NULL,
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
)
GO
-- ************************************************************** [Access Indexes]
CREATE UNIQUE NONCLUSTERED INDEX [UIX_AccountTypes_Name]
ON [dbo].[AccountTypes](
	[Name] ASC
)
GO
-- ************************************************************* [AccountType Procs]
-- ************************************************************* [AccountType Views]
-- ********************************************************************************************************************** [AccountType]
                                                                  


                                                                   
-- ********************************************************************************************************************** [Access]
CREATE TABLE [dbo].[Access](
    [AccessId]                      [bigint] NOT NULL,
    [Password]                      [binary ]NOT NULL,
    [Username]                      [nvarchar](120) NOT NULL,
    [SecurityKey]                   [nvarchar](120) NOT NULL,
    [DateCreated]                   [datetime] NOT NULL,
    [AdminPrivilagesStatus]         [bigint] NOT NULL,
    [IsActiveStatus]                [bigint] NOT NULL,
    [AddedBy]                       [bigint] NOT NULL,
    [AddedByDatetime]               [datetime] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL,
    [LastUpdatedByDatetime]         [datetime] NOT NULL
);
GO
-- ************************************************************** [Access Contraints]
ALTER TABLE [dbo].[Access]
ADD CONSTRAINT [PK_Access] PRIMARY KEY CLUSTERED ([AccessId] ASC)
GO

ALTER TABLE [dbo].[Access] WITH CHECK 
ADD CONSTRAINT [FK_Access_AdminPrivilages_Status] FOREIGN KEY([AdminPrivilagesStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
GO

ALTER TABLE [dbo].[Access]  WITH CHECK
ADD CONSTRAINT [FK_Access_IsActive_Status] FOREIGN KEY([IsActiveStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
GO
-- ************************************************************** [Access Indexes]
CREATE UNIQUE NONCLUSTERED INDEX [UIX_Access_Username] 
ON [dbo].[Access](
    [Username] ASC
)
GO
CREATE NONCLUSTERED INDEX [IX_Access_LastUpdated] 
ON [dbo].[Access](
    [LastUpdatedBy] ASC,
    [LastUpdatedByDatetime] ASC
)
GO
-- ************************************************************* [Access Procs]
-- ************************************************************* [Access Views]
-- ********************************************************************************************************************** [Access]
                                                                  



-- ********************************************************************************************************************** [Users]
CREATE TABLE [dbo].[Users]
(
    [UserId]                        [bigint] NOT NULL,
    [AccessId]                      [bigint] NOT NULL,
    [FirstName]                     [nvarchar](120) NOT NULL,
    [LastName]                      [nvarchar](120) NOT NULL,
    [DateOfBirth]                   [date] NOT NULL,
    [AccountTypeId]                 [bigint] NULL,
    [EmailAddress]                  [nvarchar](120) NOT NULL,
    [ContactNumber]                 [varchar](40) NOT NULL,
    [EmailVerifiedStatus]           [bigint] NOT NULL,
    [ContactNumberVerifiedStatus]   [bigint] NOT NULL,
    [AddedBy]                       [bigint] NOT NULL,
    [AddedByDateTime]               [datetime] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL,
    [LastUpdatedByDatetime]         [datetime] NOT NULL
);
GO
-- ************************************************************** [Users Constraints]
ALTER TABLE [dbo].[Users]
ADD CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([UserId] ASC)
GO

ALTER TABLE [dbo].[Users]  WITH CHECK 
ADD CONSTRAINT [FK_Users_AccessId] FOREIGN KEY([AccessId])
REFERENCES [dbo].[Access] ([AccessId])
GO

ALTER TABLE [dbo].[Users]  WITH CHECK
ADD CONSTRAINT [FK_Users_AccountType] FOREIGN KEY([AccountTypeId])
REFERENCES [dbo].[AccountTypes] ([AccountTypeId])
GO

ALTER TABLE [dbo].[Users]  WITH CHECK
ADD CONSTRAINT [FK_Users_Email_Status] FOREIGN KEY([EmailVerifiedStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
GO

ALTER TABLE [dbo].[Users]  WITH CHECK
ADD CONSTRAINT [FK_Users_ContactNumber_Status] FOREIGN KEY([ContactNumberVerifiedStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
GO
-- ************************************************************** [Users Indexes]
CREATE UNIQUE NONCLUSTERED INDEX [UIX_Users_EmailAddress] 
ON [dbo].[Users](
    [EmailAddress] ASC
)
GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_Users_ContactNumber] 
ON [dbo].[Users](
    [ContactNumber] ASC
)
GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_Users_Access] 
ON [dbo].[Users](
    [AccessId] ASC
)
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
-- ************************************************************** [Users Views]
-- ********************************************************************************************************************** [Users]
                                                                  



-- ********************************************************************************************************************** [SocialNetworks]
CREATE TABLE [dbo].[SocialNetworks]
(
    [SocialNetworkId]               [bigint] NOT NULL,
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
ADD CONSTRAINT [PK_SocialNetworks] PRIMARY KEY CLUSTERED ([SocialNetworkId] ASC)
GO
-- ************************************************************** [SocialNetworks Indexes]
CREATE UNIQUE NONCLUSTERED INDEX [UIX_SocialNetworks_Name] ON [dbo].[SocialNetworks]
(
    [Name] ASC
)
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
    [SocialId]                      [bigint] NOT NULL,
    [UserId]                        [bigint] NOT NULL
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
ADD CONSTRAINT [PK_Social] PRIMARY KEY CLUSTERED ([SocialId] ASC)
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
)
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
    [GameId]                        [bigint] NOT NULL,
    [Name]                          [nvarchar](120) NOT NULL,
    [Description]                   [nvarchar](4000) NOT NULL,
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
ADD CONSTRAINT [PK_Games] PRIMARY KEY CLUSTERED ([GameId] ASC)
GO
-- ************************************************************** [Games Indexes]
CREATE UNIQUE NONCLUSTERED INDEX [UIX_Games_Name_Version]
ON [dbo].[Games](
    [Name] ASC,
    [Version] ASC
)
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
    [ProvinceId]                    [bigint] NOT NULL,
    [Name]                          [nvarchar](120) NOT NULL,
    [AddedBy]                       [bigint] NOT NULL,
    [AddedByDatetime]               [datetime] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL,
    [LastUpdatedByDatetime]         [datetime] NOT NULL
);
GO
-- ************************************************************** [Provinces Contraints]
ALTER TABLE [dbo].[Provinces]
ADD CONSTRAINT [PK_Provinces] PRIMARY KEY CLUSTERED ([ProvinceId] ASC)
GO
-- ************************************************************** [Provinces Indexes]
CREATE UNIQUE NONCLUSTERED INDEX [UIX_Provinces_Name]
ON [dbo].[Provinces](
    [Name] ASC
)
GO
-- ************************************************************** [Provinces Procs]
-- ************************************************************** [Provinces Views]
-- ********************************************************************************************************************** [Provinces]
                                                                  



-- ********************************************************************************************************************** [Cities]
CREATE TABLE [dbo].[Cities](
    [CityId]                        [bigint] NOT NULL,
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
ADD CONSTRAINT [PK_Cities] PRIMARY KEY CLUSTERED ([CityId] ASC)
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
)
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
    [TeamId]                        [bigint] NOT NULL,
    [Slogan]                        [nvarchar](200) NOT NULL,
    [Name]                          [nvarchar](120) NOT NULL,
    [Logo]                          [binary](4000) NOT NULL,
    [ReceieveNotificationsStatus]   [bigint] NOT NULL
    [AddedBy]                       [bigint] NOT NULL,
    [AddedByDatetime]               [datetime] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL,
    [LastUpdatedByDatetime]         [datetime] NOT NULL,
);
GO
-- ************************************************************** [Teams Constraints]
ALTER TABLE [dbo].[Teams]
ADD CONSTRAINT [PK_Teams] PRIMARY KEY CLUSTERED ([TeamId] ASC)
GO

ALTER TABLE [dbo].[Teams]  WITH CHECK
ADD CONSTRAINT [FK_Teams_ReceiveNotifications_Status] FOREIGN KEY([ReceieveNotificationsStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
GO
-- ************************************************************** [Teams Indexes]
CREATE UNIQUE NONCLUSTERED INDEX [UIX_Teams_Name]
ON [dbo].[Teams](
    [Name] ASC
)
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
    [TeamGameId]                    [bigint] NOT NULL,
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
ADD CONSTRAINT [PK_TeamGames] PRIMARY KEY CLUSTERED ([TeamGameId] ASC)
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
    [UserTeamId]                    [bigint] NOT NULL,
    [UserId]                        [bigint] NOT NULL,
    [TeamId]                        [bigint] NOT NULL,
    [IsActiveStatus]                [bigint] NOT NULL,
    [EditPrivilagesStatus]          [bigint] NOT NULL,
    [TeamCaptainStatus]             [bigint] NOT NULL,
    [LastUpdatedByDatetime]         [datetime] NULL,
    [AddedBy[DateTime]              [datetime] NULL,
    [AddedBy]                       [bigint] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL
);
GO
-- ************************************************************** [UserTeams Contraints]
ALTER TABLE [dbo].[UserTeams]
ADD CONSTRAINT [PK_UserTeams] PRIMARY KEY CLUSTERED ([UserTeamId] ASC)
GO

ALTER TABLE [dbo].[UserTeams]  WITH CHECK
ADD CONSTRAINT [FK_UserTeams_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO

ALTER TABLE [dbo].[UserTeams]  WITH CHECK
ADD CONSTRAINT [FK_UserTeams_Team] FOREIGN KEY([TeamId])
REFERENCES [dbo].[Teams] ([TeamId])
GO

ALTER TABLE [dbo].[UserTeams]  WITH CHECK
ADD CONSTRAINT [FK_UserTeams_IsActive_Status] FOREIGN KEY([IsActiveStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
GO

ALTER TABLE [dbo].[UserTeams]  WITH CHECK
ADD CONSTRAINT [FK_UserTeams_EditPrivilages_Status] FOREIGN KEY([EditPrivilagesStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
GO

ALTER TABLE [dbo].[UserTeams]  WITH CHECK
ADD CONSTRAINT [FK_UserTeams_TeamCaptain_Status] FOREIGN KEY([TeamCaptainStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
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
    [AddressDetailId]               [bigint] NOT NULL,
    [Address]                       [nvarchar](1000) NOT NULL, -- NEEDS WORK
    [CityId]                        [bigint] NULL,
    [UserId]                        [bigint] NOT NULL,
    [IsActiveStatus]                [bigint] NOT NULL,
    [AddedBy]                       [bigint] NOT NULL,
    [AddedByDatetime]               [datetime] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL,
    [LastUpdatedByDatetime]         [datetime] NOT NULL
);
GO
-- ************************************************************** [AddressDetails Contraints]
ALTER TABLE [dbo].[AddressDetails]
ADD CONSTRAINT [PK_AddressDetails] PRIMARY KEY CLUSTERED ([AddressDetailId] ASC)
GO

ALTER TABLE [dbo].[AddressDetails]  WITH CHECK 
ADD CONSTRAINT [FK_AddressDetails_IsActive_Status] FOREIGN KEY([IsActiveStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
GO
-- ************************************************************** [AddressDetails Indexes]
CREATE NONCLUSTERED INDEX [IX_AddressDetails_User]
ON [dbo].[AddressDetails](
    [UserId] ASC
)
GO

CREATE UNIQUE NONCLUSTERED INDEX [UIX_AddressDetails_Address]
ON [dbo].[AddressDetails](
    [Address] ASC   --NNEDS WORK (CANNOT ENSURE UNIQUE VALUES)
)
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
    [VenueId]                       [bigint] NOT NULL,
    [Name]                          [nvarchar](120) NOT NULL,
    [Address]                       [nvarchar](400) NULL,       -- NEEDS WORK
    [Website]                       [nvarchar](120) NULL,
    [CityId]                        [bigint] NOT NULL,
    [IsActiveStatus]                [bigint] NOT NULL
    [AddedBy]                       [bigint] NOT NULL,
    [AddedByDatetime]               [datetime] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL,
    [LastUpdatedByDatetime]         [datetime] NOT NULL
);
GO
-- ************************************************************** [Venues Contraints]
ALTER TABLE [dbo].[Venues]
ADD CONSTRAINT [PK_Venues] PRIMARY KEY CLUSTERED ([VenueId] ASC)
GO

ALTER TABLE [dbo].[Venues]  WITH CHECK
ADD CONSTRAINT [FK_Venues_City] FOREIGN KEY([CityId])
REFERENCES [dbo].[Cities] ([CityId])
GO

ALTER TABLE [dbo].[Venues]  WITH CHECK
ADD CONSTRAINT [FK_Venues_IsActive_Status] FOREIGN KEY([IsActiveStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
GO
-- ************************************************************** [Venues Indexes]
CREATE UNIQUE NONCLUSTERED INDEX [UIX_Venues_Name]
ON [dbo].[Venues] (
    [Name] ASC
)
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
    [EventId]                       [bigint] NOT NULL,
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
ADD CONSTRAINT [PK_Events] PRIMARY KEY CLUSTERED ([EventId] ASC)
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
)
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

CREATE NONCLUSTERED INDEX [IX_Events_StartDate_EndDate]
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
    [EventRegistrationId]           [bigint] NOT NULL,
    [EventId]                       [bigint] NOT NULL,
    [UserTeamId]                    [bigint] NOT NULL,
    [Placement]                     [int] NULL,
    [IsApprovedStatus]              [bigint] NOT NULL,
    [IsVerifiedStatus]              [bigint] NOT NULL,
    [AddedBy]                       [bigint] NOT NULL,
    [AddedByDatetime]               [datetime] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL,
    [LastUpdatedByDatetime]         [datetime] NOT NULL
);
GO
-- ************************************************************** [EventRegistrations Constraints]
ALTER TABLE [dbo].[EventRegistrations]
ADD CONSTRAINT [PK_EventRegistrations] PRIMARY KEY CLUSTERED ([EventRegistrationId] ASC)
GO

ALTER TABLE [dbo].[EventRegistrations]  WITH CHECK
ADD CONSTRAINT [FK_EventRegistration_Event] FOREIGN KEY([EventId])
REFERENCES [dbo].[Events] ([EventId])
GO

ALTER TABLE [dbo].[EventRegistrations]  WITH CHECK
ADD CONSTRAINT [FK_EventRegistration_UserTeam] FOREIGN KEY([UserTeamId])
REFERENCES [dbo].[UserTeams] ([UserTeamId])
GO

ALTER TABLE [dbo].[EventRegistrations]  WITH CHECK
ADD CONSTRAINT [FK_EventRegistration_IsQualified_Status] FOREIGN KEY([IsQualifiedStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
GO

ALTER TABLE [dbo].[EventRegistrations]  WITH CHECK
ADD CONSTRAINT [FK_EventRegistration_IsVerified_Status] FOREIGN KEY([IsVerifiedStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
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
    [IsApprovedStatus] ASC,
    [IsVerifiedStatus] ASC
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
)
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
    [MatchId]                       [bigint] NOT NULL,
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
ADD CONSTRAINT [PK_Matches] PRIMARY KEY CLUSTERED ([MatchId] ASC)
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