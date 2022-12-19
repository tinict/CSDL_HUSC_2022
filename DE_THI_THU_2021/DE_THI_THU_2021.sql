--Câu 1
--a
if(exists (
	select *
	from sys.objects
	where name = 'trg_Question_Insert'
))
	drop trigger trg_Question_Insert
go
create trigger trg_Question_Insert
on Question
for INSERT
as
	declare @UserName nvarchar(50) = (
		select ins.UserName
		from inserted as ins
	)
	Update UserAccount
	set NumOfQuestions = (
		select count(qs.QuestionId)
		from Question as qs
		where qs.UserName like '%' + @UserName + '%'
	)
	where UserName like '%' + @UserName + '%'
go
--Test
insert into Question(QuestionTitle, QuestionContent, UserName)
values ('W', 'wh', 'tinnguyen')

select *
from UserAccount

select *
from Question

--b
if(exists(select * from sys.objects where name = 'trg_Answer_Insert'))
	drop trigger trg_Answer_Insert
go
create trigger trg_Answer_Insert
on Answer
for insert
as
	begin
		declare @UserName nvarchar(50) = (
			select ins.UserName
			from inserted as ins
		)
		declare @QuestionId nvarchar(50) = (
			select ins.QuestionId
			from inserted as ins
		)
		Update UserAccount
		set NumOfAnswers = (
			select count(ans.AnswerId)
			from Answer as ans
			where UserName = @UserName
		)
		where UserName = @UserName

		Update Question
		set NumOfAnswers = (
			select count(asw.AnswerId)
			from Question as qs join Answer as asw on asw.QuestionId = qs.QuestionId
			where qs.QuestionId = 8
		)
		where QuestionId = @QuestionId
	end
go
--Test
insert into Answer(QuestionId, AswerContent, UserName)
values (8, N'Test cu an luon', 'thanhnhan')

select *
from UserAccount

select *
from Question as qs join Answer as asw on asw.QuestionId = qs.QuestionId

--Cau 2
--a
if (
	exists (
		select *
		from sys.objects
		where name  = 'proc_Question_Insert'
	)
)
	drop procedure proc_Question_Insert
go
create procedure proc_Question_Insert (
	@QuestionTitle nvarchar(255),
	@QuestionContent nvarchar(2000),
	@UserName nvarchar(50),
	@QuestionId int output
)
as
	begin
		set nocount on;
		if (@QuestionContent = '' or @QuestionTitle = '')
			begin
				set @QuestionId = -1
				return 0;
			end
		insert into Question (QuestionTitle, QuestionContent, UserName)
		values (@QuestionTitle, @QuestionContent, @UserName)
		set @QuestionId = @@IDENTITY
	end
go
--Test case
declare @QuestionId int
execute proc_Question_Insert
		@QuestionTitle = N'',
		@QuestionContent = 'Góp câu hỏi đi nào',
		@UserName = 'phuocle',
		@QuestionId = @QuestionId output
select @QuestionId
go

--b
if (
	exists (
		select *
		from sys.objects
		where name  = 'proc_UserAccount_Update'
	)
)
	drop procedure proc_UserAccount_Update
go
create procedure proc_UserAccount_Update (
	@UserName nvarchar(50),
	@FullName nvarchar(100),
	@Email nvarchar(50),
	@Result nvarchar(255) output
)
as
	begin
		set nocount on;
		--Nhập rỗng
		if (@UserName = N'')
			begin
				set @Result = N'UserName chưa nhập'
				return 0;
			end
		--Nhập rỗng
		if (@FullName = N'')
			begin
				set @Result = N'FullName chưa nhập'
				return 0;
			end
			--Kiểm tra Email không tồn tại
		--Chưa điền đầy đủ họ tên
		if (not exists (
			select *
			from UserAccount
			where UserName = @UserName
		))
			begin
				set @Result = N'User name này không tồn tại !'
				return 0;
			end
		--Chưa nhập Email
		if (@Email = '')
			begin
				set @Result = N'Email chưa nhập !'
				return 0;
			end
		--Email này đã được sử dụng
		if (exists (
			select *
			from UserAccount
			where Email = @Email
		))
			begin
				set @Result = N'Email đã tồn tại !'
				return 0;
			end
		-- Kiểm tra độ chính xác của Email khi nhập
		if ((select CHARINDEX('@gmail.com', @Email)) = 0)
			begin
				set @Result = N'Email này không chính xác'
				return 0;
			end
		update UserAccount
		set FullName = @FullName, 
			Email = @Email
		where UserName = @UserName
		set @Result = '';
	end
