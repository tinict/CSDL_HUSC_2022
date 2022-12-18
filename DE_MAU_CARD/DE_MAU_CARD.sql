--Cau 2:
--Bổ sung Quantity
alter table CardStore
add Quantity int

select *
from CardStore

if(exists(select * from sys.objects where name = 'trg_Invoice_Insert'))
	drop trigger trg_Invoice_Insert
go
create trigger trg_Invoice_Insert
on Invoice
for insert
as
	begin
		declare @CardTypeId bigint = (
			select cds.CardTypeId
			from inserted as ins join CardStore as cds on ins.InvoiceId = cds.InvoiceId
		)
		declare @Amount money = (
			select cds.Amount
			from inserted as ins join CardStore as cds on ins.InvoiceId = cds.InvoiceId
		)
		update CardStore
		set Quantity = (
			select count(cs.CardId)
			from CardStore as cs
			where cs.CardTypeId = @CardTypeId and cs.Amount = @Amount
			group by cs.InvoiceId
			having cs.InvoiceId is null
		)
		where CardTypeId = @CardTypeId and Amount = @Amount
	end
go

--Câu 3:
if(exists(select * from sys.objects where name = 'proc_Customer_Register'))
	drop procedure proc_Customer_Register
go
create procedure proc_Customer_Register (
		@CustomerName nvarchar(100),
		@Email nvarchar(100),
		@Password nvarchar(100),
		@MobiNumber nvarchar(50),
		@CustomerId int OUTPUT
)
as
	begin
		set nocount on;
		if(exists(select * from Customer where Email = @Email) or 
		   (select CHARINDEX('@gmail.com', @Email)) = 0)
			begin
				set @CustomerId = -1;
				return 0;
			end
		if(@Password = '')
			begin
				set @CustomerId = -2
				return 0;
			end
		if(@CustomerName = '')
			begin
				set @CustomerName = -3
				return 0;
			end
		if((select ISNUMERIC(@MobiNumber)) = 0 or 
			LEN(@MobiNumber) != 10 or 
			@MobiNumber = '' or 
			exists(select * from Customer where MobiNumber = @MobiNumber))
			begin
				set @CustomerId = -4
				return 0;
			end

		insert into Customer(CustomerName, Email, Password, MobiNumber)
		values (@CustomerName, @Email, @Password, @MobiNumber)
		set @CustomerId = @@IDENTITY;
	end
go

--Test case
declare @CustomerName nvarchar(100) = 'Nguyễn Văn B',
		@Email nvarchar(100) = 'vb@gmail.com',
		@Password nvarchar(100) = '123',
		@MobiNumber nvarchar(50) = '0905467930',
		@CustomerId int
execute proc_Customer_Register
		@CustomerName = @CustomerName,
		@Email = @Email,
		@Password = @Password,
		@MobiNumber = @MobiNumber,
		@CustomerId = @CustomerId output
select @CustomerId
go

--b
if(exists(select * from sys.objects where name = 'proc_Insert_CardType'))
	drop procedure proc_Insert_CardType
go
create procedure proc_Insert_CardType (
	@CardTypeId int,
	@CardTypeName nvarchar(50),
	@Description nvarchar(255),
	@Result nvarchar(255) output
)
as
	begin
		set nocount on;
		if(exists (select * from CardType where CardTypeName = @CardTypeName))			begin				set @Result = N'Thẻ này đã tồn tại!'				return 0;			end		if(@Description = '')			begin				set @Result = N'Bạn chưa mô tả loại thẻ';				return 0;			end		insert into CardType(CardTypeName, Description)		values(@CardTypeName, @Description)		set @CardTypeId = @@IDENTITY		set @Result = '';
	end
go
--Test case
declare @CardTypeId int,
		@CardTypeName nvarchar(50) = 'VNAM',
		@Description nvarchar(255) = 'Thẻ VietNamMobile',
		@Result nvarchar(255)
execute proc_Insert_CardType
		@CardTypeId = @CardTypeId,
		@CardTypeName = @CardTypeName,
		@Description = @Description,
		@Result = @Result output
select @Result

--c
if(exists(select * from sys.objects where name = 'proc_Invoice_Select'))
	drop procedure proc_Invoice_Select
go
create procedure proc_Invoice_Select (
	@CustomerId int,
	@From date,
	@To date,
	@Page int,
	@PageSize int,
	@RowCount int OUTPUT,
	@PageCount int OUTPUT
)
as
	begin
		set nocount on;
		if (@Page <= 0) set @Page = 1;
		if (@PageSize <= 0) set @PageSize = 20;

		select @RowCount = count(*)
		from Invoice as inv
		where @From <= inv.CreatedTime and @To >= inv.CreatedTime and CustomerId = @CustomerId
			
	
		set @PageCount = @RowCount / @PageSize;
		if (@RowCount % @PageSize > 0)
			set @PageCount += 1;

		select *
		from (
				select *,
					   row_number() over(order by inv.CustomerId) as RowNumber
				from Invoice as inv
				where @From <= inv.CreatedTime and @To >= inv.CreatedTime and CustomerId = @CustomerId
			) as p
		where p.RowNumber between (@Page - 1) * @PageSize + 1 and @Page * @PageSize
		order by p.RowNumber
	end
