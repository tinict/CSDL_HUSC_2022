--Cau 2
--a
if (exists(select * from sys.objects where name ='trg_Registration_Insert'))
	drop trigger trg_Registration_Insert
go
create trigger trg_Registration_Insert
on Registration
for insert
as
	begin
		declare @CertificateId int = (
			select ins.CertificateId
			from inserted as ins
		)
		update Certificate
		set NumberOfRegister = (
			select count(res.ExamineeId)
			from Certificate as c join Registration as res on c.CertificateId = res.CertificateId
			where c.CertificateId = @CertificateId
			group by res.CertificateId
		)
		where Certificate.CertificateId = @CertificateId
	end
go
--Test
insert into Registration (ExamineeId, CertificateId)
values (1,6)

select *
from Certificate

--b
if (exists(select * from sys.objects where name ='trg_Registration_Update'))
	drop trigger trg_Registration_Update
go
create trigger trg_Registration_Update
on Registration
for update
as
	begin
		declare @CertificateId int = (
			select ins.CertificateId
			from inserted as ins
		)
		update Certificate
		set NumberOffPass = (
			select count(res.ExamineeId)
			from Examinee as ex join Registration as res on ex.ExamineeId = res.ExamineeId
			where res.ExamResult >= 5 and
				  res.CertificateId = @CertificateId
			group by res.CertificateId
		)
		where Certificate.CertificateId = @CertificateId
	end
go

--Test
update Registration
set ExamResult = 10
where Registration.CertificateId = 1 and Registration.ExamineeId = 1

select *
from Certificate

--cau 3
--a
if (
	exists (
		select *
		from sys.objects
		where name  = 'proc_Registration_Add'
	)
)
	drop procedure proc_Registration_Add
go
create procedure proc_Registration_Add (
	@ExamineeId int,
	@CertificateId int,
	@Result nvarchar(255) output
)
as
	begin
		set nocount on;
		if (not exists (
			select *
			from Examinee as ex
			where ex.ExamineeId = @ExamineeId
		))
			begin
				set @Result = N'Id không tông tại trong Examinee';
				return 0;
			end
		if (not exists (
			select *
			from Certificate as cf
			where cf.CertificateId = @CertificateId
		)) 
			begin
				set @Result = N'Id không tông tại trong Certificate';
				return 0;
			end
		insert into Registration(ExamineeId, CertificateId)
		values  (@ExamineeId, @CertificateId)
		set @Result = '';
	end
go

--Test case
declare @ExamineeId int = 1,
		@CertificateId int = 2,
		@Result nvarchar(255)
execute proc_Registration_Add
		@ExamineeId = @ExamineeId,
		@CertificateId = @CertificateId,
		@Result = @Result output
select @Result

--b
if (
	exists (
		select *
		from sys.objects
		where name = 'proc_SaveExamResult'
	)
)
	drop procedure proc_SaveExamResult
go
create procedure proc_SaveExamResult (
	@ExamineeId int,
	@CertificateId int,
	@ExamResult int,
	@Result nvarchar(255) output
)
as
	begin
		set nocount on;
		if (not exists (
			select *
			from Examinee as ex
			where ex.ExamineeId = @ExamineeId
		))
			begin
				set @Result = N'Id không tông tại trong Examinee';
				return 0;
			end
		if (not exists (
			select *
			from Certificate as cf
			where cf.CertificateId = @CertificateId
		)) 
			begin
				set @Result = N'Id không tông tại trong Certificate';
				return 0;
			end
		update Registration
		set ExamResult = @ExamResult
		where ExamineeId = @ExamineeId and CertificateId = @CertificateId
		set @Result = '';
	end
go

--Test case
declare @ExamineeId int = 2,
		@CertificateId int = 2,
		@ExamResult int = 9,
		@Result nvarchar(255)
execute proc_SaveExamResult
		@ExamineeId = @ExamineeId,
		@CertificateId = @CertificateId,
		@ExamResult = @ExamResult,
		@Result = @Result output
select @Result

--c
if (
	exists (
		select *
		from sys.objects
		where name = 'proc_Examinee_Select'
	)
)
	drop procedure proc_Examinee_Select
