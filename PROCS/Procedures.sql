-- [General Procs] ********************************************************************************************************************** 
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

-- [Status Procs] ********************************************************************************************************************** 
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

-- [Events Procs] ********************************************************************************************************************** 
CREATE PROCEDURE [dbo].[uspAutoActivateEvents]
    @UserId bigint,
    @Status bigint = 1
AS
BEGIN TRY
    BEGIN TRAN
        UPDATE [dbo].[Events]
        SET EventStatus = @Status
            ,LastUpdatedBy = @UserId
            ,LastUpdatedByDatetime = GETDATE()
        WHERE DATEDIFF(day, StartDate, GETDATE()) > 1 AND
            TeamCount <= [dbo].[udfTotalTeamsApprovedForEvent](EventId);
    COMMIT
END TRY
BEGIN CATCH
    ROLLBACK
    EXECUTE [dbo].[uspGetErrorInfo];
END CATCH
GO

CREATE PROCEDURE [dbo].[uspChangeEventStatus]
    @EventId bigint,
    @UserId bigint,
    @Status bigint
AS
BEGIN TRY
    BEGIN TRAN
        UPDATE [dbo].[Events]
        SET EventStatus = @Status
            ,LastUpdatedBy = @UserId
            ,LastUpdatedByDatetime = GETDATE()
        WHERE EventId = @EventId;
    COMMIT
END TRY
BEGIN CATCH
    ROLLBACK
    EXECUTE [dbo].[uspGetErrorInfo];
END CATCH
GO

-- [Access Procs] ********************************************************************************************************************** 
CREATE PROCEDURE [dbo].[uspInsertNewAccess]
    @Password binary(1000),
    @SecurityKey nvarchar(120),
    @UserId bigint,
    @Status bigint
AS
BEGIN TRY
    BEGIN TRAN
        UPDATE [dbo].[Access]
        SET isActive = 0
            ,LastUpdatedBy = @UserId
            ,LastUpdatedByDatetime = GETDATE()
        WHERE UserId = @UserId;

        INSERT INTO [dbo].[Access] (UsrId
            ,Password 
            ,SecurityKey
            ,isActive
            ,AddedBy
            ,AddedByDatetime
            ,LastUpdatedBy
            ,LastUpdatedByDatetime
        )
        VALUES (@UserId
            ,@Password
            ,@SecurityKey
            ,1
            ,@UserId
            ,GETDATE()
            ,@UserId
            ,GETDATE()
        )
    COMMIT
END TRY
BEGIN CATCH
    ROLLBACK
    EXECUTE [dbo].[uspGetErrorInfo];
END CATCH
GO
