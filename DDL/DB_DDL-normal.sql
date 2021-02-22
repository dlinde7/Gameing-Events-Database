-- ****************** SqlDBM: MySQL ******************;
-- *******************************************************************************************;

USE master
IF EXISTS(select * from sys.databases where name="GameTorunamentCompanyDB")
DROP DATABASE GameTorunamentCompanyDB

CREATE DATABASE GameTorunamentCompanyDB;
GO

USE GameTorunamentCompanyDB;
GO

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
-- ************************************************************** [Statuses Procs]
-- ************************************************************** [Statuses Views]
-- ********************************************************************************************************************** [Statuses]
                                                                  

  
  
-- ********************************************************************************************************************** [AccountType]
CREATE TABLE [dbo].[AccountType](
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
ALTER TABLE [dbo].[AccountType]
ADD CONSTRAINT [PK_AccountType] PRIMARY KEY CLUSTERED ([AccountTypeId] ASC)
GO
-- ************************************************************* [AccountType Procs]
-- ************************************************************* [AccountType Views]
-- ********************************************************************************************************************** [AccountType]
                                                                  


                                                                   
-- ********************************************************************************************************************** [Access]
CREATE TABLE [dbo].[Access](
    [AccessId]                      [bigint] NOT NULL,
    [Password]                      [binary ]NOT NULL,
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

ALTER TABLE [dbo].[Access]  WITH CHECK ADD  CONSTRAINT [FK_Access_AdminPrivilages_Status] FOREIGN KEY([AdminPrivilagesStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
GO

ALTER TABLE [dbo].[Access]  WITH CHECK ADD  CONSTRAINT [FK_Access_IsActive_Status] FOREIGN KEY([IsActiveStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
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
    [Username]                      [nvarchar](120) NOT NULL,
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

ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_AccessId] FOREIGN KEY([AccessId])
REFERENCES [dbo].[Access] ([AccessId])
GO

-- Make Email unique
-- Make Contact Number unique
-- Make AccessId unique

ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_AccountType] FOREIGN KEY([AccountTypeId])
REFERENCES [dbo].[AccountTypes] ([AccountTypeId])
GO

ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_Email_Status] FOREIGN KEY([EmailVerifiedStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
GO

ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_ContactNumber_Status] FOREIGN KEY([ContactNumberVerifiedStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
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

ALTER TABLE [dbo].[Social]  WITH CHECK ADD  CONSTRAINT [FK_Social_SocialNetwork] FOREIGN KEY([SocialNetworkId])
REFERENCES [dbo].[SocialNetworks] ([SocialNetworkId])
GO

ALTER TABLE [dbo].[Social]  WITH CHECK ADD  CONSTRAINT [FK_Social_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
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
    [Releasedate]                   [date] NOT NULL,
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

ALTER TABLE [dbo].[Teams]  WITH CHECK ADD  CONSTRAINT [FK_Teams_ReceiveNotifications_Status] FOREIGN KEY([ReceieveNotificationsStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
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

ALTER TABLE [dbo].[UserTeams]  WITH CHECK ADD  CONSTRAINT [FK_UserTeams_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO

ALTER TABLE [dbo].[UserTeams]  WITH CHECK ADD  CONSTRAINT [FK_UserTeams_Team] FOREIGN KEY([TeamId])
REFERENCES [dbo].[Teams] ([TeamId])
GO

ALTER TABLE [dbo].[UserTeams]  WITH CHECK ADD  CONSTRAINT [FK_UserTeams_IsActive_Status] FOREIGN KEY([IsActiveStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
GO

ALTER TABLE [dbo].[UserTeams]  WITH CHECK ADD  CONSTRAINT [FK_UserTeams_EditPrivilages_Status] FOREIGN KEY([EditPrivilagesStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
GO

ALTER TABLE [dbo].[UserTeams]  WITH CHECK ADD  CONSTRAINT [FK_UserTeams_TeamCaptain_Status] FOREIGN KEY([TeamCaptainStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
GO
-- ************************************************************* [UserTeams Procs]
-- ************************************************************* [UserTeams Views]
-- ********************************************************************************************************************** [userTeams]
                                                                  

                                                                   

-- ********************************************************************************************************************** [AddressDetails]
CREATE TABLE [dbo].[AddressDetails](
    [AddressDetailId]               [bigint] NOT NULL,
    [Addressline]                   [nvarchar](120) NOT NULL,
    [CityId]                        [bigint] NULL,
    [UserId]                        [bigint] NOT NULL,
    [IsActiveStatus]                [bigint] NOT NULL,
    [AddedBy]                       [bigint] NOT NULL,
    [AddedByDatetime]               [datetime] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL,
    [LastUpdatedBYDatetime]         [datetime] NOT NULL
);
GO
-- ************************************************************** [AddressDetails Contraints]
ALTER TABLE [dbo].[AddressDetails]
ADD CONSTRAINT [PK_AddressDetails] PRIMARY KEY CLUSTERED ([AddressDetailId] ASC)
GO

ALTER TABLE [dbo].[AddressDetails]  WITH CHECK ADD  CONSTRAINT [FK_AddressDetails_IsActive_Status] FOREIGN KEY([IsActiveStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
GO
-- ************************************************************** [AddressDetails Procs]
-- ************************************************************** [AddressDetails Views]
-- ********************************************************************************************************************** [AddressDetails]



                                                                   
-- ********************************************************************************************************************** [Venues]
CREATE TABLE [dbo].[Venues]
(
    [VenueId]                       [bigint] NOT NULL,
    [Name]                          [nvarchar](120) NOT NULL,
    [Addresss]                      [nvarchar](400) NULL,
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

ALTER TABLE [dbo].[Venues]  WITH CHECK ADD  CONSTRAINT [FK_Venues_City] FOREIGN KEY([CityId])
REFERENCES [dbo].[Cities] ([CityId])
GO

ALTER TABLE [dbo].[Venues]  WITH CHECK ADD  CONSTRAINT [FK_Venues_IsActive_Status] FOREIGN KEY([IsActiveStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
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

ALTER TABLE [dbo].[Events]  WITH CHECK ADD  CONSTRAINT [FK_Events_Game] FOREIGN KEY([GameId])
REFERENCES [dbo].[Games] ([GameId])
GO

ALTER TABLE [dbo].[Events]  WITH CHECK ADD  CONSTRAINT [FK_Events_Venue] FOREIGN KEY([VenueId])
REFERENCES [dbo].[Venues] ([VenueId])
GO

ALTER TABLE [dbo].[Events]  WITH CHECK ADD  CONSTRAINT [FK_Events_Event_Status] FOREIGN KEY([EventStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
GO
-- ************************************************************** [Events Procs]
-- ************************************************************** [Events Views]
-- ********************************************************************************************************************** [Events]
                                                                  



-- ********************************************************************************************************************** [EventRegistrations]
CREATE TABLE [dbo].[EventRegistrations]
(
    [EventRegistrationId]           [bigint] NOT NULL,
    [Tmstamp]                       [datetime] NOT NULL,
    [EventId]                       [bigint] NOT NULL,
    [UserTeamId]                    [bigint] NOT NULL,
    [Placement]                     [int] NULL,
    [IsQualifiedStatus]             [bigint] NOT NULL,
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

ALTER TABLE [dbo].[EventRegistrations]  WITH CHECK ADD  CONSTRAINT [FK_EventRegistration_Event] FOREIGN KEY([EventId])
REFERENCES [dbo].[Events] ([EventId])
GO

ALTER TABLE [dbo].[EventRegistrations]  WITH CHECK ADD  CONSTRAINT [FK_EventRegistration_UserTeam] FOREIGN KEY([UserTeamId])
REFERENCES [dbo].[UserTeams] ([UserTeamId])
GO

ALTER TABLE [dbo].[EventRegistrations]  WITH CHECK ADD  CONSTRAINT [FK_EventRegistration_IsQualified_Status] FOREIGN KEY([IsQualifiedStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
GO

ALTER TABLE [dbo].[EventRegistrations]  WITH CHECK ADD  CONSTRAINT [FK_EventRegistration_IsVerified_Status] FOREIGN KEY([IsVerifiedStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
GO
-- ************************************************************** [EventRegistrations Procs]
-- ************************************************************** [EventRegistrations Views]
-- ********************************************************************************************************************** [EventRegistrations]



                                                                   
-- ********************************************************************************************************************** [Matches]
CREATE TABLE [dbo].[Matches]
(
    [MatchId]                       [bigint] NOT NULL,
    [Team1Id]                       [bigint] NOT NULL,
    [Team2Id]                       [bigint] NOT NULL,
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

ALTER TABLE [dbo].[Matches]  WITH CHECK ADD  CONSTRAINT [FK_Matches_Team1] FOREIGN KEY([Team1Id])
REFERENCES [dbo].[EventRegistrations] ([EventRegistrationId])
GO

ALTER TABLE [dbo].[Matches]  WITH CHECK ADD  CONSTRAINT [FK_Matches_Team2] FOREIGN KEY([Team2Id])
REFERENCES [dbo].[EventRegistrations] ([EventRegistrationId])
GO

ALTER TABLE [dbo].[Matches]  WITH CHECK ADD  CONSTRAINT [FK_Matches_Winner] FOREIGN KEY([WinnerId])
REFERENCES [dbo].[EventRegistrations] ([EventRegistrationId])
GO
-- ************************************************************** [Matches Procs]
-- ************************************************************** [Matches Views]
-- ********************************************************************************************************************** [Matches]