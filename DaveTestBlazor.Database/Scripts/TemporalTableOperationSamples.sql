ALTER TABLE [dbo].[User] SET ( SYSTEM_VERSIONING = OFF)
DROP TABLE [dbo].[UserAudit]
drop table dbo.[user]



SELECT *
FROM [dbo].[User]
FOR SYSTEM_TIME AS OF '2022-09-18 20:50:08.5461611';

select * from [user]