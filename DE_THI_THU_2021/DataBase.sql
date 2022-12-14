USE [BAITHI_20T1020110]
GO
/****** Object:  Table [dbo].[Answer]    Script Date: 12/19/2022 2:11:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Answer](
	[AnswerId] [int] IDENTITY(1,1) NOT NULL,
	[QuestionId] [int] NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[AnsweredTime] [datetime] NOT NULL,
	[AswerContent] [nvarchar](500) NULL,
 CONSTRAINT [PK_Answer] PRIMARY KEY CLUSTERED 
(
	[AnswerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Question]    Script Date: 12/19/2022 2:11:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Question](
	[QuestionId] [int] IDENTITY(1,1) NOT NULL,
	[QuestionTitle] [nvarchar](255) NOT NULL,
	[QuestionContent] [nvarchar](2000) NOT NULL,
	[AskedTime] [datetime] NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[NumOfAnswers] [int] NOT NULL,
 CONSTRAINT [PK_Question] PRIMARY KEY CLUSTERED 
(
	[QuestionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserAccount]    Script Date: 12/19/2022 2:11:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserAccount](
	[UserName] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[FullName] [nvarchar](100) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[NumOfQuestions] [int] NOT NULL,
	[NumOfAnswers] [int] NOT NULL,
 CONSTRAINT [PK_UserAccount] PRIMARY KEY CLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Answer] ON 

INSERT [dbo].[Answer] ([AnswerId], [QuestionId], [UserName], [AnsweredTime], [AswerContent]) VALUES (3, 2, N'thanhnhan', CAST(N'2022-12-18T23:05:12.150' AS DateTime), N'mạng là mạng đó bạn')
INSERT [dbo].[Answer] ([AnswerId], [QuestionId], [UserName], [AnsweredTime], [AswerContent]) VALUES (4, 6, N'sang', CAST(N'2022-12-18T23:06:17.550' AS DateTime), N'Hello nghĩa là Hi')
INSERT [dbo].[Answer] ([AnswerId], [QuestionId], [UserName], [AnsweredTime], [AswerContent]) VALUES (8, 6, N'tinnguyen', CAST(N'2022-12-18T23:07:15.493' AS DateTime), N'Hello nghĩa là hi')
INSERT [dbo].[Answer] ([AnswerId], [QuestionId], [UserName], [AnsweredTime], [AswerContent]) VALUES (9, 8, N'thanhnhan', CAST(N'2022-12-18T23:08:09.587' AS DateTime), N'cái ni công nghệ nasa rồi bạn')
INSERT [dbo].[Answer] ([AnswerId], [QuestionId], [UserName], [AnsweredTime], [AswerContent]) VALUES (10, 5, N'thutrang', CAST(N'2022-12-18T23:08:42.740' AS DateTime), N'fix cai loz gì thế')
INSERT [dbo].[Answer] ([AnswerId], [QuestionId], [UserName], [AnsweredTime], [AswerContent]) VALUES (11, 13, N'thanhnhan', CAST(N'2022-12-18T23:57:46.153' AS DateTime), N'wh là cái qq gì')
INSERT [dbo].[Answer] ([AnswerId], [QuestionId], [UserName], [AnsweredTime], [AswerContent]) VALUES (12, 13, N'thanhnhan', CAST(N'2022-12-18T23:58:08.160' AS DateTime), N'wh là cái qq gì')
INSERT [dbo].[Answer] ([AnswerId], [QuestionId], [UserName], [AnsweredTime], [AswerContent]) VALUES (13, 13, N'thanhnhan', CAST(N'2022-12-18T23:58:31.273' AS DateTime), N'gì đấy')
INSERT [dbo].[Answer] ([AnswerId], [QuestionId], [UserName], [AnsweredTime], [AswerContent]) VALUES (14, 13, N'thanhnhan', CAST(N'2022-12-18T23:59:05.027' AS DateTime), N'gì đấy')
INSERT [dbo].[Answer] ([AnswerId], [QuestionId], [UserName], [AnsweredTime], [AswerContent]) VALUES (15, 2, N'thanhnhan', CAST(N'2022-12-19T02:08:52.840' AS DateTime), N'fix đi')
SET IDENTITY_INSERT [dbo].[Answer] OFF
GO
SET IDENTITY_INSERT [dbo].[Question] ON 

INSERT [dbo].[Question] ([QuestionId], [QuestionTitle], [QuestionContent], [AskedTime], [UserName], [NumOfAnswers]) VALUES (2, N'Lập trình', N'Thế nào là mạng máy tính ?', CAST(N'2022-12-18T23:00:25.127' AS DateTime), N'phetmany', 1)
INSERT [dbo].[Question] ([QuestionId], [QuestionTitle], [QuestionContent], [AskedTime], [UserName], [NumOfAnswers]) VALUES (5, N'Lập trình', N'fix bug này thế nào ?', CAST(N'2022-12-18T23:01:31.420' AS DateTime), N'thanhnhan', 1)
INSERT [dbo].[Question] ([QuestionId], [QuestionTitle], [QuestionContent], [AskedTime], [UserName], [NumOfAnswers]) VALUES (6, N'Ngoại ngữ', N'Hello nghĩa là gì mọi người ?', CAST(N'2022-12-18T23:02:19.367' AS DateTime), N'phuocle', 2)
INSERT [dbo].[Question] ([QuestionId], [QuestionTitle], [QuestionContent], [AskedTime], [UserName], [NumOfAnswers]) VALUES (7, N'Vệ sinh lap', N'Cho em hỏi cái lap vệ sinh như thế nào ạ ?', CAST(N'2022-12-18T23:02:49.117' AS DateTime), N'sang', 0)
INSERT [dbo].[Question] ([QuestionId], [QuestionTitle], [QuestionContent], [AskedTime], [UserName], [NumOfAnswers]) VALUES (8, N'API', N'Cho em hỏi cách lấy API Google', CAST(N'2022-12-18T23:03:17.667' AS DateTime), N'tinnguyen', 1)
INSERT [dbo].[Question] ([QuestionId], [QuestionTitle], [QuestionContent], [AskedTime], [UserName], [NumOfAnswers]) VALUES (9, N'Thế nào là ?', N'Thế nào là chính mình', CAST(N'2022-12-18T23:39:57.760' AS DateTime), N'tinnguyen', 0)
INSERT [dbo].[Question] ([QuestionId], [QuestionTitle], [QuestionContent], [AskedTime], [UserName], [NumOfAnswers]) VALUES (11, N'5W', N'Nhu th? nào là 5w', CAST(N'2022-12-18T23:41:36.543' AS DateTime), N'tinnguyen', 0)
INSERT [dbo].[Question] ([QuestionId], [QuestionTitle], [QuestionContent], [AskedTime], [UserName], [NumOfAnswers]) VALUES (12, N'W', N'why', CAST(N'2021-12-18T23:50:46.557' AS DateTime), N'tinnguyen', 0)
INSERT [dbo].[Question] ([QuestionId], [QuestionTitle], [QuestionContent], [AskedTime], [UserName], [NumOfAnswers]) VALUES (13, N'W', N'wh', CAST(N'2022-12-18T23:51:05.640' AS DateTime), N'tinnguyen', 4)
INSERT [dbo].[Question] ([QuestionId], [QuestionTitle], [QuestionContent], [AskedTime], [UserName], [NumOfAnswers]) VALUES (14, N'Hỏi nhanh đáp lẹ', N'Góp câu h?i di nào', CAST(N'2022-12-19T00:16:25.820' AS DateTime), N'phuocle', 0)
INSERT [dbo].[Question] ([QuestionId], [QuestionTitle], [QuestionContent], [AskedTime], [UserName], [NumOfAnswers]) VALUES (16, N'Hỏi gì nào', N'Không có gì', CAST(N'2022-12-19T02:07:38.880' AS DateTime), N'thanhnhan', 0)
SET IDENTITY_INSERT [dbo].[Question] OFF
GO
INSERT [dbo].[UserAccount] ([UserName], [Password], [FullName], [Email], [NumOfQuestions], [NumOfAnswers]) VALUES (N'phetmany', N'123', N'Phetmany Silisombath', N'tick@gmail.com', 0, 0)
INSERT [dbo].[UserAccount] ([UserName], [Password], [FullName], [Email], [NumOfQuestions], [NumOfAnswers]) VALUES (N'phuocle', N'123', N'Lê Quang Phước', N'phuoc@gmail.com', 2, 0)
INSERT [dbo].[UserAccount] ([UserName], [Password], [FullName], [Email], [NumOfQuestions], [NumOfAnswers]) VALUES (N'sang', N'123', N'Phạm Hùng Xuân Sang', N'sang@gmail.com', 0, 0)
INSERT [dbo].[UserAccount] ([UserName], [Password], [FullName], [Email], [NumOfQuestions], [NumOfAnswers]) VALUES (N'thanhnhan', N'123', N'Lê Phước Thành Nhân', N'nhan@gmail.com', 2, 7)
INSERT [dbo].[UserAccount] ([UserName], [Password], [FullName], [Email], [NumOfQuestions], [NumOfAnswers]) VALUES (N'thutrang', N'123', N'Trần Thị Thu Trang', N'trang@gmail.com', 0, 0)
INSERT [dbo].[UserAccount] ([UserName], [Password], [FullName], [Email], [NumOfQuestions], [NumOfAnswers]) VALUES (N'tinnguyen', N'123', N'Nguyễn Văn Tín', N'tinnguyen@gmail.com', 5, 0)
GO
ALTER TABLE [dbo].[Answer] ADD  CONSTRAINT [DF_Answer_AnsweredTime]  DEFAULT (getdate()) FOR [AnsweredTime]
GO
ALTER TABLE [dbo].[Question] ADD  CONSTRAINT [DF_Question_AskedTime]  DEFAULT (getdate()) FOR [AskedTime]
GO
ALTER TABLE [dbo].[Question] ADD  CONSTRAINT [DF_Question_NumOfAnswers]  DEFAULT ((0)) FOR [NumOfAnswers]
GO
ALTER TABLE [dbo].[UserAccount] ADD  CONSTRAINT [DF_UserAccount_NumOfQuestions]  DEFAULT ((0)) FOR [NumOfQuestions]
GO
ALTER TABLE [dbo].[UserAccount] ADD  CONSTRAINT [DF_UserAccount_NumOfAnswers]  DEFAULT ((0)) FOR [NumOfAnswers]
GO
ALTER TABLE [dbo].[Answer]  WITH CHECK ADD  CONSTRAINT [FK_Answer_Question] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[Question] ([QuestionId])
GO
ALTER TABLE [dbo].[Answer] CHECK CONSTRAINT [FK_Answer_Question]
GO
ALTER TABLE [dbo].[Answer]  WITH CHECK ADD  CONSTRAINT [FK_Answer_UserAccount] FOREIGN KEY([UserName])
REFERENCES [dbo].[UserAccount] ([UserName])
GO
ALTER TABLE [dbo].[Answer] CHECK CONSTRAINT [FK_Answer_UserAccount]
GO
ALTER TABLE [dbo].[Question]  WITH CHECK ADD  CONSTRAINT [FK_Question_UserAccount] FOREIGN KEY([UserName])
REFERENCES [dbo].[UserAccount] ([UserName])
GO
ALTER TABLE [dbo].[Question] CHECK CONSTRAINT [FK_Question_UserAccount]
GO
