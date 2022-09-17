/************************************************************************
*
*
*			BEGIN database script from SSMS "script as" command
*
*
************************************************************************/

USE [master]
GO

/****** Object:  Database [DaveTest]    Script Date: 9/17/2022 12:58:43 PM ******/
CREATE DATABASE [DaveTest]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DaveTest', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\DaveTest.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DaveTest_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\DaveTest_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DaveTest].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [DaveTest] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [DaveTest] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [DaveTest] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [DaveTest] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [DaveTest] SET ARITHABORT OFF 
GO

ALTER DATABASE [DaveTest] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [DaveTest] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [DaveTest] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [DaveTest] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [DaveTest] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [DaveTest] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [DaveTest] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [DaveTest] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [DaveTest] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [DaveTest] SET  DISABLE_BROKER 
GO

ALTER DATABASE [DaveTest] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [DaveTest] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [DaveTest] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [DaveTest] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [DaveTest] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [DaveTest] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [DaveTest] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [DaveTest] SET RECOVERY FULL 
GO

ALTER DATABASE [DaveTest] SET  MULTI_USER 
GO

ALTER DATABASE [DaveTest] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [DaveTest] SET DB_CHAINING OFF 
GO

ALTER DATABASE [DaveTest] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [DaveTest] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO

ALTER DATABASE [DaveTest] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [DaveTest] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO

ALTER DATABASE [DaveTest] SET QUERY_STORE = OFF
GO

ALTER DATABASE [DaveTest] SET  READ_WRITE 
GO


/************************************************************************
*		#########################################################
*
*			END database script from SSMS "script as" command
*			
*		#########################################################
************************************************************************/



/************************************************************************
*
*
*			BEGIN user creation for use within the project
*
*
************************************************************************/

-- create the user in master db
USE [master]
GO
CREATE LOGIN [DaveTestAccount] WITH PASSWORD=N'myTestAccount123'
     , DEFAULT_DATABASE=[DaveTest]
GO

-- create the user in the application db and then tie it to the account created on the server
USE [DaveTest]
GO
CREATE USER [DaveTestAccount] FOR LOGIN [DaveTestAccount] WITH DEFAULT_SCHEMA=[dbo]
GO

/************************************************************************
*		#########################################################
*			
*			END user creation for use within the project
*			
*		#########################################################
************************************************************************/


/************************************************************************
*
*
*			BEGIN table creation for [DaveTest] database
*
*
************************************************************************/
USE [DaveTest]
GO

-- user table
CREATE TABLE [dbo].[User](
    [UserID] INT IDENTITY(1,1) NOT NULL
    ,[FirstName] VARCHAR(50) NOT NULL
    ,[LastName] VARCHAR(50) NOT NULL
    ,[Age] INT NOT NULL
	,[Address] VARCHAR(500) NOT NULL
	,[PhoneNumber] VARCHAR(20) NOT NULL
    ,CONSTRAINT [PK_UserID] PRIMARY KEY CLUSTERED
    ([UserID] ASC) 
    ,[ValidFrom] datetime2 GENERATED ALWAYS AS ROW START
    ,[ValidTo] datetime2 GENERATED ALWAYS AS ROW END
    ,PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
	)
    WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [dbo].[UserAudit]));
GO



/************************************************************************
*		#########################################################
*			
*			END table creation for [DaveTest] database
*			
*		#########################################################
************************************************************************/




/************************************************************************
*
*
*			BEGIN stored procedures -- template gotten from : https://stackoverflow.com/questions/2073737/nested-stored-procedures-containing-try-catch-rollback-pattern/2074139#2074139
*
*
************************************************************************/
USE [DaveTest]
GO
/*
===========================================================================================================================================
=    Author:
=        David Lancellotti
=
=    Create date: 
=        09/17/2022 14:04 PM
=
=    Description:
=        Update or insert a user record with the relevant information
=
=    UPDATES:
=                                DateTime
=    Author                        mm/dd/yyyy HH:mm    Description
=    =====================        =============        =======================================================================================
=
=
===========================================================================================================================================
*/
CREATE PROCEDURE [dbo].[usp_UserUpsert]
    @userID AS INTEGER
    ,@userFirstName AS VARCHAR(50)
    ,@userLastName AS VARCHAR(50)
    ,@userAddress AS VARCHAR(500)
    ,@userAge AS INTEGER
    ,@userPhoneNumber AS VARCHAR(20)
