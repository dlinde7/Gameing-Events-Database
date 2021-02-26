CREATE PROCEDURE [dbo].[uspInsertNewUser]
	@UserId bigint,
	@FirstName nvarchar(120),
    @LastName nvarchar(120),
    @ProfileImageUrl nvarchar(600),
    @DateOfBirth date,
	@EmailAddress nvarchar(180), 
	@ContactNumber nvarchar(40)
AS
BEGIN TRANSACTION
BEGIN TRY
    

        INSERT INTO [dbo].[Users] (
		FirstName, 
		LastName, 
		ProfileImageUrl, 
		DateOfBirth, 
		EmailAddress, 
		ContactNumber, 
		IsEmailVerified, 
		IsContactNumberVerified, 
		AddedBy, 
		AddedByDatetime, 
		LastUpdatedBy, 
		LastUpdatedByDatetime)
        VALUES (
             @FirstName
            ,@LastName
            ,@ProfileImageUrl
            ,@DateOfBirth
			,@EmailAddress
			,@ContactNumber
			,0
			,0
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