go
create procedure proc_Examinee_Select (
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
		from Examinee as ex
		where (ex.FirstName + ' '+ ex.LastName) like @SearchValue;
	
		set @PageCount = @RowCount / @PageSize;
		if (@RowCount % @PageSize > 0)
			set @PageCount += 1;

		select    *
		from    (
					select *,
						   row_number() over(order by (FirstName + ' ' + LastName)) as RowNumber
					from Examinee
					where (FirstName + ' ' +  LastName) like N'' +  '%' + @searchValue + '%'
				) as p
		where    p.RowNumber between (@Page - 1) * @PageSize + 1 and @Page * @PageSize
		order by p.RowNumber
	end
go

--Test case
declare @SearchValue nvarchar(255) = N'Nguyễn Văn A',
		@Page int = 1,
		@PageSize int = 20,
		@RowCount int,
		@PageCount int
execute proc_Examinee_Select
		@SearchValue = @SearchValue,
		@Page = @Page,
		@PageSize = @PageSize,
		@RowCount = @RowCount output,
		@PageCount = @PageCount output
select @RowCount as [RowCount], @PageCount as [PageCount];

--d
if (
	exists (
		select *
		from sys.objects
		where name = 'proc_CountRegisteringByDate'
	)
)
	drop procedure proc_CountRegisteringByDate
go
create procedure proc_CountRegisteringByDate (
	@From date,
	@To date
)
as
	begin
		set nocount on;
		declare @tbl_Date table(RegisterTime date)
		while (@From <= @To)
			begin
				insert into @tbl_Date(RegisterTime)
				values (@From)
				set @From = DATEADD(day, 1, @From)
			end
		select tbl_Date.RegisterTime, ISNULL(tbl_Count.CountExaminee, 0) as SoLuong
		from (
			select Registration.RegisterTime, count(Registration.ExamineeId) as CountExaminee
			from Registration
			group by Registration.RegisterTime
		) as tbl_Count right join @tbl_Date as tbl_Date on tbl_Count.RegisterTime = tbl_Date.RegisterTime
	end
go
--Test case 
declare @From date = '2020-01-01',
		@To date = '2022-12-17'
execute proc_CountRegisteringByDate
		@From = @From,
		@To = @To

--CÂU 4
--a
if (
	exists (
		select *
		from sys.objects
		where name  = 'func_CountPassed'
	)
)
	drop function func_CountPassed
go
create function func_CountPassed (
	@ExamineeId int
)
returns int
as
	begin
		declare @Result int = 0;
		select @Result  = count(ex.ExamineeId)
		from Examinee as ex join Registration as r on ex.ExamineeId = r.ExamineeId
		where ex.ExamineeId = @ExamineeId and r.ExamResult > 5
		group by ex.ExamineeId
		return @Result
	end
go

--Test case
select dbo.func_CountPassed(9)

--b
if (exists(select * from sys.objects where name = 'func_TotalByDate'))
	drop function func_TotalByDate;
go
create function func_TotalByDate(@From date, @To date)
returns @tbl_ThongKe table(RegisterTime date, CountRes int)
as
	begin
		declare @tbl_Date table(RegisterTime date)
		while (@From <= @To)
			begin
				insert into @tbl_Date(RegisterTime)
				values (@From)
				set @From = DATEADD(day, 1, @From)
			end
		insert into @tbl_ThongKe(RegisterTime, CountRes)
		select tbl_Date.RegisterTime, ISNULL(tbl_Count.CountExaminee, 0) as SoLuong
		from (
			select Registration.RegisterTime, count(Registration.ExamineeId) as CountExaminee
			from Registration
			group by Registration.RegisterTime
		) as tbl_Count right join @tbl_Date as tbl_Date on tbl_Count.RegisterTime = tbl_Date.RegisterTime
		return;
	end
go
--Test
select *
from dbo.func_TotalByDate('2020-01-01', '2022-12-17')

--CÂU 5

--1
--Cách 1: Tạo tài khoản có tên normal_test_user trên master
USE master
GO
CREATE LOGIN normal_test_user WITH PASSWORD = '1'

--Cách 2: Tạo tài khoản có tên normal_test_user trên [20T1020110]
USE [20T1020110]
GO
CREATE LOGIN normal_test_user WITH PASSWORD = '1'

--Cấp quyền sử dụng cơ sở dữ liệu có tên [20T1020110] đã tạo trên
-- Tạo user: mytestdb_test_user sử dụng cho [20T1020110] trên tài khoản normal_test_user
Use [20T1020110]
Go
CREATE USER mytestdb_test_user FOR LOGIN normal_test_user;
GO

--Nếu tạo tài khoản trên [20T1020110] không tạo trên master thì ko dùng đoạn code bên dưới 
Use [20T1020110]
GO
EXECUTE sp_addrolemember 'db_accessadmin', 'mytestdb_2_user';
GO

--Có thể select trên bảng cetificate
GRANT SELECT
ON Certificate
TO mytestdb_test_user
GO

--Cấp quyền cho function nếu là scalar-function thì dùng execute
grant execute on func_ChanLe to mytestdb_test_user
go

--Câp quyền cho function nếu là table-funtion thì dùng select
grant select on func_tbl to mytestdb_test_user
go

--Cấp quyền ghi dữ liệu
Use [20T1020110]
GO
EXECUTE sp_addrolemember 'db_datawriter', 'mytestdb_test_user';
GO

--Cấp quyền đọc dữ liệu
Use [20T1020110]
GO
EXECUTE sp_addrolemember 'db_datareader', 'mytestdb_test_user';
GO

--Câp quyền sở hữu dữ liệu
Use [20T1020110]
GO
EXECUTE sp_addrolemember 'db_owner', 'mytestdb_test_user';
GO

--Cấp quyền tạo bảng
grant create table
to mytestdb_test_user

--Cấp quyền tạo function
grant create function
to mytestdb_test_user

--Cấp quyền tạo procedure
grant create procedure
to mytestdb_test_user

