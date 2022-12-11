--câu 2:
if (
	exists (
		select *
		from sys.objects
		where name = 'proc_HienThiSinhVien'
	)
)
	drop procedure proc_HienThiSinhVien
go
create procedure proc_HienThiSinhVien (
	@Lop nvarchar(50),
	@Khoa nvarchar(50)
)
as
	begin
		set nocount on;
		select *
		from Khoa as k 
			 join Lop as l on k.MaKhoa = l.MaKhoa
			 join SinhVien as sv on sv.MaLop = l.MaLop
		 where k.TenKhoa like '%' + @Khoa + '%'
	end
go

--Test case
declare @Lop nvarchar(50) = N'Tin K41A',
		@Khoa nvarchar(50) = N'Khoa Công nghệ thông tin'
execute proc_HienThiSinhVien
		@Lop = @Lop,
		@Khoa = @Khoa

--b
if (
	exists (
		select *
		from sys.objects
		where name = ' proc_Insert_Khoa'
	)
)
	drop procedure  proc_Insert_Khoa
go
create procedure proc_Insert_Khoa (
	@MaKhoa nvarchar(50),
	@TenKhoa nvarchar(50),
	@Email nvarchar(50),
	@SDT nvarchar(50),
	@Result nvarchar(255) output
)
as
	begin
		set nocount on;
		if (
			exists (
				select *
				from Khoa
				where Khoa.MaKhoa = @MaKhoa or 
					  Khoa.TenKhoa = @TenKhoa
			)
		)
			begin
				set @Result = N'Mã khoa hoặc tên khoa đã tồn tại!'
				return 0;
			end
		insert into Khoa (MaKhoa, TenKhoa, Email, DienThoai)
		values (@MaKhoa, @TenKhoa, @Email, @SDT)
		if (@@ROWCOUNT = 1)
			set @Result = '';
	end
go
--Test case 
declare @MaKhoa nvarchar(50) = 301000,
		@TenKhoa nvarchar(50),
		@Email nvarchar(50),
		@SDT nvarchar(50),
		@Result nvarchar(255)
execute proc_Insert_Khoa
		@MaKhoa = @MaKhoa,
		@TenKhoa = @TenKhoa,
		@Email = @Email,
		@SDT = @SDT,
		@Result = @Result output
select @Result
go

--c
if (
	exists (
		select *
		from sys.objects
		where name = 'proc_TimKiem_SinhVien'
	)
)
	drop procedure proc_TimKiem_SinhVien
go
create procedure proc_TimKiem_SinhVien (
	@SearchValue nvarchar(255) = N'',
	@Page int = 1,
	@PageSize int = 20,
	@RowCount int output,
	@PageCount int output
)
as
	begin
		set nocount on;
		if (@Page <= 0) set @Page = 1;
		if (@PageSize <= 0) set @PageSize = 20;
		if (@SearchValue <> N'') set @SearchValue = '%' + @SearchValue + '%';

		select @RowCount = count(*)
		from SinhVien as sv
		where sv.HoTen like @SearchValue
	
		set @PageCount = @RowCount / @PageSize;
		if (@RowCount % @PageSize > 0)
			set @PageCount += 1;

		select    *
		from    (
					select *,
						   row_number() over(order by sv.MaSinhVien) as RowNumber
					from SinhVien as sv
					where sv.HoTen like '%' + @searchValue + '%'
				) as p
		where    p.RowNumber between (@Page - 1) * @PageSize + 1 and @Page * @PageSize
		order by p.RowNumber
	end
go

--Test case
declare @SearchValue nvarchar(255) = N'Nguyễn',
		@Page int = 1,
		@PageSize int = 20,
		@RowCount int,
		@PageCount int
execute proc_TimKiem_SinhVien
		@SearchValue = @SearchValue,
		@Page = @Page,
		@PageSize = @PageSize,
		@RowCount = @RowCount output,
		@PageCount = @PageCount output
select @RowCount as [RowCount], @PageCount as [PageCount];

--d

--Câu 3
--a
if (
	exists(
		select *
		from sys.objects
		where name  = 'func_DS_SVLonNhat'
	)
)
	drop function func_DS_SVLonNhat
