USE [Sandbox]
GO

/****** Object:  Table [dbo].[Assessment_Results_QA_Fall]    Script Date: 09/23/2013 09:35:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Assessment_Results_QA_Fall](
	[TermName] [nvarchar](255) NULL,
	[StudentID] [nvarchar](255) NULL,
	[PKstudent] [float] NULL,
	[SchoolName] [nvarchar](255) NULL,
	[MeasurementScale] [nvarchar](255) NULL,
	[Discipline] [nvarchar](255) NULL,
	[GrowthMeasureYN] [bit] NOT NULL,
	[TestType] [nvarchar](255) NULL,
	[TestName] [nvarchar](255) NULL,
	[TestStartDate] [datetime] NULL,
	[TestDurationInMinutes] [float] NULL,
	[TestRITScore] [float] NULL,
	[TestStandardError] [float] NULL,
	[TestPercentile] [float] NULL,
	[TypicalFallToFallGrowth] [float] NULL,
	[TypicalSpringtoSpringGrowth] [nvarchar](255) NULL,
	[TypicalFallToSpringGrowth] [float] NULL,
	[RITtoReadingScore] [nvarchar](255) NULL,
	[RITtoReadingMin] [nvarchar](255) NULL,
	[RITtoReadingMax] [nvarchar](255) NULL,
	[Goal1Name] [nvarchar](255) NULL,
	[Goal1RitScore] [float] NULL,
	[Goal1StdErr] [float] NULL,
	[Goal1Range] [nvarchar](255) NULL,
	[Goal1Adjective] [nvarchar](255) NULL,
	[Goal2Name] [nvarchar](255) NULL,
	[Goal2RitScore] [float] NULL,
	[Goal2StdErr] [float] NULL,
	[Goal2Range] [nvarchar](255) NULL,
	[Goal2Adjective] [nvarchar](255) NULL,
	[Goal3Name] [nvarchar](255) NULL,
	[Goal3RitScore] [float] NULL,
	[Goal3StdErr] [float] NULL,
	[Goal3Range] [nvarchar](255) NULL,
	[Goal3Adjective] [nvarchar](255) NULL,
	[Goal4Name] [nvarchar](255) NULL,
	[Goal4RitScore] [float] NULL,
	[Goal4StdErr] [float] NULL,
	[Goal4Range] [nvarchar](255) NULL,
	[Goal4Adjective] [nvarchar](255) NULL,
	[Goal5Name] [nvarchar](255) NULL,
	[Goal5RitScore] [float] NULL,
	[Goal5StdErr] [float] NULL,
	[Goal5Range] [nvarchar](255) NULL,
	[Goal5Adjective] [nvarchar](255) NULL,
	[Goal6Name] [nvarchar](255) NULL,
	[Goal6RitScore] [nvarchar](255) NULL,
	[Goal6StdErr] [nvarchar](255) NULL,
	[Goal6Range] [nvarchar](255) NULL,
	[Goal6Adjective] [nvarchar](255) NULL,
	[Goal7Name] [nvarchar](255) NULL,
	[Goal7RitScore] [nvarchar](255) NULL,
	[Goal7StdErr] [nvarchar](255) NULL,
	[Goal7Range] [nvarchar](255) NULL,
	[Goal7Adjective] [nvarchar](255) NULL,
	[Goal8Name] [nvarchar](255) NULL,
	[Goal8RitScore] [nvarchar](255) NULL,
	[Goal8StdErr] [nvarchar](255) NULL,
	[Goal8Range] [nvarchar](255) NULL,
	[Goal8Adjective] [nvarchar](255) NULL,
	[TestStartTime] [datetime] NULL,
	[PercentCorrect] [float] NULL,
	[ProjectedProficiency] [nvarchar](255) NULL
) ON [PRIMARY]

GO


