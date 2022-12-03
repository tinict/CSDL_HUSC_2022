/*
Bài tập
1. Viết thủ tục lấy ra danh sách khách hàng
2. Viết thủ tục với tham số truyền vào là giới tính lấy ra thông tin những khách hàng
3. Viết thủ tục truyền vào là Họ và lấy ra danh sách có Họ như được truyền vào
4. viết thủ tục với tham số truyền vào là tháng, năm. Ds gôm MaHD, NgayLap, TongTien = sl bán * Donggia bán
5. viết thủ tục với tham số tổng tiền. Thủ tục dùng để lấy ra các hóa đơn có tổng tiền lớn hơn tổng tiền truyền vào
6. Viết thủ tục dùng để thêm mới 1 mặt hàng với các thông số thêm mới của mặt hàng chính là tham số truyền vào
7. Viết thủ tục với tham số truyền vòa là năm. Thủ tục dùng để thống kê mỗi tháng trong năm truyền vào có doanh thu là bao nhiêu 
*/

--ĐÁP ÁN
--1. Viết thủ tục lấy ra danh sách khách hàng

if (
	exists (
		select *
		from sys.objects
		where name = 'proc_DanhSachKhachHang'
	)
)
	drop procedure proc_DanhSachKhachHang
go
create procedure proc_DanhSachKhachHang
as
	begin
		set nocount on;
		select *
		from tbl_KhachHang
	end
go

--Test case
execute proc_DanhSachKhachHang

--2. Viết thủ tục với tham số truyền vào là giới tính lấy ra thông tin những khách hàng
if (
	exists (
		select *
		from sys.objects
		where name = 'proc_DSKH_GioiTinh'
	)
)
	drop procedure proc_DSKH_GioiTinh
go
create procedure proc_DSKH_GioiTinh(
	@Sex bit
)
as
	begin
		select *
		from tbl_KhachHang
		where @Sex = tbl_KhachHang.GT
	end
go

--Test case
declare @Sex bit = 1
execute proc_DSKH_GioiTinh
		@Sex = @Sex
--3. Viết thủ tục truyền vào là Họ và lấy ra danh sách có Họ như được truyền vào
if (
	exists (
		select *
		from sys.objects
		where name = 'proc_DSKH_Ho'
	)
)
	drop procedure proc_DSKH_Ho
go
create procedure proc_DSKH_Ho (
	@Ho nvarchar(50)
)
as
	begin
		select *
		from tbl_KhachHang as kh
		where kh.TenKH like N'' + '%' + @Ho + '%'
	end
go

--Test case
declare @Ho nvarchar(50) = N'Nguyễn'
execute proc_DSKH_Ho
		@Ho = @Ho

--4. viết thủ tục với tham số truyền vào là tháng, năm. Ds gôm MaHD, NgayLap, TongTien = sl bán * Donggia bán
if (
	exists (
		select *
		from sys.objects
		where name = 'proc_DSKH'
	)
)
	drop procedure proc_DSKH
go
create procedure proc_DSKH (
	@Month int,
	@year int
)
as
	begin
		set nocount on;
		select hd.MaHD, hd.NgayLap, sum (cthd.SL *  cthd.DonGia) as TongTien
		from tbl_KhachHang as kh 
			 join tbl_HoaDon as hd on kh.MaKH = hd.MaKH
			 join tbl_CTHD as cthd on hd.MaHD = cthd.MaHD
		where MONTH(hd.NgayLap) = @Month and YEAR(hd.NgayLap) = @year
		group by hd.MaHD, hd.NgayLap
	end
go

--Test case
declare @Month int = 2,
		@Year int = 2022
execute	proc_DSKH
		@Month = @Month,
		@Year = @Year

--5 Viết thủ tục với tham số tổng tiền. Thủ tục dùng để lấy ra các hóa đơn có tổng tiền lớn hơn tổng tiền truyền vào
if (
	exists (
		select *
		from sys.objects
		where name = 'proc_LonHonTongTien'
	)
)
	drop procedure proc_LonHonTongTien
go
create procedure proc_LonHonTongTien (
	@TongTien int
)
as
	begin
		set nocount on;
		select hd.MaHD, hd.NgayLap, sum (cthd.SL *  cthd.DonGia) as TongTien
		from tbl_KhachHang as kh 
			 join tbl_HoaDon as hd on kh.MaKH = hd.MaKH
			 join tbl_CTHD as cthd on hd.MaHD = cthd.MaHD
		where cthd.SL *  cthd.DonGia > @TongTien
		group by hd.MaHD, hd.NgayLap
	end
go

--Test case
declare @TongTien int = 100
execute proc_LonHonTongTien
		@TongTien = @TongTien

--6. Viết thủ tục dùng để thêm mới 1 mặt hàng với các thông số thêm mới của mặt hàng chính là tham số truyền vào
if (
	exists (
		select *
		from sys.objects
		where name = 'proc_Insert_MatHang'
	)
)
	drop procedure proc_Insert_MatHang
go
create procedure proc_Insert_MatHang (
	@MaHang int,
	@TenHang nvarchar(50),
	@SL int, 
	@DonGia int,
	@NhaSX nvarchar(50),
	@NgaySX date,
	@Result int output
)
as
	begin
		set nocount on;
		if (
			exists (
				select *
				from tbl_Hang
				where tbl_Hang.MaHang = @MaHang
			)
		)
			begin
				set @Result = 0;
				return 0;
			end
		insert into tbl_Hang (MaHang, TenHang, SL, DonGia, NhaSX, NgaySX)
		values (@MaHang, @TenHang, @SL, @DonGia, @NhaSX, @NgaySX)
		set @Result = 1;
	end
go

--Test case
declare @MaHang int = 7,
		@TenHang nvarchar(50) = 'SSD',
		@SL int = 10, 
		@DonGia int = 25,
		@NhaSX nvarchar(50) = 'SamSung',
		@NgaySX date = GETDATE(),
		@Result int
execute proc_Insert_MatHang
		@MaHang = @MaHang,
		@TenHang = @TenHang,
		@SL = @SL, 
		@DonGia = @DonGia,
		@NhaSX = @NhaSX,
		@NgaySX = @NgaySX,
		@Result = @Result output

select @Result

--7. Viết thủ tục với tham số truyền vào là năm. Thủ tục dùng để thống kê mỗi tháng trong năm truyền vào có doanh thu là bao nhiêu 
if (
	exists (
		select *
		from sys.objects
		where name = 'proc_ThongKeDoanhThu'
	)
)
	drop procedure proc_ThongKeDoanhThu
go
create procedure proc_ThongKeDoanhThu (
	@year int
)
as
	begin
		set nocount on;
		declare @tbl_Month table (
			Month int
		)
		declare @index int = 1;
		while (@index <= 12)
			begin
				insert into @tbl_Month(Month)
				values(@index)
				set @index = @index + 1;
			end
		select tbMonth.Month, ISNULL(tb_TK.TongTien, 0) as N'Doanh thu'
		from @tbl_Month as tbMonth left join (
			select Month(hd.NgayLap) as Month, sum(cthd.SL * cthd.DonGia) as TongTien
			from tbl_HoaDon as hd 
				 join tbl_CTHD as cthd on hd.MaHD = cthd.MaHD
				 join tbl_Hang as h on h.MaHang = cthd.MaHang
			where YEAR(hd.NgayLap) = 2022
			group by Month(hd.NgayLap)
		) as tb_TK on tb_TK.Month = tbMonth.Month
	end
go