AS
SET XACT_ABORT, NOCOUNT ON
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

        -- trim our varchar inputs to ensure we have no whitespace
        SET @userFirstName = LTRIM(RTRIM(@userFirstName));
        SET @userLastName = LTRIM(RTRIM(@userLastName));
        SET @userAddress = LTRIM(RTRIM(@userAddress));
        SET @userPhoneNumber = LTRIM(RTRIM(@userPhoneNumber));

        -- if we can find a record with the userID pushed in, let's update the information for it
        IF EXISTS(SELECT 1 FROM [dbo].[User] WHERE [UserID] = @userID)
        BEGIN;
            UPDATE [dbo].[User]
            SET
                [FirstName] = @userFirstName
                ,[LastName] = @userLastName
                ,[Address] = @userAddress
                ,[Age] = @userAge
                ,[PhoneNumber] = @userPhoneNumber
            WHERE
                [UserID] = @userID
        END;
        -- else, we check to see if the userID sent in is 0 - indicating a new user
        ELSE IF (@userID = 0)
        BEGIN;
            INSERT INTO [dbo].[User](
                [FirstName]
                ,[LastName]
                ,[Address]
                ,[Age]
                ,[PhoneNumber]
            )
            VALUES(
                @userFirstName
                ,@userLastName
                ,@userAddress
                ,@userAge
                ,@userPhoneNumber
            );
        END;
        -- if the ID doesn't exists and is not 0, the user doesn't exist and we can't update it.
        ELSE
        BEGIN;
            THROW 51001, 'The UserID does not exist', 1;
        END;

    IF @starttrancount = 0 
        COMMIT TRANSACTION
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 AND @starttrancount = 0 
        ROLLBACK TRANSACTION;
    THROW;
END CATCH
GO


/*
===========================================================================================================================================
=    Author:
=        David Lancellotti
=
=    Create date: 
=        09/17/2022 14:06 PM
=
=    Description:
=        Delete a user record given the UserID
=
=    UPDATES:
=                                DateTime
=    Author                        mm/dd/yyyy HH:mm    Description
=    =====================        =============        =======================================================================================
=
=
===========================================================================================================================================
*/
CREATE PROCEDURE [dbo].[usp_UserDelete]
    @userID AS INTEGER
AS
SET XACT_ABORT, NOCOUNT ON
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

        -- if we can find a record for the userID pushed in, delete it.
        -- if we don't find it - no matter, the user doesn't exist anyway and there's nothing to do
        IF EXISTS(SELECT 1 FROM [dbo].[User] WHERE [UserID] = @userID)
        BEGIN;
            DELETE FROM [dbo].[User]
            WHERE
                [UserID] = @userID
        END;

    IF @starttrancount = 0 
        COMMIT TRANSACTION
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 AND @starttrancount = 0 
        ROLLBACK TRANSACTION;
    THROW;
END CATCH
GO


/************************************************************************
*		#########################################################
*			
*			END stored procedures
*			
*		#########################################################
************************************************************************/




/************************************************************************
*
*
*			BEGIN Views
*
*
************************************************************************/
USE [DaveTest]
GO

CREATE VIEW [dbo].[vUser]
AS
SELECT
    [UserID]
    ,[FirstName]
    ,[LastName]
    ,[Address]
    ,[Age]
    ,[PhoneNumber]
FROM
    [dbo].[User]
    


/************************************************************************
*		#########################################################
*			
*			END Views
*			
*		#########################################################
************************************************************************/


/************************************************************************
*
*
*			BEGIN Sample Data Entry
*
*
************************************************************************/
exec [dbo].usp_UserUpsert 0, N'David', N'Lancellotti', N'2 Emerald Lane, Somewheresville, NJ 01010', N'87', N'1-800-123-1234'
exec [dbo].usp_UserUpsert 0, N'Tod', N'Wilkinson', N'1 Happy Street, Middlington, TN 43435', N'45', N'1-201-565-6574'
exec [dbo].usp_UserUpsert 0, N'Michelle', N'Aaronson', N'2 Emerald Lane, Elsingwhere, CA 43245', N'33', N'1-545-133-4178'
exec [dbo].usp_UserUpsert 0, N'Hogarth', N'Hughes', N'27 Iron Giant Way, Woodsington, NY 94923', N'13', N'1-800-111-2222'
/************************************************************************
*		#########################################################
*			
*			END Sample Data Entry
*			
*		#########################################################
************************************************************************/