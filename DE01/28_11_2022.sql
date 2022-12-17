--C1
/*
a. Tạo một khung nhìn có tên là View_NhaCC_Vios để lấy được thông tin của tất cả nhà
cung cấp có đăng ký dịch vụ dùng dòng xe Vios từ ngày 01/01/2016 trở về sau.
*/
if (
	exists (
		select *
		from sys.objects
		where name = 'view_NhaCC_Vios'
	)
)
	drop view view_NhaCC_Vios
go
create view view_NhaCC_Vios 
as
	select ncc.*
	from DangKyCungCap as dkcc join NhaCungCap as ncc on ncc.MaNhaCC = dkcc.MaNhaCC
	where NgayBatDauCungCap >= '01/01/2016' and KyHieuDongXe like '%Vios%'
go

select *
from View_NhaCC_Vios

/*
b. Thông qua khung nhìn trên, cập nhật lại địa chỉ của các nhà cung cấp trong phạm vi của
khung nhìn thành ‘Toyota Huế’
*/
Update View_NhaCC_Vios
set DiaChi = N'Toyota Huế'

--C2
/*
a. proc_MucPhi_DeleteUnUsed: Dùng để xóa khỏi bảng MucPhi tất cả những mức phí
hiện không được sử dụng.
*/
if (
	exists (
		select *
		from sys.objects
		where name = 'proc_MucPhi_DeleteUnUsed'
	)
)
	drop procedure proc_MucPhi_DeleteUnUsed
go

create procedure proc_MucPhi_DeleteUnUsed
as
	begin
		set nocount on;
		DECLARE @DKCC_MaMP nvarchar(50)
		DECLARE @MP_MaMP nvarchar(50)

		DECLARE cursorMucPhi CURSOR FOR  
		SELECT dkcc.MaMP, mp.MaMP
		FROM MucPhi as mp left join DangKyCungCap as dkcc on dkcc.MaMP = mp.MaMP    

		OPEN cursorMucPhi               

		FETCH NEXT FROM cursorMucPhi     
			  INTO @DKCC_MaMP, @MP_MaMP

		WHILE @@FETCH_STATUS = 0          
		BEGIN

			if (@DKCC_MaMP IS NULL)
				begin
					delete MucPhi
					where MaMP = @MP_MaMP
				end

			FETCH NEXT FROM cursorMucPhi 
				  INTO @DKCC_MaMP, @MP_MaMP
		END

		CLOSE cursorMucPhi             
		DEALLOCATE cursorMucPhi 
	end
go      

/*
b. proc_DangKyCungCap_Insert: Dùng để bổ sung thêm 1 bản ghi mới vào bảng
DangKyCungCap. Thủ tục này phải kiểm tra được tính đúng đắn và toàn vẹn của dữ liệu
khi bổ sung.
*/
if (
	exists (
		select *
		from sys.objects
		where name = 'proc_DangKyCungCap_Insert'
	)
)
	drop procedure proc_DangKyCungCap_Insert
go
create procedure proc_DangKyCungCap_Insert (
	@MaDKCC nvarchar(250),
	@MaNhaCC nvarchar(50),
	@MaLoaiDV nvarchar(50),
	@KyHieuDongXe nvarchar(50),
	@MaMP nvarchar(50),
	@NgayBatDauCungCap date,
	@NgayKetThucCungCap date,
	@SoLuongXeDangKy int
)
as
	begin
		set nocount on;
		if (
			exists(
				select * 
				from DangKyCungCap as dkcc
				where dkcc.MaDKCC like '%' + @MaDKCC + '%'
			)
		)
			return 0;

		insert into DangKyCungCap (MaDKCC, MaNhaCC, MaLoaiDV, KyHieuDongXe, MaMP, NgayBatDauCungCap, NgayKetThucCungCap, SoLuongXeDangKy)
		values (@MaDKCC, @MaNhaCC, @MaLoaiDV, @KyHieuDongXe, @MaMP, @NgayBatDauCungCap, @NgayKetThucCungCap, @SoLuongXeDangKy)

	end
go

--C3
/*
Viết trg_DangKyCungCap_Update cho bảng DangKyCungCap để khi cập nhật
giá trị của cột NgayKetThucCungCap, cần kiểm tra xem thời gian cập nhật có phù hợp với
qui định hay không (biết rằng, qui định là mỗi một dịch vụ khi đăng ký phải hoạt động ít nhất
1 năm). Nếu dữ liệu không hợp lệ thì không cho phép cập nhật
*/
if (
	exists (
		select *
		from sys.objects
		where name = 'trg_DangKyCungCap_Update'
	)
)
	drop trigger trg_DangKyCungCap_Update
go
create trigger trg_DangKyCungCap_Update ON DangKyCungCap
for update
as
	declare @day int;
	select @day = DATEDIFF(DAY, dkcc.NgayBatDauCungCap, inserted.NgayKetThucCungCap)
	from inserted join DangKyCungCap as dkcc on inserted.MaDKCC = dkcc.MaDKCC
	where inserted.MaLoaiDV = dkcc.MaLoaiDV
	if (@day < 365)
		ROLLBACK TRANSACTION
