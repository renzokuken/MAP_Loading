USE [Sandbox]
GO

/****** Object:  Table [dbo].[Student_by_School_QA_Fall]    Script Date: 09/23/2013 09:34:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Student_by_School_QA_Fall](
	[TermName] [nvarchar](255) NULL,
	[PKstudent] [float] NULL,
	[School_ID] [int] NULL,
	[SchoolName] [nvarchar](255) NULL,
	[DistrictName] [nvarchar](255) NULL,
	[StudentLastName] [nvarchar](255) NULL,
	[StudentFirstName] [nvarchar](255) NULL,
	[StudentMI] [nvarchar](255) NULL,
	[StudentID] [nvarchar](255) NULL,
	[StudentDateOfBirth] [datetime] NULL,
	[StudentEthnicGroup] [nvarchar](255) NULL,
	[StudentGender] [nvarchar](255) NULL,
	[Grade] [float] NULL
) ON [PRIMARY]

GO


