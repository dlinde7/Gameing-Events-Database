ALTER TABLE [dbo].[AddressDetails] DROP INDEX [IX_AddressDetails_Address_City]
GO

ALTER TABLE [dbo].[AddressDetails] DROP INDEX [UIX_AddressDetails_Address]
GO

ALTER TABLE [dbo].[AddressDetails] DROP COLUMN [Address]
GO

ALTER TABLE [dbo].[Venues] DROP COLUMN [Address]
GO

ALTER TABLE [dbo].[AddressDetails] DROP COLUMN [IsActive]
GO

CREATE TABLE [dbo].[EventSchedules](
    [EventScheduleId]               [bigint] NOT NULL IDENTITY(1,1),
    [EventId]                       [bigint] NOT NULL,
    [VenueId]                       [bigint] NOT NULL,
    [StartDate]                     [datetime] NOT NULL,
    [EndDate]                       [datetime] NOT NULL,
    [EventStatus]                   [bigint] NOT NULL,
    [AddedBy]                       [bigint] NOT NULL,
    [AddedByDatetime]               [datetime] NOT NULL,
    [LastUpdatedBy]                 [bigint] NOT NULL,
    [LastUpdatedByDatetime]         [datetime] NOT NULL
)
GO

ALTER TABLE [dbo].[Events]
ADD CONSTRAINT [PK_Events] PRIMARY KEY CLUSTERED (
    [EventScheduleId] ASC
) WITH (
    IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    , PAD_INDEX = OFF
    , STATISTICS_NORECOMPUTE = OFF
) ON [PRIMARY]
GO

INSERT INTO [EventSchedules] (EventId, StartDate, EndDate, EventStatus, AddedBy, AddedByDatetime, LastUpdatedBy, LastUpdatedByDatetime)
VALUES (SELECT EventId, StartDate, EndDate, EventStatus, AddedBy, AddedByDatetime, LastUpdatedBy, IX_Teams_LastUpdated FROM Events)
GO

ALTER TABLE [dbo].[EventSchedules]  WITH CHECK 
ADD CONSTRAINT [FK_EventSchedules_Venue] FOREIGN KEY([VenueId])
REFERENCES [dbo].[Venues] ([VenueId])
GO

ALTER TABLE [dbo].[EventSchedules]  WITH CHECK 
ADD CONSTRAINT [FK_EventSchedules_EventStatus] FOREIGN KEY([EventStatus])
REFERENCES [dbo].[Statuses] ([StatusId])
GO


CREATE NONCLUSTERED INDEX [IX_EventSchedules_Game_StartDate_EventStatus]
ON [dbo].[EventSchedules](
    [GameId] ASC,
    [StartDate] ASC,
    [EventStatus] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_EventSchedules_StartDate_EndDate]
ON [dbo].[EventSchedules](
    [StartDate] ASC,
    [EndDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_EventSchedules_StartDate]
ON [dbo].[EventSchedules](
    [StartDate] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_EventSchedules_EventStatus]
ON [dbo].[EventSchedules](
    [EventStatus] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_EventSchedules_Venue]
ON [dbo].[EventSchedules](
    [VenueId] ASC
)
GO


ALTER TABLE [dbo].[Events] DROP INDEX [FK_Events_Venue]
GO

ALTER TABLE [dbo].[Events] DROP INDEX [FK_Events_Event_Status]
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

ALTER TABLE [dbo].[Events] DROP COLUMN [VenueId]
GO
ALTER TABLE [dbo].[Events] DROP COLUMN [StartDate]
GO
ALTER TABLE [dbo].[Events] DROP COLUMN [EndDate]
GO
ALTER TABLE [dbo].[Events] DROP COLUMN [EventStatus]
GO




