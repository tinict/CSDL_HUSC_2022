USE [QLBH]
GO
/****** Object:  Table [dbo].[tbl_CTHD]    Script Date: 3/12/2022 9:22:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_CTHD](
	[MaHD] [int] NOT NULL,
	[MaHang] [int] NOT NULL,
	[SL] [int] NOT NULL,
	[DonGia] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Hang]    Script Date: 3/12/2022 9:22:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Hang](
	[MaHang] [int] NOT NULL,
	[TenHang] [nvarchar](50) NOT NULL,
	[SL] [int] NULL,
	[DonGia] [int] NULL,
	[NhaSX] [nvarchar](50) NULL,
	[NgaySX] [date] NULL,
 CONSTRAINT [PK_tbl_Hang] PRIMARY KEY CLUSTERED 
(
	[MaHang] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_HoaDon]    Script Date: 3/12/2022 9:22:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_HoaDon](
	[MaHD] [int] NOT NULL,
	[MaKH] [int] NOT NULL,
	[NgayLap] [datetime] NOT NULL,
 CONSTRAINT [PK_tbl_HoaDon] PRIMARY KEY CLUSTERED 
(
	[MaHD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_KhachHang]    Script Date: 3/12/2022 9:22:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_KhachHang](
	[MaKH] [int] IDENTITY(1,1) NOT NULL,
	[TenKH] [nvarchar](50) NOT NULL,
	[SDT] [varchar](10) NULL,
	[DiaChi] [nvarchar](100) NULL,
	[Email] [varchar](20) NULL,
	[GT] [bit] NULL,
 CONSTRAINT [PK_tbl_KhachHang] PRIMARY KEY CLUSTERED 
(
	[MaKH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[tbl_CTHD] ([MaHD], [MaHang], [SL], [DonGia]) VALUES (2, 2, 5, 40)
INSERT [dbo].[tbl_CTHD] ([MaHD], [MaHang], [SL], [DonGia]) VALUES (1, 3, 2, 50)
INSERT [dbo].[tbl_CTHD] ([MaHD], [MaHang], [SL], [DonGia]) VALUES (2, 2, 1, 40)
INSERT [dbo].[tbl_CTHD] ([MaHD], [MaHang], [SL], [DonGia]) VALUES (2, 4, 1, 70)
INSERT [dbo].[tbl_CTHD] ([MaHD], [MaHang], [SL], [DonGia]) VALUES (3, 2, 1, 40)
INSERT [dbo].[tbl_CTHD] ([MaHD], [MaHang], [SL], [DonGia]) VALUES (4, 4, 7, 7)
INSERT [dbo].[tbl_CTHD] ([MaHD], [MaHang], [SL], [DonGia]) VALUES (1, 3, 5, 40)
GO
INSERT [dbo].[tbl_Hang] ([MaHang], [TenHang], [SL], [DonGia], [NhaSX], [NgaySX]) VALUES (2, N'Ram 8G', 4, 34, N'AAA', CAST(N'2020-02-02' AS Date))
INSERT [dbo].[tbl_Hang] ([MaHang], [TenHang], [SL], [DonGia], [NhaSX], [NgaySX]) VALUES (3, N'SSD 120G', 3, 45, N'BBB', CAST(N'2021-03-03' AS Date))
INSERT [dbo].[tbl_Hang] ([MaHang], [TenHang], [SL], [DonGia], [NhaSX], [NgaySX]) VALUES (4, N'SSD 240G', 15, 65, N'BBB', CAST(N'2021-01-01' AS Date))
INSERT [dbo].[tbl_Hang] ([MaHang], [TenHang], [SL], [DonGia], [NhaSX], [NgaySX]) VALUES (5, N'USB 32G', 16, 10, N'CCC', CAST(N'2021-01-01' AS Date))
GO
INSERT [dbo].[tbl_HoaDon] ([MaHD], [MaKH], [NgayLap]) VALUES (1, 1, CAST(N'2022-01-01T00:00:00.000' AS DateTime))
INSERT [dbo].[tbl_HoaDon] ([MaHD], [MaKH], [NgayLap]) VALUES (2, 2, CAST(N'2022-02-02T00:00:00.000' AS DateTime))
INSERT [dbo].[tbl_HoaDon] ([MaHD], [MaKH], [NgayLap]) VALUES (3, 1, CAST(N'2022-02-07T00:00:00.000' AS DateTime))
INSERT [dbo].[tbl_HoaDon] ([MaHD], [MaKH], [NgayLap]) VALUES (4, 1, CAST(N'2022-02-10T00:00:00.000' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[tbl_KhachHang] ON 

INSERT [dbo].[tbl_KhachHang] ([MaKH], [TenKH], [SDT], [DiaChi], [Email], [GT]) VALUES (1, N'Nguyễn Văn An', N'345345345', N'111 Nguyễn Huệ', NULL, 1)
INSERT [dbo].[tbl_KhachHang] ([MaKH], [TenKH], [SDT], [DiaChi], [Email], [GT]) VALUES (2, N'Lê Thị Bê', N'345456456', N'222 Hai Bà Trưng', N'a@gmail.com', 0)
INSERT [dbo].[tbl_KhachHang] ([MaKH], [TenKH], [SDT], [DiaChi], [Email], [GT]) VALUES (3, N'Trần Văn Cê', N'657454564', N'333 Ngô Quyền', NULL, 1)
SET IDENTITY_INSERT [dbo].[tbl_KhachHang] OFF
GO
ALTER TABLE [dbo].[tbl_CTHD]  WITH CHECK ADD  CONSTRAINT [FK_tbl_CTHD_tbl_Hang] FOREIGN KEY([MaHang])
REFERENCES [dbo].[tbl_Hang] ([MaHang])
GO
ALTER TABLE [dbo].[tbl_CTHD] CHECK CONSTRAINT [FK_tbl_CTHD_tbl_Hang]
GO
ALTER TABLE [dbo].[tbl_CTHD]  WITH CHECK ADD  CONSTRAINT [FK_tbl_CTHD_tbl_HoaDon] FOREIGN KEY([MaHD])
REFERENCES [dbo].[tbl_HoaDon] ([MaHD])
GO
ALTER TABLE [dbo].[tbl_CTHD] CHECK CONSTRAINT [FK_tbl_CTHD_tbl_HoaDon]
GO
ALTER TABLE [dbo].[tbl_HoaDon]  WITH CHECK ADD  CONSTRAINT [FK_tbl_HoaDon_tbl_KhachHang] FOREIGN KEY([MaKH])
REFERENCES [dbo].[tbl_KhachHang] ([MaKH])
GO
ALTER TABLE [dbo].[tbl_HoaDon] CHECK CONSTRAINT [FK_tbl_HoaDon_tbl_KhachHang]
GO
