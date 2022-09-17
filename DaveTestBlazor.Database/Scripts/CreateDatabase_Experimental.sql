/************************************************************************
*
*
*			BEGIN database script from SSMS "script as" command
*
*
************************************************************************/

USE [master]
GO

/****** Object:  Database [DaveTest_Complex]    Script Date: 9/17/2022 12:58:43 PM ******/
CREATE DATABASE [DaveTest_Complex]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DaveTest', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\DaveTest.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DaveTest_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\DaveTest_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DaveTest_Complex].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [DaveTest_Complex] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [DaveTest_Complex] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [DaveTest_Complex] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [DaveTest_Complex] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [DaveTest_Complex] SET ARITHABORT OFF 
GO

ALTER DATABASE [DaveTest_Complex] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [DaveTest_Complex] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [DaveTest_Complex] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [DaveTest_Complex] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [DaveTest_Complex] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [DaveTest_Complex] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [DaveTest_Complex] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [DaveTest_Complex] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [DaveTest_Complex] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [DaveTest_Complex] SET  DISABLE_BROKER 
GO

ALTER DATABASE [DaveTest_Complex] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [DaveTest_Complex] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [DaveTest_Complex] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [DaveTest_Complex] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [DaveTest_Complex] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [DaveTest_Complex] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [DaveTest_Complex] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [DaveTest_Complex] SET RECOVERY FULL 
GO

ALTER DATABASE [DaveTest_Complex] SET  MULTI_USER 
GO

ALTER DATABASE [DaveTest_Complex] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [DaveTest_Complex] SET DB_CHAINING OFF 
GO

ALTER DATABASE [DaveTest_Complex] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [DaveTest_Complex] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO

ALTER DATABASE [DaveTest_Complex] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [DaveTest_Complex] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO

ALTER DATABASE [DaveTest_Complex] SET QUERY_STORE = OFF
GO

ALTER DATABASE [DaveTest_Complex] SET  READ_WRITE 
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


-- create the user in the application db and then tie it to the account created on the server
USE [DaveTest_Complex]
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
*			BEGIN table creation for [DaveTest_Complex] database
*
*
************************************************************************/
USE [DaveTest_Complex]
GO

-- User
CREATE TABLE [dbo].[User](
    UserID INT IDENTITY(1,1) NOT NULL
    ,FirstName VARCHAR(50) NOT NULL
    ,LastName VARCHAR(50) NOT NULL
    ,Age INT NOT NULL
    ,CONSTRAINT [PK_UserID] PRIMARY KEY CLUSTERED
    ([UserID] ASC) 
    ,[ValidFrom] datetime2 GENERATED ALWAYS AS ROW START
    ,[ValidTo] datetime2 GENERATED ALWAYS AS ROW END
    ,PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [audit].[User]));
GO



-- Address
CREATE TABLE [dbo].[Address](
    AddressID INT IDENTITY(1,1) NOT NULL
    ,FullAddress VARCHAR(300) NOT NULL
    ,CONSTRAINT [PK_AddressID] PRIMARY KEY CLUSTERED
    ([AddressID] ASC) 
    ,[ValidFrom] datetime2 GENERATED ALWAYS AS ROW START
    ,[ValidTo] datetime2 GENERATED ALWAYS AS ROW END
    ,PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [audit].[Address]));
GO



-- UserAddress
CREATE TABLE [dbo].[UserAddress](
    UserAddressID INT IDENTITY(1,1) NOT NULL
    ,UserID INT NOT NULL
    ,AddressID INT NOT NULL
    ,CONSTRAINT [PK_UserAddressID] PRIMARY KEY CLUSTERED
    ([AddressID] ASC) 
    ,[ValidFrom] datetime2 GENERATED ALWAYS AS ROW START
    ,[ValidTo] datetime2 GENERATED ALWAYS AS ROW END
    ,PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [audit].[UserAddress]));
GO

-- FKs for UserAddress table
ALTER TABLE [dbo].[UserAddress]  WITH CHECK ADD  CONSTRAINT [FK_User_UserAddress_UserID] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[UserAddress] CHECK CONSTRAINT [FK_User_UserAddress_UserID]
GO

ALTER TABLE [dbo].[UserAddress]  WITH CHECK ADD  CONSTRAINT [FK_Address_UserAddress_AddressID] FOREIGN KEY([AddressID])
REFERENCES [dbo].[Address] ([AddressID])
GO
ALTER TABLE [dbo].[UserAddress] CHECK CONSTRAINT [FK_Address_UserAddress_AddressID]
GO






/************************************************************************
*		#########################################################
*			
*			END table creation for [DaveTest_Complex] database
*			
*		#########################################################
************************************************************************/




/************************************************************************
*
*
*			BEGIN stored procedures
*
*
************************************************************************/



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
*			BEGIN
*
*
************************************************************************/



/************************************************************************
*		#########################################################
*			
*			END 
*			
*		#########################################################
************************************************************************/





/************************************************************************
*
*
*			BEGIN
*
*
************************************************************************/



/************************************************************************
*		#########################################################
*			
*			END 
*			
*		#########################################################
************************************************************************/





/************************************************************************
*
*
*			BEGIN
*
*
************************************************************************/



/************************************************************************
*		#########################################################
*			
*			END 
*			
*		#########################################################
************************************************************************/