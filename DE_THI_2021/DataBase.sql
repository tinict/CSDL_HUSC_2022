USE [BAITHI_20T1020110_2021]
GO
/****** Object:  Table [dbo].[Employees]    Script Date: 12/19/2022 3:04:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employees](
	[EmployeeId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[Birthday] [date] NOT NULL,
	[Address] [nvarchar](255) NOT NULL,
	[Phone] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED 
(
	[EmployeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TaskAssignments]    Script Date: 12/19/2022 3:04:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaskAssignments](
	[TaskId] [int] NOT NULL,
	[EmployeeId] [int] NOT NULL,
	[AssignedDate] [date] NOT NULL,
	[FinishedDate] [date] NULL,
 CONSTRAINT [PK_TaskAssignments] PRIMARY KEY CLUSTERED 
(
	[TaskId] ASC,
	[EmployeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tasks]    Script Date: 12/19/2022 3:04:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tasks](
	[TaskId] [int] IDENTITY(1,1) NOT NULL,
	[TaskName] [nvarchar](255) NOT NULL,
	[StartDate] [date] NOT NULL,
	[CountOfAssigned] [int] NOT NULL,
	[CountOfFinished] [nchar](10) NOT NULL,
 CONSTRAINT [PK_Task] PRIMARY KEY CLUSTERED 
(
	[TaskId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Employees] ON 

INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Birthday], [Address], [Phone]) VALUES (2, N'Lê Quang', N'Phước', CAST(N'2002-11-20' AS Date), N'Số 50 Âu Lạc', N'0905467899')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Birthday], [Address], [Phone]) VALUES (3, N'Lê Phước Thành', N'Nhân', CAST(N'2002-11-19' AS Date), N'Số 8 Phan Đình Phùng', N'0702889999')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Birthday], [Address], [Phone]) VALUES (5, N'Nguyễn Văn', N'Tín', CAST(N'2002-08-18' AS Date), N'205/4/3 Bà Triệu', N'0702384832')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Birthday], [Address], [Phone]) VALUES (6, N'Silisombath', N'Phetmany', CAST(N'2002-05-08' AS Date), N'Kiến túc xá lào Phạm Văn Đồng', N'0703457888')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Birthday], [Address], [Phone]) VALUES (7, N'Trần Thị Thu', N'Trang', CAST(N'2002-05-22' AS Date), N'Phạm Văn Đồng', N'0127123999')
SET IDENTITY_INSERT [dbo].[Employees] OFF
GO
INSERT [dbo].[TaskAssignments] ([TaskId], [EmployeeId], [AssignedDate], [FinishedDate]) VALUES (1, 2, CAST(N'2020-11-01' AS Date), CAST(N'2022-12-30' AS Date))
INSERT [dbo].[TaskAssignments] ([TaskId], [EmployeeId], [AssignedDate], [FinishedDate]) VALUES (1, 6, CAST(N'2022-12-17' AS Date), CAST(N'2022-12-30' AS Date))
INSERT [dbo].[TaskAssignments] ([TaskId], [EmployeeId], [AssignedDate], [FinishedDate]) VALUES (2, 2, CAST(N'2021-05-06' AS Date), CAST(N'2021-06-30' AS Date))
INSERT [dbo].[TaskAssignments] ([TaskId], [EmployeeId], [AssignedDate], [FinishedDate]) VALUES (2, 3, CAST(N'2021-05-06' AS Date), CAST(N'2021-06-30' AS Date))
INSERT [dbo].[TaskAssignments] ([TaskId], [EmployeeId], [AssignedDate], [FinishedDate]) VALUES (2, 5, CAST(N'2021-05-06' AS Date), CAST(N'2021-06-30' AS Date))
INSERT [dbo].[TaskAssignments] ([TaskId], [EmployeeId], [AssignedDate], [FinishedDate]) VALUES (2, 7, CAST(N'2022-07-22' AS Date), NULL)
INSERT [dbo].[TaskAssignments] ([TaskId], [EmployeeId], [AssignedDate], [FinishedDate]) VALUES (3, 5, CAST(N'2022-11-12' AS Date), NULL)
INSERT [dbo].[TaskAssignments] ([TaskId], [EmployeeId], [AssignedDate], [FinishedDate]) VALUES (4, 2, CAST(N'2022-12-31' AS Date), CAST(N'2023-01-06' AS Date))
INSERT [dbo].[TaskAssignments] ([TaskId], [EmployeeId], [AssignedDate], [FinishedDate]) VALUES (4, 3, CAST(N'2022-11-18' AS Date), NULL)
GO
SET IDENTITY_INSERT [dbo].[Tasks] ON 

INSERT [dbo].[Tasks] ([TaskId], [TaskName], [StartDate], [CountOfAssigned], [CountOfFinished]) VALUES (1, N'Làm bài tập C++', CAST(N'2020-11-01' AS Date), 0, N'0         ')
INSERT [dbo].[Tasks] ([TaskId], [TaskName], [StartDate], [CountOfAssigned], [CountOfFinished]) VALUES (2, N'Đồ án tốt nghiệp 2021', CAST(N'2021-05-06' AS Date), 4, N'0         ')
INSERT [dbo].[Tasks] ([TaskId], [TaskName], [StartDate], [CountOfAssigned], [CountOfFinished]) VALUES (3, N'Xây dựng web app', CAST(N'2022-01-05' AS Date), 0, N'0         ')
INSERT [dbo].[Tasks] ([TaskId], [TaskName], [StartDate], [CountOfAssigned], [CountOfFinished]) VALUES (4, N'Xây dựng API', CAST(N'2022-11-18' AS Date), 2, N'1         ')
INSERT [dbo].[Tasks] ([TaskId], [TaskName], [StartDate], [CountOfAssigned], [CountOfFinished]) VALUES (5, N'Phân tích thiết kế Blog', CAST(N'2019-12-12' AS Date), 0, N'0         ')
SET IDENTITY_INSERT [dbo].[Tasks] OFF
GO
ALTER TABLE [dbo].[Tasks] ADD  CONSTRAINT [DF_Task_CountOfAssigned]  DEFAULT ((0)) FOR [CountOfAssigned]
GO
ALTER TABLE [dbo].[Tasks] ADD  CONSTRAINT [DF_Task_CountOfFinished]  DEFAULT ((0)) FOR [CountOfFinished]
GO
ALTER TABLE [dbo].[TaskAssignments]  WITH CHECK ADD  CONSTRAINT [FK_TaskAssignments_Employees] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employees] ([EmployeeId])
GO
ALTER TABLE [dbo].[TaskAssignments] CHECK CONSTRAINT [FK_TaskAssignments_Employees]
GO
ALTER TABLE [dbo].[TaskAssignments]  WITH CHECK ADD  CONSTRAINT [FK_TaskAssignments_Tasks] FOREIGN KEY([TaskId])
REFERENCES [dbo].[Tasks] ([TaskId])
GO
ALTER TABLE [dbo].[TaskAssignments] CHECK CONSTRAINT [FK_TaskAssignments_Tasks]
GO
