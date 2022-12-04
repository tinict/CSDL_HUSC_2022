--câu 2
/*
a. Tạo một khung nhìn có tên là View_HopDongVNPT với nội dung của khung nhìn là
thông tin về các hợp đồng của khách hàng có mã là VNPT
*/
if (
	exists (
		select *
		from sys.objects
		where name = 'View_HopDongVNPT'
	)
)
	drop view View_HopDongVNPT
go
create view View_HopDongVNPT
as
	select hdvc.*, ndhd.MaHangHoa, ndhd.DonViTinh, ndhd.TenHangHoa, ndhd.SoLuong
	from HopDongVanChuyen as hdvc join NoiDungHopDong as ndhd on hdvc.MaSoHopDong = ndhd.MaSoHopDong
	where hdvc.MaSoHopDong like '%VNPT%'
go

select *
from View_HopDongVNPT

/*
b. Tạo tài khoản vnpt_user và cấp quyền cho phép tài khoản này được phép truy xuất
dữ liệu của khung nhìn trên.
*/
USE QLHHVT
GO
CREATE login vnpt_user WITH PASSWORD = '1'
GO

GRANT ALL ON View_HopDongVNPT
TO vnpt_user

--cau 3
/*
a. Bổ sung cho bảng NoiDungHopDong cột MucPhi (mức phí trên mỗi đơn vị hàng
hóa được vận chuyển)
*/

alter table NoiDungHopDong
add MucPhi money

--cau 4
/*
a. Viết thủ tục proc_HopDongVanChuyen_ThongKe @TuNgay, @DenNgay có chức
năng hiển thị thông tin của các hợp đồng (kể cả tổng tiền) được lập trong khoảng thời
gian từ ngày @TuNgay đến ngày @DenNgay
*/

if (
	exists (
		select *
		from sys.objects
		where name = 'proc_HopDongVanChuyen_ThongKe'
	)
)
	drop procedure proc_HopDongVanChuyen_ThongKe