go
create function func_DS_SVLonNhat ()
returns @tbl_Max table (MaLop nvarchar(50), TenLop nvarchar(50), SoLuongSinhVien int)
as
	begin
		insert into @tbl_Max (MaLop, TenLop, SoLuongSinhVien)
		select tbl_Rank.MaLop, tbl_Rank.TenLop, tbl_Rank.SoLuong
		from (
			select sv.MaLop, l.TenLop, count(sv.MaSinhVien) as SoLuong,
			   rank() over (order by count(sv.MaSinhVien) DESC) as Rank
			from SinhVien as sv join Lop as l on sv.MaLop = l.MaLop
			group by sv.MaLop, l.TenLop
		) as tbl_Rank
		where tbl_Rank.Rank = 1
		return;
	end
go
--Test
select *
from dbo.func_DS_SVLonNhat()

--b
if (
	exists (
		select *
		from sys.objects
		where name = 'func_ThongKe'
	)
)
	drop function func_ThongKe
go
create function func_ThongKe (
	@Tu int,
	@Den int
)
returns @tbl_Show table (Nam int, SoLuong int)
as
	begin
		declare @TuNam int = @Tu
		declare @DenNam int = @Den
		declare @tbl_Nam table (Nam int primary key)
		while (@TuNam <= @DenNam)
			begin
				insert into @tbl_Nam (Nam)
				values (@TuNam)
				set @TuNam = @TuNam + 1
			end
		
		insert into @tbl_Show (Nam, SoLuong)
		select tbl_NamNhapHoc.Nam, isnull(tbl_SinhVien.SoLuongSinhVien, 0) as SoLuong
		from @tbl_Nam as tbl_NamNhapHoc left join (
			select l.NamNhapHoc, count(sv.MaSinhVien) as SoLuongSinhVien
			from SinhVien as sv join Lop as l on sv.MaLop = l.MaLop
			group by l.NamNhapHoc
		) as tbl_SinhVien on tbl_SinhVien.NamNhapHoc = tbl_NamNhapHoc.Nam
		return;
	end
go

--Test 
select *
from dbo.func_ThongKe(2015,2017)

--Câu 4
--Thêm cột vào bản 
alter table Lop
add SiSo int 

--Cập nhật sỉ số trong lớp
if (
	exists (
		select *
		from sys.objects
		where name = 'proc_Update_SiSo_Lop'
	)
)
	drop procedure proc_Update_SiSo_Lop
go
create procedure proc_Update_SiSo_Lop
as
	begin
		set nocount on;
		DECLARE @MaLop nvarchar(50)
		DECLARE @SiSo nvarchar(50)

		DECLARE cursorLop CURSOR FOR  
		SELECT l.MaLop, l.SiSo
		FROM Lop as l

		OPEN cursorLop
		FETCH NEXT FROM cursorLop    
		INTO @MaLop, @SiSo

		WHILE @@FETCH_STATUS = 0          
			BEGIN
				update Lop
				set SiSo = isnull((
					select count(sv.MaSinhVien) as SiSo
					from SinhVien as sv join Lop as l on sv.MaLop = l.MaLop
					where sv.MaLop = @MaLop
					group by l.MaLop
				),0)
				where MaLop = @MaLop

				FETCH NEXT FROM cursorLop 
				INTO @MaLop, @SiSo
			END

		CLOSE cursorLop             
		DEALLOCATE cursorLop 
	end
go
--Test case
execute proc_Update_SiSo_Lop
select *
from Lop
go

--Trigger
if (
	exists (
		select *
		from sys.objects
		where name = 'trg_Lop_Update'
	)
)
	drop trigger trg_Lop_Update
go
create trigger trg_Lop_Update
on Lop
for Delete
as
	execute proc_Update_SiSo_Lop
go

--Cau 5
USE [20T1020110_QLSinhVien]
GO
CREATE LOGIN _20T1020110_user WITH PASSWORD = '123456'
GO

Use [20T1020110_QLSinhVien]
Go
CREATE USER mytestdb_user FOR LOGIN _20T1020110_user;
GO

Use [20T1020110_QLSinhVien]
GO
EXECUTE sp_addrolemember 'db_owner', 'mytestdb_user';
GO

GRANT SELECT 
ON Lop
TO mytestdb_user

GRANT CREATE PROCEDURE
TO mytestdb_user

GRANT EXECUTE
ON proc_HienThiSinhVien
TO mytestdb_user

GRANT EXECUTE
ON proc_Insert_Khoa
TO mytestdb_user

GRANT EXECUTE
ON proc_TimKiem_SinhVien
TO mytestdb_user

GRANT EXECUTE
ON func_DS_SVLonNhat
TO mytestdb_user