go
--Test case
declare @CustomerId int = 2,
		@From date = '2020-11-11',
		@To date = '2023-01-01',
		@Page int = 1,
		@PageSize int = 20,
		@RowCount int,
		@PageCount int
execute proc_Invoice_Select
		@CustomerId = @CustomerId,
		@From = @From,
		@To = @To,
		@Page = @Page,
		@PageSize = @PageSize,
		@RowCount = @RowCount output,
		@PageCount = @PageCount output
select @RowCount as [RowCount], @PageCount as [PageCount];

--d
if(exists (select * from sys.objects where name = 'proc_CountRegisteringByDate'))
	drop procedure proc_CountRegisteringByDate
go
create procedure proc_CountRegisteringByDate (
	@From date,
	@To date 
)
as
	begin
		set nocount on;
		declare @tbl_Date table (RegisterTime date)
		while(@From <= @To)
			begin
				insert into @tbl_Date(RegisterTime)
				values (@From)
				set @From = dateadd(day,1,@From);
			end
		select tblDate.RegisterTime, isnull(tbl_Count.NumOfRegister, 0) as NumOfRegister
		from (
			select convert(date,c.RegisterTime) as RegisterTime , count(c.CustomerId) as NumOfRegister
			from Customer as c
			group by convert(date,c.RegisterTime)
		) as tbl_Count right join @tbl_Date as tblDate on tbl_Count.RegisterTime = tblDate.RegisterTime
	end
go
--Test case
execute proc_CountRegisteringByDate
		@From = '2020-11-01',
		@To = '2022-12-18'

--Cau 4
--a
if(exists(select * from sys.objects where name = 'func_GetInventories'))
	drop function func_GetInventories
go
create function func_GetInventories (
	@CardTypeId int, 
	@Amount money
)
returns int 
as
	begin
		declare @NumOfCard int;
		select @NumOfCard = count(cs.CardId)
		from CardStore as cs
		where cs.CardTypeId = @CardTypeId and cs.Amount = @Amount
		group by cs.InvoiceId
		having cs.InvoiceId is null
		return @NumOfCard
	end
go
--Test case
select dbo.func_GetInventories(3, 20000)  

--b
if(exists(select * from sys.objects where name = 'func_GetRevenueByDate'))
	drop function func_GetRevenueByDate
go
create function func_GetRevenueByDate (
	@CardTypeId int,
	@From date, 
	@To date
)
returns @tbl_ThongKe table (day date, TotalCard money)
as
	begin
		declare @tbl_Date table (day date)
		while(@From <= @To)
			begin
				insert into @tbl_Date(day)
				values (@From)
				set @From = dateadd(day,1,@From);
			end
		insert into @tbl_ThongKe(day, TotalCard)
		select tblDate.day, isnull(tblTotal.TotalCard,0)
		from (
			select convert(date,inv.CreatedTime) as day, sum(cs.Amount) as TotalCard
			from CardStore as cs join Invoice as inv on cs.InvoiceId = inv.InvoiceId
			where cs.CardTypeId = @CardTypeId
			group by convert(date,inv.CreatedTime)
		) as tblTotal right join @tbl_Date as tblDate on tblTotal.day = tblDate.day
		return;
	end
go
--Test
select *
from dbo.func_GetRevenueByDate(3, '2021-09-28', '2022-10-09')

select *
from CardStore as cs join Invoice as inv on cs.InvoiceId = inv.InvoiceId

--Cau 5
USE THI_20T1020110
GO
CREATE LOGIN THI_20T1020110_user WITH PASSWORD = '1'

Use THI_20T1020110
Go
CREATE USER THI_20T1020110_test_user FOR LOGIN THI_20T1020110_user;
GO

Use THI_20T1020110
GO
EXECUTE sp_addrolemember 'db_accessadmin', 'THI_20T1020110_test_user';
GO

GRANT SELECT
ON CardType
TO THI_20T1020110_test_user
GO

grant select 
on func_GetRevenueByDate 
to THI_20T1020110_test_user
go

grant execute
on proc_CountRegisteringByDate
to THI_20T1020110_test_user
go

grant execute
on func_GetInventories
to THI_20T1020110_test_user
go

grant execute
on proc_CountRegisteringByDate
to THI_20T1020110_test_user
go

grant execute
on proc_Invoice_Select
to THI_20T1020110_test_user
go

grant execute
on proc_Insert _CardType
to THI_20T1020110_test_user
go

grant execute
on proc_Customer_Register
to THI_20T1020110_test_user
go