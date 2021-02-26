CREATE PROCEDURE [dbo].[addProvince] 
@provinceName nvarchar(120),
@ModifiersUserID bigint
AS
	INSERT into dbo.Provinces(name, LastUpdatedBy, LastUpdatedByDatetime) values (@provinceName,@ModifiersUserID,GETDATE());