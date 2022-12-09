--a
if (
	exists (
		select *
		from sys.objects
		where name = 'proc_View_DSTaiSanKhoa'
	)
)
	drop procedure proc_View_DSTaiSanKhoa
go
create procedure proc_View_DSTaiSanKhoa (
	@TenTaiSan nvarchar(50)
)
as
	begin
		set nocount on;
		select t.MaKhoa, kh.TenKhoa, t.MaTaiSan, ts.TenTaiSan, t.SL, ts.TriGia
		from tbl_Khoa as kh 
			 join tbl_Thuoc as t on kh.MaKhoa = t.MaKhoa
			 join tbl_TaiSan as ts on ts.MaTaiSan = t.MaTaiSan
		where @TenTaiSan like N'' + '%' + ts.TenTaiSan + '%'
		order by kh.TenKhoa, ts.TenTaiSan DESC
	end
go
--Test case
declare @TenTaiSan nvarchar(50) = N'Máy vi tính'
execute proc_View_DSTaiSanKhoa
		@TenTaiSan = @TenTaiSan

--b
if (
	exists (
		select *
		from sys.objects
		where name  = 'proc_View_DS_Khoa_NULL_TaiSan'
	)
)
	drop procedure proc_View_DS_Khoa_NULL_TaiSan
go
create procedure proc_View_DS_Khoa_NULL_TaiSan
as
	begin
		set nocount on;
		select kh.*
		from tbl_Khoa as kh
			 left join tbl_Thuoc as t on kh.MaKhoa = t.MaKhoa
			 left join tbl_TaiSan as ts on ts.MaTaiSan =  t.MaTaiSan
		where t.MaKhoa is null
	end
go
--Test case 
execute proc_View_DS_Khoa_NULL_TaiSan

--c
if (
	exists (
		select *
		from sys.objects
		where name = 'func_SoLoaiTaiSan'
	)
)
	drop function func_SoLoaiTaiSan
go
create function func_SoLoaiTaiSan (
	@MaKhoa nvarchar(50)
)
returns @tbl_LoaiTaiSan table (MaTaiSan int, TenTaiSan nvarchar(50))
as
	begin
		insert into @tbl_LoaiTaiSan
		select ts.MaTaiSan, ts.TenTaiSan
		from tbl_Khoa as kh
			 left join tbl_Thuoc as t on kh.MaKhoa = t.MaKhoa
			 left join tbl_TaiSan as ts on ts.MaTaiSan =  t.MaTaiSan
		where kh.MaKhoa = @MaKhoa
		return;
	end
go
--Test
select *
from dbo.func_SoLoaiTaiSan(1)

--d
if (
	exists (
		select *
		from sys.objects
		where name = 'func_ThongKe_TaiSan'
	)
)
	drop function func_ThongKe_TaiSan
go
create function func_ThongKe_TaiSan()
returns @tbl_ThongKe table (TenKhoa nvarchar(50), SL_TaiSan int)
as
	begin
		insert into @tbl_ThongKe
		select kh.MaKhoa, count(ts.MaTaiSan) as SoLuong
		from tbl_Khoa as kh
			 left join tbl_Thuoc as t on kh.MaKhoa = t.MaKhoa
			 left join tbl_TaiSan as ts on ts.MaTaiSan =  t.MaTaiSan
		group by kh.MaKhoa
		return;
	end
go
--Test
select *
from func_ThongKe_TaiSan()

--e
if (
	exists (
		select *
		from sys.objects
		where name = 'proc_DS_Khoa_NhapTaiSan'
	)
)
	drop procedure proc_DS_Khoa_NhapTaiSan
go
create procedure proc_DS_Khoa_NhapTaiSan (
	@A date,
	@B date
)
as
	begin
		set nocount on;
		select *
		from tbl_Khoa as kh
			 join tbl_Thuoc as t on kh.MaKhoa = t.MaKhoa
			 join tbl_TaiSan as ts on ts.MaTaiSan =  t.MaTaiSan
		where @A <= t.NgayNhạp and @B >= t.NgayNhạp
	end
go
--Test case
declare @A date = '2008-01-01',
		@B date = '2009-01-01'
execute proc_DS_Khoa_NhapTaiSan
		@A = @A,
		@B = @B

--f
if (
	exists (
		select *
		from sys.objects
		where name  = 'proc_Ds_Max_Khoa'
	)
)
	drop procedure proc_Ds_Max_Khoa
go
create procedure proc_Ds_Max_Khoa
as
	begin
		set nocount on;
		select kh.TenKhoa
		from tbl_Khoa as kh join (
			select kh.TenKhoa,
					   rank() over (order by max(ts.TriGia) DESC) as Rank
			from tbl_Khoa as kh
				 left join tbl_Thuoc as t on kh.MaKhoa = t.MaKhoa
				 left join tbl_TaiSan as ts on ts.MaTaiSan =  t.MaTaiSan
			group by kh.TenKhoa
		) as tb_Rank on tb_Rank.TenKhoa = kh.TenKhoa
		where tb_Rank.Rank = 1
	end
go
--Test case
execute proc_Ds_Max_Khoa

--g
if (
	exists (
		select *
		from sys.objects
		where name = 'proc_Insert_Khoa'
	)
)
	drop procedure proc_Insert_Khoa
go
create procedure proc_Insert_Khoa (
	@MaKhoa int,
	@TenKhoa nvarchar(50),
	@SDT varchar(50),
	@Result nvarchar(50) output
)
as
	begin
		set nocount on;
		if (
			exists (
				select *
				from tbl_Khoa
				where tbl_Khoa.MaKhoa = @MaKhoa or tbl_Khoa.TenKhoa = @TenKhoa
			)
		)
			begin
				set @Result = N'Mã khoa hoặc tên khoa đã tồn tại!';
				return 0;
			end
		if(@MaKhoa = '' or @TenKhoa = '')
			begin
				set @Result = N'Mã khoa hoặc tên khoa đang bị trống';
				return 0;
			end
		insert into tbl_Khoa (MaKhoa, TenKhoa, SDT)
		values (@MaKhoa, @TenKhoa, @SDT)
		if (@@ROWCOUNT = 1)
			set @Result = '';
	end
go
--Test case
declare @MaKhoa int = 9,
		@TenKhoa nvarchar(50) = 'Leo cột điện',
		@SDT varchar(50) = '12345',
		@Result nvarchar(50)
execute proc_Insert_Khoa
		@MaKhoa = @MaKhoa,
		@TenKhoa = @TenKhoa,
		@SDT = @SDT,
		@Result = @Result output
select @Result
go

--h
create table _20T1020110_Khoa_TaiSan (makhoa int primary key, tenkhoa nvarchar(50), TongGiaTriTaiSan int)

if (
	exists (
		select *
		from sys.objects
		where name = 'trig_Insert_TaiSan'
	)
)
	drop trigger trg_Insert_TaiSan
go
create trigger trg_Insert_TaiSan
on tbl_TaiSan
for insert
as
	update _20T1020110_Khoa_TaiSan
	set _20T1020110_Khoa_TaiSan.TongGiaTriTaiSan = (
		select sum(ts.TriGia*t.SL) as TongTaiSanKhoa
		from tbl_Khoa as kh
			 join tbl_Thuoc as t on kh.MaKhoa = t.MaKhoa
			 join tbl_TaiSan as ts on ts.MaTaiSan =  t.MaTaiSan
		where kh.MaKhoa = _20T1020110_Khoa_TaiSan.makhoa
		group by kh.MaKhoa
	)
	from _20T1020110_Khoa_TaiSan
go