go
--Test case
declare @Result nvarchar(255)
execute proc_UserAccount_Update
		@UserName = tinnguyen,
		@FullName = N'',
		@Email = 'tinnguyen@gmail.com',
		@Result = @Result output
select @Result
go

--c
if (exists(select * from sys.objects where name = 'proc_Question_Select'))
	drop procedure proc_Question_Select
go
create procedure proc_Question_Select (
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
		from Question as qs
		where qs.QuestionContent like @SearchValue or 
			  qs.QuestionTitle like @SearchValue
	
		set @PageCount = @RowCount / @PageSize;
		if (@RowCount % @PageSize > 0)
			set @PageCount += 1;

		select *
		from (
				select *,
				row_number() over(order by qs.QuestionId) as RowNumber
				from Question as qs
				where qs.QuestionContent like @SearchValue or 
					  qs.QuestionTitle like @SearchValue
		) as p
		where p.RowNumber between (@Page - 1) * @PageSize + 1 and @Page * @PageSize
		order by p.RowNumber
	end
go
--Test case
declare @SearchValue nvarchar(255) = N'Cho em hỏi',
		@Page int = 1,
		@PageSize int = 20,
		@RowCount int,
		@PageCount int
execute proc_Question_Select
		@SearchValue = @SearchValue,
		@Page = @Page,
		@PageSize = @PageSize,
		@RowCount = @RowCount output,
		@PageCount = @PageCount output
select @RowCount as [RowCount], @PageCount as [PageCount];

select *
from Question

--d
if (
	exists(
		select *
		from sys.objects
		where name = 'proc_CountQuestionByYear'
	)
)
	drop procedure proc_CountQuestionByYear
go
create procedure proc_CountQuestionByYear (
	@FromYear int,
	@ToYear int
)
as
	begin
		set nocount on;
		declare @tbl_Year table (Year int)
		while(@FromYear <= @ToYear)
			begin
				insert into @tbl_Year(Year)
				values (@FromYear)
				set @FromYear = @FromYear + 1
			end
		select tblYear.Year, isnull(tblCount.NumOfQuestion + tblCount.NumOfAnswer, 0) as NumOfQAA
		from (
			select year(qs.AskedTime) as Year, count(qs.QuestionId) as NumOfQuestion, sum(qs.NumOfAnswers) as NumOfAnswer
			from Question as qs
			group by year(qs.AskedTime)
		) as tblCount right join @tbl_Year as tblYear on tblCount.Year = tblYear.Year
	end
go
--Test case
execute proc_CountQuestionByYear
		@FromYear = 2018,
		@ToYear = 2022

select * from Question

--Cau 3
--a
if (exists(
	select *
	from sys.objects
	where name = 'func_CountAnswers' 
))
	drop function func_CountAnswers
go
create function func_CountAnswers(
	@From date, 
	@To date
)
returns int
as
	begin
		declare @NumOfAnswer int = (
			select count(asw.AnswerId) as NumOfAnswer
			from Answer as asw
			where asw.AnsweredTime >= @From and asw.AnsweredTime <= @To
		)
		return @NumOfAnswer;
	end
go
--Test
select dbo.func_CountAnswers('2022-12-18', '2022-12-19')

select *
from Question

--b
if (exists(
	select *
	from sys.objects
	where name = 'func_CountQuestionByYear'
))
	drop function func_CountQuestionByYear
go
create function func_CountQuestionByYear (
	@FromYear int, 
	@ToYear int
)
returns @tbl_ThongKe table (Year int, CountOfQAA int)
as
	begin
		declare @tbl_Year table (Year int)
		while(@FromYear <= @ToYear)
			begin
				insert into @tbl_Year(Year)
				values (@FromYear)
				set @FromYear = @FromYear + 1
			end
		insert into @tbl_ThongKe(Year, CountOfQAA)
		select tblYear.Year, isnull(tblCount.NumOfQuestion + tblCount.NumOfAnswer, 0) as NumOfQAA
		from (
			select year(qs.AskedTime) as Year, count(qs.QuestionId) as NumOfQuestion, sum(qs.NumOfAnswers) as NumOfAnswer
			from Question as qs
			group by year(qs.AskedTime)
		) as tblCount right join @tbl_Year as tblYear on tblCount.Year = tblYear.Year
		return;
	end
go
--Test
select *
from dbo.func_CountQuestionByYear(2018,2022)