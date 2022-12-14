USE [QLHHVT]
GO
/****** Object:  UserDefinedFunction [dbo].[func_TongDoanhThuXe]    Script Date: 12/1/2022 6:38:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[func_TongDoanhThuXe] (
	@SoXe nvarchar(50),
	@TuNgay date,
	@DenNgay date
)
returns money
as
	begin
		declare @TongTien money
		select @TongTien = sum(ndhd.MucPhi)
		from HopDongVanChuyen as hdvc join NoiDungHopDong as ndhd on hdvc.MaSoHopDong = ndhd.MaSoHopDong
		where hdvc.SoXe like  '%' + @SoXe + '%' and hdvc.NgayHopDong >= @TuNgay and hdvc.NgayHopDong <= @DenNgay
		return @TongTien
	end
GO
/****** Object:  Table [dbo].[KhachHang]    Script Date: 12/1/2022 6:38:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KhachHang](
	[MaKhachHang] [nvarchar](50) NOT NULL,
	[TenKhachHang] [nvarchar](50) NULL,
	[DiaChi] [nvarchar](50) NULL,
	[DienThoai] [nchar](11) NULL,
 CONSTRAINT [PK_KhachHang] PRIMARY KEY CLUSTERED 
(
	[MaKhachHang] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HopDongVanChuyen]    Script Date: 12/1/2022 6:38:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HopDongVanChuyen](
	[MaSoHopDong] [nvarchar](50) NOT NULL,
	[MaKhachHang] [nvarchar](50) NULL,
	[NgayHopDong] [date] NULL,
	[NgayDi] [date] NULL,
	[NgayDen] [date] NULL,
	[SoXe] [varchar](50) NULL,
	[MaLaiXe] [nvarchar](50) NULL,
	[TongTien] [money] NULL,
 CONSTRAINT [PK_HopDongVanChuyen] PRIMARY KEY CLUSTERED 
(
	[MaSoHopDong] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NoiDungHopDong]    Script Date: 12/1/2022 6:38:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NoiDungHopDong](
	[MaSoHopDong] [nvarchar](50) NOT NULL,
	[MaHangHoa] [int] NOT NULL,
	[TenHangHoa] [nvarchar](50) NULL,
	[DonViTinh] [nvarchar](50) NULL,
	[SoLuong] [int] NULL,
	[MucPhi] [money] NULL,
 CONSTRAINT [PK_NoiDungHopDong] PRIMARY KEY CLUSTERED 
(
	[MaSoHopDong] ASC,
	[MaHangHoa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[func_TongHopKhachHang]    Script Date: 12/1/2022 6:38:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[func_TongHopKhachHang] (
	@MaKhachHang nvarchar(50)
)
returns table
as
	return (
		select kh.MaKhachHang, kh.TenKhachHang, kh.DiaChi, kh.DienThoai, hdvc.MaSoHopDong, hdvc.NgayDen, hdvc.NgayHopDong, hdvc.NgayDi, hdvc.SoXe, ndhd.MucPhi
		from HopDongVanChuyen as hdvc 
			 join KhachHang as kh on kh.MaKhachHang = hdvc.MaKhachHang
			 join NoiDungHopDong ndhd on ndhd.MaSoHopDong = hdvc.MaSoHopDong
		where kh.MaKhachHang = @MaKhachHang
	)
GO
/****** Object:  View [dbo].[View_HopDongVNPT]    Script Date: 12/1/2022 6:38:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[View_HopDongVNPT]
as
	select hdvc.*, ndhd.MaHangHoa, ndhd.DonViTinh, ndhd.TenHangHoa, ndhd.SoLuong
	from HopDongVanChuyen as hdvc join NoiDungHopDong as ndhd on hdvc.MaSoHopDong = ndhd.MaSoHopDong
	where hdvc.MaSoHopDong like '%VNPT%'
GO
/****** Object:  Table [dbo].[LaiXe]    Script Date: 12/1/2022 6:38:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LaiXe](
	[MaLaiXe] [nvarchar](50) NOT NULL,
	[HoTen] [nvarchar](50) NULL,
	[NoiCuTru] [nvarchar](50) NULL,
	[DiDong] [nchar](10) NULL,
 CONSTRAINT [PK_LaiXe] PRIMARY KEY CLUSTERED 
(
	[MaLaiXe] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[XeVanTai]    Script Date: 12/1/2022 6:38:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XeVanTai](
	[SoXe] [varchar](50) NOT NULL,
	[LoaiXe] [nvarchar](50) NULL,
	[TaiTrong] [float] NULL,
	[NgayBDSuDung] [date] NULL,
 CONSTRAINT [PK_XeVanTai] PRIMARY KEY CLUSTERED 
(
	[SoXe] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[HopDongVanChuyen] ([MaSoHopDong], [MaKhachHang], [NgayHopDong], [NgayDi], [NgayDen], [SoXe], [MaLaiXe], [TongTien]) VALUES (N'1', N'1', CAST(N'2022-11-30' AS Date), CAST(N'2023-02-02' AS Date), CAST(N'2023-02-09' AS Date), N'70B-00403', N'20160001', 50000000.0000)
INSERT [dbo].[HopDongVanChuyen] ([MaSoHopDong], [MaKhachHang], [NgayHopDong], [NgayDi], [NgayDen], [SoXe], [MaLaiXe], [TongTien]) VALUES (N'2', N'2', CAST(N'2022-11-30' AS Date), CAST(N'2023-04-02' AS Date), CAST(N'2023-04-11' AS Date), N'51F-18168', N'20160002', 10000000.0000)
INSERT [dbo].[HopDongVanChuyen] ([MaSoHopDong], [MaKhachHang], [NgayHopDong], [NgayDi], [NgayDen], [SoXe], [MaLaiXe], [TongTien]) VALUES (N'3', N'3', CAST(N'2022-10-30' AS Date), CAST(N'2023-11-02' AS Date), CAST(N'2023-11-08' AS Date), N'90T-54381', N'20160003', 65000000.0000)
INSERT [dbo].[HopDongVanChuyen] ([MaSoHopDong], [MaKhachHang], [NgayHopDong], [NgayDi], [NgayDen], [SoXe], [MaLaiXe], [TongTien]) VALUES (N'4', N'4', CAST(N'2022-10-30' AS Date), CAST(N'2023-01-02' AS Date), CAST(N'2023-01-08' AS Date), N'51F-18168', N'20160004', 50000000.0000)
INSERT [dbo].[HopDongVanChuyen] ([MaSoHopDong], [MaKhachHang], [NgayHopDong], [NgayDi], [NgayDen], [SoXe], [MaLaiXe], [TongTien]) VALUES (N'5', N'5', CAST(N'2022-08-30' AS Date), CAST(N'2022-09-01' AS Date), CAST(N'2022-09-05' AS Date), N'34C-00172', N'20160001', 24000000.0000)
INSERT [dbo].[HopDongVanChuyen] ([MaSoHopDong], [MaKhachHang], [NgayHopDong], [NgayDi], [NgayDen], [SoXe], [MaLaiXe], [TongTien]) VALUES (N'VNPT01', N'1', CAST(N'2022-11-30' AS Date), CAST(N'2023-04-02' AS Date), CAST(N'2023-11-08' AS Date), N'51F-18168', N'20160002', 60000000.0000)
INSERT [dbo].[HopDongVanChuyen] ([MaSoHopDong], [MaKhachHang], [NgayHopDong], [NgayDi], [NgayDen], [SoXe], [MaLaiXe], [TongTien]) VALUES (N'VNPT02', N'3', CAST(N'2022-10-30' AS Date), CAST(N'2023-11-02' AS Date), CAST(N'2023-11-08' AS Date), N'90T-54381', N'20160004', 100000000.0000)
INSERT [dbo].[HopDongVanChuyen] ([MaSoHopDong], [MaKhachHang], [NgayHopDong], [NgayDi], [NgayDen], [SoXe], [MaLaiXe], [TongTien]) VALUES (N'VNPT03', N'1', CAST(N'2022-06-30' AS Date), CAST(N'2022-07-01' AS Date), CAST(N'2022-07-12' AS Date), N'34C-00172', N'20160002', NULL)
GO
INSERT [dbo].[KhachHang] ([MaKhachHang], [TenKhachHang], [DiaChi], [DienThoai]) VALUES (N'1', N'Trương Mỹ Lan', N'Hà Nội', N'0979731085 ')
INSERT [dbo].[KhachHang] ([MaKhachHang], [TenKhachHang], [DiaChi], [DienThoai]) VALUES (N'2', N'Lý Thế Hợp', N'Nghệ An', N'0979978234 ')
INSERT [dbo].[KhachHang] ([MaKhachHang], [TenKhachHang], [DiaChi], [DienThoai]) VALUES (N'3', N'Ngô Quang Bảo', N'Hòa Binh', N'0933982002 ')
INSERT [dbo].[KhachHang] ([MaKhachHang], [TenKhachHang], [DiaChi], [DienThoai]) VALUES (N'4', N'Nguyễn Văn Tiến', N'Huế', N'0934349099 ')
INSERT [dbo].[KhachHang] ([MaKhachHang], [TenKhachHang], [DiaChi], [DienThoai]) VALUES (N'5', N'Nguyễn Xuân Phúc', N'Vũng Tàu', N'0123456789 ')
GO
INSERT [dbo].[LaiXe] ([MaLaiXe], [HoTen], [NoiCuTru], [DiDong]) VALUES (N'20160001', N'Nguyen Van A', N'Đà Lạt', N'0905476679')
INSERT [dbo].[LaiXe] ([MaLaiXe], [HoTen], [NoiCuTru], [DiDong]) VALUES (N'20160002', N'Nguyen Van B', N'Hà Nội', N'0784658812')
INSERT [dbo].[LaiXe] ([MaLaiXe], [HoTen], [NoiCuTru], [DiDong]) VALUES (N'20160003', N'Nguyen Van C', N'Quảng Bình', N'0127998722')
INSERT [dbo].[LaiXe] ([MaLaiXe], [HoTen], [NoiCuTru], [DiDong]) VALUES (N'20160004', N'Nguyen Van D', N'Gia Lai', N'0945672283')
INSERT [dbo].[LaiXe] ([MaLaiXe], [HoTen], [NoiCuTru], [DiDong]) VALUES (N'20160005', N'Nguyen Van E', N'Lào Cai', N'0987636621')
GO
INSERT [dbo].[NoiDungHopDong] ([MaSoHopDong], [MaHangHoa], [TenHangHoa], [DonViTinh], [SoLuong], [MucPhi]) VALUES (N'1', 1, N'Hàng điện lạnh', N'VND', 10, 20000000.0000)
INSERT [dbo].[NoiDungHopDong] ([MaSoHopDong], [MaHangHoa], [TenHangHoa], [DonViTinh], [SoLuong], [MucPhi]) VALUES (N'1', 8, N'Hàng gia dụng', N'VND', 10, 30000000.0000)
INSERT [dbo].[NoiDungHopDong] ([MaSoHopDong], [MaHangHoa], [TenHangHoa], [DonViTinh], [SoLuong], [MucPhi]) VALUES (N'2', 2, N'Hàng gia dụng', N'VND', 8, 10000000.0000)
INSERT [dbo].[NoiDungHopDong] ([MaSoHopDong], [MaHangHoa], [TenHangHoa], [DonViTinh], [SoLuong], [MucPhi]) VALUES (N'3', 3, N'Hàng nội thất', N'VND', 12, 30000000.0000)
INSERT [dbo].[NoiDungHopDong] ([MaSoHopDong], [MaHangHoa], [TenHangHoa], [DonViTinh], [SoLuong], [MucPhi]) VALUES (N'3', 9, N'Hàng điện tử', N'VND', 8, 25000000.0000)
INSERT [dbo].[NoiDungHopDong] ([MaSoHopDong], [MaHangHoa], [TenHangHoa], [DonViTinh], [SoLuong], [MucPhi]) VALUES (N'3', 10, N'Hàng áo quần', N'VND', 10, 10000000.0000)
INSERT [dbo].[NoiDungHopDong] ([MaSoHopDong], [MaHangHoa], [TenHangHoa], [DonViTinh], [SoLuong], [MucPhi]) VALUES (N'4', 4, N'Hàng trái cây', N'VND', 20, 50000000.0000)
INSERT [dbo].[NoiDungHopDong] ([MaSoHopDong], [MaHangHoa], [TenHangHoa], [DonViTinh], [SoLuong], [MucPhi]) VALUES (N'5', 5, N'Hàng áo quần', N'VND', 18, 24000000.0000)
INSERT [dbo].[NoiDungHopDong] ([MaSoHopDong], [MaHangHoa], [TenHangHoa], [DonViTinh], [SoLuong], [MucPhi]) VALUES (N'VNPT01', 6, N'Hàng siêu thị', N'VND', 22, 60000000.0000)
INSERT [dbo].[NoiDungHopDong] ([MaSoHopDong], [MaHangHoa], [TenHangHoa], [DonViTinh], [SoLuong], [MucPhi]) VALUES (N'VNPT02', 7, N'Hàng máy tập thể thao', N'VND', 30, 100000000.0000)
GO
INSERT [dbo].[XeVanTai] ([SoXe], [LoaiXe], [TaiTrong], [NgayBDSuDung]) VALUES (N'34C-00172', N'Xe tải hạng trung', 10000, CAST(N'2016-06-12' AS Date))
INSERT [dbo].[XeVanTai] ([SoXe], [LoaiXe], [TaiTrong], [NgayBDSuDung]) VALUES (N'51C-55693', N'Xe tải hạng nặng', 16788, CAST(N'2016-11-30' AS Date))
INSERT [dbo].[XeVanTai] ([SoXe], [LoaiXe], [TaiTrong], [NgayBDSuDung]) VALUES (N'51F-18168', N'Xe tải hạng nhẹ', 2268, CAST(N'2016-01-09' AS Date))
INSERT [dbo].[XeVanTai] ([SoXe], [LoaiXe], [TaiTrong], [NgayBDSuDung]) VALUES (N'70B-00403', N'Xe tải hạng nhẹ', 1872, CAST(N'2016-08-30' AS Date))
INSERT [dbo].[XeVanTai] ([SoXe], [LoaiXe], [TaiTrong], [NgayBDSuDung]) VALUES (N'90T-54381', N'Xe tải hạng trung', 8647, CAST(N'2017-02-01' AS Date))
GO
ALTER TABLE [dbo].[HopDongVanChuyen]  WITH CHECK ADD  CONSTRAINT [FK_HopDongVanChuyen_KhachHang] FOREIGN KEY([MaKhachHang])
REFERENCES [dbo].[KhachHang] ([MaKhachHang])
GO
ALTER TABLE [dbo].[HopDongVanChuyen] CHECK CONSTRAINT [FK_HopDongVanChuyen_KhachHang]
GO
ALTER TABLE [dbo].[HopDongVanChuyen]  WITH CHECK ADD  CONSTRAINT [FK_HopDongVanChuyen_LaiXe] FOREIGN KEY([MaLaiXe])
REFERENCES [dbo].[LaiXe] ([MaLaiXe])
GO
ALTER TABLE [dbo].[HopDongVanChuyen] CHECK CONSTRAINT [FK_HopDongVanChuyen_LaiXe]
GO
ALTER TABLE [dbo].[HopDongVanChuyen]  WITH CHECK ADD  CONSTRAINT [FK_HopDongVanChuyen_XeVanTai] FOREIGN KEY([SoXe])
REFERENCES [dbo].[XeVanTai] ([SoXe])
GO
ALTER TABLE [dbo].[HopDongVanChuyen] CHECK CONSTRAINT [FK_HopDongVanChuyen_XeVanTai]
GO
ALTER TABLE [dbo].[NoiDungHopDong]  WITH CHECK ADD  CONSTRAINT [FK_NoiDungHopDong_HopDongVanChuyen] FOREIGN KEY([MaSoHopDong])
REFERENCES [dbo].[HopDongVanChuyen] ([MaSoHopDong])
GO
ALTER TABLE [dbo].[NoiDungHopDong] CHECK CONSTRAINT [FK_NoiDungHopDong_HopDongVanChuyen]
GO
/****** Object:  StoredProcedure [dbo].[proc_HopDongVanChuyen_Insert]    Script Date: 12/1/2022 6:38:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[proc_HopDongVanChuyen_Insert] (
	@MaSoHopDong nvarchar(50),
	@MaKhachHang nvarchar(50),
	@NgayHopDong date,
	@NgayDi date,
	@NgayDen date,
	@SoXe nvarchar(50),
	@MaLaiXe nvarchar(50)
)
as
	begin
		set nocount on;
		if (not exists (
			select *
			from KhachHang
			where @MaKhachHang = MaKhachHang
		))
			return 0;
		if (not exists (
			select *
			from KhachHang
			where @MaKhachHang = MaKhachHang
		))
			return 0;
		if (not exists (
			select *
			from XeVanTai
			where @SoXe = SoXe
		))
			return 0;
		if (not exists (
			select *
			from LaiXe
			where @MaLaiXe = MaLaiXe
		))
			return 0;

		insert into HopDongVanChuyen(MaSoHopDong, MaKhachHang, NgayDi, NgayDen, SoXe, MaLaiXe)
		values(@MaSoHopDong, @MaKhachHang, @NgayDi, @NgayDen, @SoXe, @MaLaiXe)
		
	end
GO
/****** Object:  StoredProcedure [dbo].[proc_HopDongVanChuyen_ThongKe]    Script Date: 12/1/2022 6:38:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[proc_HopDongVanChuyen_ThongKe] (
	@TuNgay date,
	@DenNgay date
)
as
	begin
		set nocount on;
		select sum(ndhd.MucPhi)
		from NoiDungHopDong as ndhd join HopDongVanChuyen as hdvc on ndhd.MaSoHopDong = hdvc.MaSoHopDong
		where hdvc.NgayHopDong >= @TuNgay and hdvc.NgayHopDong <= @DenNgay
	end
GO
/****** Object:  StoredProcedure [dbo].[proc_KhachHang_Delete]    Script Date: 12/1/2022 6:38:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[proc_KhachHang_Delete] (
	@MaKhachHang nvarchar(50)
)
as
	begin
		set nocount on;
		if (
			exists (
				select *
				from KhachHang
				where @MaKhachHang = MaKhachHang
			)
		)
			return 0;

		delete KhachHang
		where @MaKhachHang = MaKhachHang
	end
GO
/****** Object:  StoredProcedure [dbo].[proc_LaiXe_Delete]    Script Date: 12/1/2022 6:38:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[proc_LaiXe_Delete] (
	@MaLaiXe nvarchar(50)
)
as
	begin
		set nocount on;
		if (
			exists (
				select *
				from LaiXe
				where @MaLaiXe = MaLaiXe
			)
		)
			return 0;

		delete LaiXe
		where @MaLaiXe = MaLaiXe
	end
GO
/****** Object:  StoredProcedure [dbo].[proc_XeVanTai_Delete]    Script Date: 12/1/2022 6:38:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[proc_XeVanTai_Delete] (
	@SoXe nvarchar(50)
)
as
	begin
		set nocount on;
		if (
			exists (
				select *
				from HopDongVanChuyen
				where @SoXe = SoXe
			)
		)
			return 0;

		delete XeVanTai
		where @SoXe = SoXe
	end
GO
