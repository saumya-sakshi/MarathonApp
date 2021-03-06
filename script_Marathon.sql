USE [master]
GO
/****** Object:  Database [Marathon]    Script Date: 06-11-2020 21:31:46 ******/
CREATE DATABASE [Marathon]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Marathon', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Marathon.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Marathon_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Marathon_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Marathon] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Marathon].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Marathon] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Marathon] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Marathon] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Marathon] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Marathon] SET ARITHABORT OFF 
GO
ALTER DATABASE [Marathon] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Marathon] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Marathon] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Marathon] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Marathon] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Marathon] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Marathon] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Marathon] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Marathon] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Marathon] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Marathon] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Marathon] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Marathon] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Marathon] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Marathon] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Marathon] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Marathon] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Marathon] SET RECOVERY FULL 
GO
ALTER DATABASE [Marathon] SET  MULTI_USER 
GO
ALTER DATABASE [Marathon] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Marathon] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Marathon] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Marathon] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Marathon] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Marathon', N'ON'
GO
ALTER DATABASE [Marathon] SET QUERY_STORE = OFF
GO
USE [Marathon]
GO
/****** Object:  Table [dbo].[Runner]    Script Date: 06-11-2020 21:31:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Runner](
	[RunnerId] [int] IDENTITY(1,1) NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
	[Gender] [nvarchar](10) NOT NULL,
	[DateOfBirth] [datetime] NULL,
	[CountryCode] [nchar](3) NOT NULL,
 CONSTRAINT [pk_Runner] PRIMARY KEY CLUSTERED 
(
	[RunnerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Registration]    Script Date: 06-11-2020 21:31:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Registration](
	[RegistrationId] [int] IDENTITY(1,1) NOT NULL,
	[RunnerId] [int] NOT NULL,
	[RegistrationDateTime] [datetime] NOT NULL,
	[RaceKitOptionId] [nchar](1) NOT NULL,
	[RegistrationStatusId] [tinyint] NOT NULL,
	[Cost] [decimal](10, 2) NOT NULL,
	[CharityId] [int] NOT NULL,
	[SponsorshipTarget] [decimal](10, 2) NOT NULL,
 CONSTRAINT [pk_Registration] PRIMARY KEY CLUSTERED 
(
	[RegistrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RegistrationEvent]    Script Date: 06-11-2020 21:31:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RegistrationEvent](
	[RegistrationEventId] [int] IDENTITY(1,1) NOT NULL,
	[RegistrationId] [int] NOT NULL,
	[EventId] [nchar](6) NOT NULL,
	[BibNumber] [smallint] NULL,
	[RaceTime] [int] NULL,
 CONSTRAINT [pk_RegistrationEvent] PRIMARY KEY CLUSTERED 
(
	[RegistrationEventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[overallrank]    Script Date: 06-11-2020 21:31:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[overallrank] as

select DATEDIFF(YYYY, ru.DateOfBirth,getdate()) as dob,re.RegistrationId, re.eventid,re.RaceTime from RegistrationEvent re inner join Registration r on r.RegistrationId=re.RegistrationId 
inner join Runner Ru on ru.RunnerId=r.RunnerId  where racetime is not null and RaceTime<>0 group by eventid,re.RaceTime,re.RegistrationId , DATEDIFF(YYYY, ru.DateOfBirth,getdate())
GO
/****** Object:  Table [dbo].[Charity]    Script Date: 06-11-2020 21:31:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Charity](
	[CharityId] [int] IDENTITY(1,1) NOT NULL,
	[CharityName] [nvarchar](100) NOT NULL,
	[CharityDescription] [nvarchar](2000) NULL,
	[CharityLogo] [nvarchar](50) NULL,
 CONSTRAINT [pk_Charity] PRIMARY KEY CLUSTERED 
(
	[CharityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Country]    Script Date: 06-11-2020 21:31:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[CountryCode] [nchar](3) NOT NULL,
	[CountryName] [nvarchar](100) NOT NULL,
	[CountryFlag] [nvarchar](100) NOT NULL,
 CONSTRAINT [pk_Country] PRIMARY KEY CLUSTERED 
(
	[CountryCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Event]    Script Date: 06-11-2020 21:31:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Event](
	[EventId] [nchar](6) NOT NULL,
	[EventName] [nvarchar](50) NOT NULL,
	[EventTypeId] [nchar](2) NOT NULL,
	[MarathonId] [tinyint] NOT NULL,
	[StartDateTime] [datetime] NULL,
	[Cost] [decimal](10, 2) NULL,
	[MaxParticipants] [smallint] NULL,
 CONSTRAINT [pk_Event] PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventType]    Script Date: 06-11-2020 21:31:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventType](
	[EventTypeId] [nchar](2) NOT NULL,
	[EventTypeName] [nvarchar](50) NOT NULL,
 CONSTRAINT [pk_EventType] PRIMARY KEY CLUSTERED 
(
	[EventTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Gender]    Script Date: 06-11-2020 21:31:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Gender](
	[Gender] [nvarchar](10) NOT NULL,
 CONSTRAINT [pk_Gender] PRIMARY KEY CLUSTERED 
(
	[Gender] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Marathon]    Script Date: 06-11-2020 21:31:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Marathon](
	[MarathonId] [tinyint] IDENTITY(1,1) NOT NULL,
	[MarathonName] [nvarchar](80) NOT NULL,
	[CityName] [nvarchar](80) NULL,
	[CountryCode] [nchar](3) NOT NULL,
	[YearHeld] [smallint] NULL,
 CONSTRAINT [pk_Marathon] PRIMARY KEY CLUSTERED 
(
	[MarathonId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Position]    Script Date: 06-11-2020 21:31:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Position](
	[PositionId] [smallint] IDENTITY(1,1) NOT NULL,
	[PositionName] [varchar](50) NOT NULL,
	[PositionDescription] [varchar](1000) NULL,
	[Payrate] [decimal](10, 2) NOT NULL,
 CONSTRAINT [PK_Position] PRIMARY KEY CLUSTERED 
(
	[PositionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RaceKitOption]    Script Date: 06-11-2020 21:31:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RaceKitOption](
	[RaceKitOptionId] [nchar](1) NOT NULL,
	[RaceKitOption] [nvarchar](80) NOT NULL,
	[Cost] [decimal](10, 2) NOT NULL,
 CONSTRAINT [pk_RaceKitOption] PRIMARY KEY CLUSTERED 
(
	[RaceKitOptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RegistrationStatus]    Script Date: 06-11-2020 21:31:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RegistrationStatus](
	[RegistrationStatusId] [tinyint] IDENTITY(1,1) NOT NULL,
	[RegistrationStatus] [nvarchar](80) NOT NULL,
 CONSTRAINT [pk_RegistrationStatus] PRIMARY KEY CLUSTERED 
(
	[RegistrationStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Role]    Script Date: 06-11-2020 21:31:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role](
	[RoleId] [nchar](1) NOT NULL,
	[RoleName] [nvarchar](50) NOT NULL,
 CONSTRAINT [pk_Role] PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sponsorship]    Script Date: 06-11-2020 21:31:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sponsorship](
	[SponsorshipId] [int] IDENTITY(1,1) NOT NULL,
	[SponsorName] [nvarchar](150) NOT NULL,
	[RegistrationId] [int] NOT NULL,
	[Amount] [decimal](10, 2) NOT NULL,
 CONSTRAINT [pk_Sponsorship] PRIMARY KEY CLUSTERED 
(
	[SponsorshipId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Staff]    Script Date: 06-11-2020 21:31:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Staff](
	[StaffId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](80) NOT NULL,
	[LastName] [varchar](80) NOT NULL,
	[DateOfBirth] [datetime] NOT NULL,
	[Gender] [varchar](10) NOT NULL,
	[PostionId] [smallint] NOT NULL,
	[Comments] [varchar](2000) NULL,
 CONSTRAINT [PK_Staff] PRIMARY KEY CLUSTERED 
(
	[StaffId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Timesheet]    Script Date: 06-11-2020 21:31:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Timesheet](
	[TimesheetId] [int] NOT NULL,
	[StaffId] [int] IDENTITY(1,1) NOT NULL,
	[StartDateTime] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[PayAmount] [decimal](10, 2) NULL,
 CONSTRAINT [PK_Timesheet] PRIMARY KEY CLUSTERED 
(
	[TimesheetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[user]    Script Date: 06-11-2020 21:31:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user](
	[Email] [nvarchar](100) NOT NULL,
	[Password] [nvarchar](100) NOT NULL,
	[FirstName] [nvarchar](80) NULL,
	[LastName] [nvarchar](80) NULL,
	[RoleId] [nchar](1) NOT NULL,
 CONSTRAINT [pk_User] PRIMARY KEY CLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Volunteer]    Script Date: 06-11-2020 21:31:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Volunteer](
	[VolunteerId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](80) NULL,
	[LastName] [nvarchar](80) NULL,
	[CountryCode] [nchar](3) NOT NULL,
	[Gender] [nvarchar](10) NOT NULL,
 CONSTRAINT [pk_Volunteer] PRIMARY KEY CLUSTERED 
(
	[VolunteerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Event]  WITH CHECK ADD FOREIGN KEY([EventTypeId])
REFERENCES [dbo].[EventType] ([EventTypeId])
GO
ALTER TABLE [dbo].[Event]  WITH CHECK ADD FOREIGN KEY([MarathonId])
REFERENCES [dbo].[Marathon] ([MarathonId])
GO
ALTER TABLE [dbo].[Marathon]  WITH CHECK ADD FOREIGN KEY([CountryCode])
REFERENCES [dbo].[Country] ([CountryCode])
GO
ALTER TABLE [dbo].[Registration]  WITH CHECK ADD FOREIGN KEY([CharityId])
REFERENCES [dbo].[Charity] ([CharityId])
GO
ALTER TABLE [dbo].[Registration]  WITH CHECK ADD FOREIGN KEY([RaceKitOptionId])
REFERENCES [dbo].[RaceKitOption] ([RaceKitOptionId])
GO
ALTER TABLE [dbo].[Registration]  WITH CHECK ADD FOREIGN KEY([RegistrationStatusId])
REFERENCES [dbo].[RegistrationStatus] ([RegistrationStatusId])
GO
ALTER TABLE [dbo].[Registration]  WITH CHECK ADD FOREIGN KEY([RunnerId])
REFERENCES [dbo].[Runner] ([RunnerId])
GO
ALTER TABLE [dbo].[RegistrationEvent]  WITH CHECK ADD FOREIGN KEY([EventId])
REFERENCES [dbo].[Event] ([EventId])
GO
ALTER TABLE [dbo].[RegistrationEvent]  WITH CHECK ADD FOREIGN KEY([RegistrationId])
REFERENCES [dbo].[Registration] ([RegistrationId])
GO
ALTER TABLE [dbo].[Runner]  WITH CHECK ADD FOREIGN KEY([CountryCode])
REFERENCES [dbo].[Country] ([CountryCode])
GO
ALTER TABLE [dbo].[Runner]  WITH CHECK ADD FOREIGN KEY([Email])
REFERENCES [dbo].[user] ([Email])
GO
ALTER TABLE [dbo].[Runner]  WITH CHECK ADD FOREIGN KEY([Gender])
REFERENCES [dbo].[Gender] ([Gender])
GO
ALTER TABLE [dbo].[Sponsorship]  WITH CHECK ADD FOREIGN KEY([RegistrationId])
REFERENCES [dbo].[Registration] ([RegistrationId])
GO
ALTER TABLE [dbo].[Staff]  WITH CHECK ADD  CONSTRAINT [FK_Staff_Position] FOREIGN KEY([PostionId])
REFERENCES [dbo].[Position] ([PositionId])
GO
ALTER TABLE [dbo].[Staff] CHECK CONSTRAINT [FK_Staff_Position]
GO
ALTER TABLE [dbo].[Timesheet]  WITH CHECK ADD  CONSTRAINT [FK_Timesheet_Staff] FOREIGN KEY([StaffId])
REFERENCES [dbo].[Staff] ([StaffId])
GO
ALTER TABLE [dbo].[Timesheet] CHECK CONSTRAINT [FK_Timesheet_Staff]
GO
ALTER TABLE [dbo].[user]  WITH CHECK ADD FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([RoleId])
GO
ALTER TABLE [dbo].[Volunteer]  WITH CHECK ADD FOREIGN KEY([CountryCode])
REFERENCES [dbo].[Country] ([CountryCode])
GO
ALTER TABLE [dbo].[Volunteer]  WITH CHECK ADD FOREIGN KEY([Gender])
REFERENCES [dbo].[Gender] ([Gender])
GO
USE [master]
GO
ALTER DATABASE [Marathon] SET  READ_WRITE 
GO