go
create procedure proc_HopDongVanChuyen_ThongKe (
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
go

--Test case
declare @TuNgay date = '2022-8-30',
		@DenNgay date = '2022-10-30'
execute proc_HopDongVanChuyen_ThongKe
		@TuNgay = @TuNgay,
		@DenNgay = @DenNgay

/*
b. Viết thủ tục proc_HopDongVanChuyen_Insert có chức năng bổ sung thêm một hợp
đồng vận chuyển mới (lưu ý: phải kiểm tra để đảm bảo tính đúng đắn và toàn vẹn của
dữ liệu)
*/

if (
	exists (
		select *
		from sys.objects
		where name = 'proc_HopDongVanChuyen_Insert'
	)
)
	drop procedure proc_HopDongVanChuyen_Insert
go
create procedure proc_HopDongVanChuyen_Insert (
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
go

--Test case
declare @MaSoHopDong nvarchar(50) = 'VNPT03',
		@MaKhachHang nvarchar(50) = 1,
		@NgayHopDong date = '2022-12-01',
		@NgayDi date = '2022-07-01',
		@NgayDen date = '2022-07-12',
		@SoXe nvarchar(50) = '34C-00172',
		@MaLaiXe nvarchar(50) = '20160002'
execute proc_HopDongVanChuyen_Insert
		@MaSoHopDong = @MaSoHopDong,
		@MaKhachHang = @MaKhachHang,
		@NgayHopDong = @NgayHopDong,
		@NgayDi = @NgayDi,
		@NgayDen = @NgayDen,
		@SoXe = @SoXe,
		@MaLaiXe = @MaLaiXe
/*
c. Viết các thủ tục proc_<Tên_bảng>_Delete (trong đó <Tên_bảng> là tên của các
bảng như đã cho, để thực hiện việc xóa dữ liệu ra khỏi các bảng. Lưu ý: không được
xóa dữ liệu trong bảng nếu dữ liệu đó đang được tham chiếu bởi các bảng khác
*/

--DELETE XE VAN TAI
if (
	exists (
		select *
		from sys.objects
		where name = 'proc_XeVanTai_Delete'
	)
)
	drop procedure proc_XeVanTai_Delete
go
create procedure proc_XeVanTai_Delete (
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
go

--Test case
declare @SoXe nvarchar(50) = '34C-00172'
execute proc_XeVanTai_Delete
		@SoXe = @SoXe

--DELETE LAI XE
if (
	exists (
		select *
		from sys.objects
		where name = 'proc_LaiXe_Delete'
	)
)
	drop procedure proc_LaiXe_Delete
go
create procedure proc_LaiXe_Delete (
	@MaLaiXe nvarchar(50)
)
as
	begin
		set nocount on;
		if (
			exists (
				select *
				from HopDongVanChuyen
				where @MaLaiXe = MaLaiXe
			)
		)
			return 0;

		delete LaiXe
		where @MaLaiXe = MaLaiXe
	end
go

--Test case
declare @MaLaiXe nvarchar(50) = '20160001'
execute proc_LaiXe_Delete
		@MaLaiXe = @MaLaiXe

--DELETE KHÁCH HÀNG
if (
	exists (
		select *
		from sys.objects
		where name = 'proc_KhachHang_Delete'
	)
)
	drop procedure proc_KhachHang_Delete
go
create procedure proc_KhachHang_Delete (
	@MaKhachHang nvarchar(50)
)
as
	begin
		set nocount on;
		if (
			exists (
				select *
				from HopDongVanChuyen
				where @MaKhachHang = MaKhachHang
			)
		)
			return 0;

		delete KhachHang
		where @MaKhachHang = MaKhachHang
	end
go

--Test case
declare @MaKhachHang nvarchar(50) = '1'
execute proc_KhachHang_Delete
		@MaKhachHang = @MaKhachHang

--DELETE HỢP ĐỒNG VẬN CHUYỂN
if (
	exists (
		select *
		from sys.objects
		where name = 'proc_HopDongVanChuyen_Delete'
	)
)
	drop procedure proc_HopDongVanChuyen_Delete
go
create procedure proc_HopDongVanCHuyen_Delete (
	@MaSoHopDong nvarchar(50)
)
as
	begin
		set nocount on;

		delete HopDongVanChuyen
		where @MaSoHopDong = MaSoHopDong
	end
go

--Test case
declare @MaSoHopDong nvarchar(50) = '1'
execute proc_HopDongVanChuyen_Delete
		@MaSoHopDong = @MaSoHopDong

--DELETE NỘI DUNG HỢP ĐỒNG
if (
	exists (
		select *
		from sys.objects
		where name = 'proc_NoiDungHopDong_Delete'
	)
)
	drop procedure proc_NoiDungHopDong_Delete
go
create procedure proc_NoiDungHopDong_Delete (
	@MaSoHopDong nvarchar(50)
)
as
	begin
		set nocount on;
		if (
			exists (
				select *
				from HopDongVanChuyen
				where @MaSoHopDong = @MaSoHopDong
			)
		)
			return 0;

		delete NoiDungHopDong
		where @MaSoHopDong = @MaSoHopDong
	end
go

--Test case
declare @MaSoHopDong nvarchar(50) = '1'
execute proc_NoiDungHopDong_Delete
		@MaSoHopDong = @MaSoHopDong

--cau 5
/*
a. Viết hàm func_TongHopKhachHang (@MaKhachHang) có chức năng thực hiện
báo cáo tổng hợp thông tin về các hợp đồng vận chuyển (kể cả tổng số tiền) của khách
hàng có mã là @MaKhachHang
*/
if (
	exists (
		select *
		from sys.objects
		where name = 'func_TongHopKhachHang'
	)
)
	drop function func_TongHopKhachHang
go
create function func_TongHopKhachHang (
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
go

--Test case
select *
from dbo.func_TongHopKhachHang('2')

/*
b. Viết hàm func_TongDoanhThuXe (@SoXe, @TuNgay, @DenNgay) để tính tổng
số tiền doanh thu của xe có số xe là @SoXe trong khoảng thời gian từ ngày
@TuNgay đến ngày @DenNgay
*/

if (
	exists (
		select *
		from sys.objects
		where name = 'func_TongDoanhThuXe'
	)
)
	drop function func_TongDoanhThuXe
go
create function func_TongDoanhThuXe (
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
go

--Test
select dbo.func_TongDoanhThuXe('70B-00403', '2015-01-01', '2022-12-01')

--cau 6
--a. Bổ sung cho bảng HopDongVanChuyen cột TongTien

alter table HopDongVanChuyen
add TongTien money
--

select *
from HopDongVanChuyen

--b Tính giá trị cho cột TongTien
DECLARE @MaSoHopDong nvarchar(50)
DECLARE @TongTien money


DECLARE cursorHopDongVanChuyen CURSOR FOR 
SELECT MaSoHopDong, TongTien FROM HopDongVanChuyen    

OPEN cursorHopDongVanChuyen             

FETCH NEXT FROM cursorHopDongVanChuyen   
      INTO @MaSoHopDong, @TongTien

WHILE @@FETCH_STATUS = 0          
BEGIN
	update HopDongVanChuyen
	set TongTien = (
		select sum(NoiDungHopDong.MucPhi)
		from NoiDungHopDong
		where NoiDungHopDong.MaSoHopDong = @MaSoHopDong
		group by NoiDungHopDong.MaSoHopDong
	)
	where MaSoHopDong = @MaSoHopDong
    FETCH NEXT FROM cursorHopDongVanChuyen 
          INTO @MaSoHopDong, @TongTien
END

CLOSE cursorHopDongVanChuyen               
DEALLOCATE cursorHopDongVanChuyen         

/*
c. Viết trigger cho bảng NoiDungHopDong sao cho mỗi khi thực hiện thao tác bổ sung,
cập nhật, loại bỏ dữ liệu trên bảng này thì tự động tính lại cột TongTien trong bảng
HopDongVanChuyen
*/

if (
	exists (
		select *
		from sys.objects
		where name = 'trigger_NoiDungHopDong_Update'
	)
)
	drop trigger trigger_NoiDungHopDong_Update
go
create trigger trigger_NoiDungHopDong_Update ON NoiDungHopDong
for update 
as
	update HopDongVanChuyen
	set TongTien = (
		select sum(NoiDungHopDong.MucPhi)
		from NoiDungHopDong
		where NoiDungHopDong.MaSoHopDong = inserted.MaSoHopDong
		group by NoiDungHopDong.MaSoHopDong
	)
	from inserted join HopDongVanChuyen ON HopDongVanChuyen.MaSoHopDong = inserted.MaSoHopDong
go

update NoiDungHopDong
set MucPhi = 30000000
where MaHangHoa = 8 and MaSoHopDong = 1

select *
from HopDongVanChuyen

/*
cau 7: Tạo tài khoản có tên đăng nhập là dethi02_user, cấp phát quyền cho phép tài khoản
này được truy cập vào CSDL và có quyền sử dụng các khung nhìn, thủ tục và hàm đã tạo ở
trên.
*/

USE QLHHVT
GO
CREATE LOGIN dethi02_user WITH PASSWORD = '1'
GO

Use QLHHVT
GO
EXECUTE sp_addrolemember 'db_owner', 'dethi02_user';
GO

GRANT CREATE PROCEDURE, CREATE VIEW
TO dethi02_user

GRANT ALL ON  func_TongHopKhachHang
TO dethi02_user

GRANT ALL ON func_TongDoanhThuXe
TO dethi02_user