go

--Test
update DangKyCungCap
set NgayKetThucCungCap = '2017-10-01'
where DangKyCungCap.MaLoaiDV = 'DV01' and DangKyCungCap.MaDKCC = 'D02'

select *
from DangKyCungCap

--Cau 4
/*
func_DemXeChoThue (@MucPhi): Đếm tổng số lượng xe đã được đăng ký cho thuê
với mức phí là @MucPhi VNĐ/km.
*/
if (
	exists (
		select *
		from sys.objects
		where name = 'func_DemXeChoThue'
	)
)
	drop function func_DemXeChoThue
go
create function func_DemXeChoThue(@MucPhi int)
returns int
as
	begin
		declare @count int;
		select @count = count(dkcc.MaDKCC)
		from DangKyCungCap as dkcc join MucPhi as mp on dkcc.MaMP = mp.MaMP
		where mp.DonGia = @MucPhi
		group by dkcc.MaDKCC
		return @count;
	end
go

/*
func_TimXe(@SoChoNgoi, @NgayCanThueXe): Để tìm kiếm thông tin về các nhà
cung cấp, loại xe và mức phí của những xe có số chỗ ngồi là @SoChoNgoi và có đăng ký
cung cấp dịch vụ vào thời điểm @NgayCanThueXe
*/
if (
	exists (
		select *
		from sys.objects
		where name = 'func_TimXe'
	)
)
	drop function func_TimXe
go
create function func_TimXe (
	@SoChoNgoi int,
	@NgayCanThueXe date
)
returns table
as
	return (
		select ncc.TenNhacc, ncc.DiaChi, ncc.SoDT, dkcc.KyHieuDongXe, mp.DonGia, dkcc.NgayBatDauCungCap, dkcc.NgayKetThucCungCap
		from DangKyCungCap as dkcc 
			 join NhaCungCap as ncc on ncc.MaNhaCC = dkcc.MaNhaCC
			 join MucPhi as mp on mp.MaMP = dkcc.MaMP
			 join DongXe as dx on dx.KyHieuDongXe = dkcc.KyHieuDongXe
		where dx.SoChoiNgoi = @SoChoNgoi and dkcc.NgayBatDauCungCap = @NgayCanThueXe 
	)
go

--Cau 5
/*
Tạo stored procedure proc_ThongKeXe @TuNgay, @DenNgay để thống kê xem
trong khoảng thời gian từ @TuNgay đến @DenNgay nhà cung cấp nào có số lượng xe đăng
ký cho thuê nhiều nhất.
*/
if (
	exists (
		select *
		from sys.objects
		where name = 'proc_ThongKeXe'
	)
)
	drop procedure proc_ThongKeXe
go
create procedure proc_ThongKeXe (
	@TuNgay date,
	@DenNgay date
)
as
	begin
		set nocount on;
		select tb_NCC.TenNhacc, tb_NCC.SoLuongXeDangKy
		from (
			select ncc.TenNhacc,
				   rank() over (order by sum(dkcc.SoLuongXeDangKy) DESC) as Rank,
				   sum(dkcc.SoLuongXeDangKy) as SoLuongXeDangKy
			from DangKyCungCap as dkcc join NhaCungCap as ncc on ncc.MaNhaCC = dkcc.MaNhaCC
			where dkcc.NgayBatDauCungCap <= CAST(@TuNgay AS Date) and dkcc.NgayKetThucCungCap >= CAST(@DenNgay AS Date)
			group by ncc.TenNhacc
		) as tb_NCC
		where tb_NCC.Rank = 1
	end
go


--Cau 6
/*
Tạo tài khoản có tên đăng nhập là dethi01_user, cấp phát quyền cho phép tài khoản
này được truy cập vào CSDL và có quyền sử dụng các khung nhìn, thủ tục và hàm đã tạo ở
trên.
*/
USE QL_DKPTCC
GO
CREATE LOGIN dethi01_user WITH PASSWORD = '1'
GO

Use QL_DKPTCC
Go
CREATE USER mytestdb_user FOR LOGIN dethi01_user;
GO

Use QL_DKPTCC
GO
EXECUTE sp_addrolemember 'db_owner', 'mytestdb_user';
GO

GRANT CREATE PROCEDURE, CREATE VIEW
TO mytestdb_user

GRANT EXECUTE
ON proc_ThongKeXe
TO mytestdb_user

GRANT EXECUTE
ON func_TimXe
TO mytestdb_user

GRANT EXECUTE
ON func_DemXeChoThue
TO mytestdb_user

GRANT EXECUTE
ON proc_MucPhi_DeleteUnUsed
TO mytestdb_user

GRANT EXECUTE
ON proc_DangKyCungCap_Insert
TO mytestdb_user

GRANT EXECUTE
ON view_NhaCC_Vios
TO mytestdb_user



