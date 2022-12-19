--Cau 1
--a
if (
	exists (
		select *
		from sys.objects
		where name = 'proc_AssignTaskToEmployee'
	)
)
	drop procedure proc_AssignTaskToEmployee
go
create procedure proc_AssignTaskToEmployee (
	@TaskId int,
	@EmployeeId int,
	@AssignedDate date,
	@Result nvarchar(255) output
)
as
	begin
		set nocount on;
		if (
			not exists(
				select *
				from Tasks
				where TaskId = @TaskId
			)
		)
			begin
				set @Result = N'Không tồn tại nhiệm vụ này !'
				return 0;
			end
		if (
			not exists(
				select *
				from Employees
				where EmployeeId = @EmployeeId
			)
		)
			begin
				set @Result = N'Không tồn tại người này !'
				return 0;
			end
		if (@AssignedDate = '')
			begin
				set @Result = N'Vui lòng nhập ngày giao bài tập'
				return 0;
			end
		insert into TaskAssignments (TaskId, EmployeeId, AssignedDate)
		values (@TaskId, @EmployeeId, @AssignedDate)
		set @Result = ''
	end
go
--Test case
declare @Result nvarchar(255)
execute proc_AssignTaskToEmployee
		@TaskId = 1,
		@EmployeeId = 6,
		@AssignedDate = '2022-12-17',
		@Result = @Result output
select @Result
go

--b
if(
	exists(
		select *
		from sys.objects
		where name  = 'proc_UpdateFinishTask'
	)
)
	drop procedure proc_UpdateFinishTask
go
create procedure proc_UpdateFinishTask (
	@TaskId int,
	@EmployeeId int,
	@FinishedDate date,
	@Result nvarchar(255) output
)
as
	begin
		set nocount on;
		if (
			not exists(
				select *
				from Tasks
				where TaskId = @TaskId
			)
		)
			begin
				set @Result = N'Không tồn tại nhiệm vụ này !'
				return 0;
			end
		if (
			not exists(
				select *
				from Employees
				where EmployeeId = @EmployeeId
			)
		)
			begin
				set @Result = N'Không tồn tại người này !'
				return 0;
			end
		update TaskAssignments
		set FinishedDate = @FinishedDate
		where TaskId = @TaskId and EmployeeId = @EmployeeId
		set @Result = ''
	end
go
--Test case
declare @Result nvarchar(255)
execute proc_UpdateFinishTask
		@TaskId = 1,
		@EmployeeId = 6,
		@FinishedDate = '2022-12-30',
		@Result = @Result output
select @Result
go

select *
from TaskAssignments

--c
if(
	exists (
		select *
		from sys.objects
		where name = 'proc_ListEmployees'
	)
)
	drop procedure proc_ListEmployees
go
create procedure proc_ListEmployees (
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
		from Employees as emp
		where emp.FirstName like @SearchValue or 
			  emp.LastName like @SearchValue
	
		set @PageCount = @RowCount / @PageSize;
		if (@RowCount % @PageSize > 0)
			set @PageCount += 1;

		select *
		from (
				select *,
				row_number() over(order by emp.EmployeeId) as RowNumber
				from Employees as emp
				where emp.FirstName like @SearchValue or 
					  emp.LastName like @SearchValue
		) as p
		where p.RowNumber between (@Page - 1) * @PageSize + 1 and @Page * @PageSize
		order by p.RowNumber
	end
go
--Test case
declare @SearchValue nvarchar(255) = N'Tín',
		@Page int = 1,
		@PageSize int = 20,
		@RowCount int,
		@PageCount int
execute proc_ListEmployees
		@SearchValue = @SearchValue,
		@Page = @Page,
		@PageSize = @PageSize,
		@RowCount = @RowCount output,
		@PageCount = @PageCount output
select @RowCount as [RowCount], @PageCount as [PageCount];
--d
if(
	exists(
		select *
		from sys.objects
		where name = 'proc_SummaryFinishedTaskByDate'
	)
)
	drop procedure proc_SummaryFinishedTaskByDate
go
create procedure  proc_SummaryFinishedTaskByDate (
	@FromDate date,
	@ToDate date
)
as
	begin
		set nocount on;
		declare @tbl_Date table (DateFinished date)
		while(@FromDate <= @ToDate)
			begin
				insert into @tbl_Date(DateFinished)
				values (@FromDate)
				set @FromDate = dateadd(day,1,@FromDate)
			end
		select tblDate.DateFinished, isnull(tbl_Count.NumOfTask, 0)
		from (
			select ta.FinishedDate as DateFinished, count(ta.TaskId) as NumOfTask
			from TaskAssignments as ta
			group by ta.FinishedDate
			having ta.FinishedDate is not null
		) as tbl_Count right join @tbl_Date as tblDate on tbl_Count.DateFinished = tblDate.DateFinished
	end
go
--Test case
execute proc_SummaryFinishedTaskByDate
		@FromDate = '2022-01-01',
		@ToDate = '2022-12-31'
go
--Câu 2
--a
if(
	exists(
		select *
		from sys.objects
		where name = 'trg_TaskAssignments_Insert'
	)
)
	drop trigger trg_TaskAssignments_Insert
go
create trigger trg_TaskAssignments_Insert
on TaskAssignments 
for insert
as
	begin
		declare @TaskId int = (
			select ins.TaskId
			from inserted as ins
		)
		update Tasks
		set CountOfAssigned = (
			select count(ta.EmployeeId)
			from TaskAssignments as ta
			where ta.TaskId = @TaskId
			group by ta.TaskId
		)
		where TaskId = @TaskId
	end
go
--Test
insert TaskAssignments(TaskId, EmployeeId, AssignedDate)
values (4, 2, '2022-12-31')
select *
from Tasks

--b
if(
	exists(
		select *
		from sys.objects
		where name = 'trg_TaskAssignments_Update '
	)
)
	drop trigger trg_TaskAssignments_Update 
go
create trigger trg_TaskAssignments_Update 
on TaskAssignments 
for update
as
	begin
		declare @TaskId int = (
			select ins.TaskId
			from inserted as ins
		)
		update Tasks
		set CountOfFinished = (
			select count(ta.EmployeeId)
			from TaskAssignments as ta
			where ta.TaskId = @TaskId and ta.FinishedDate is not null
			group by ta.TaskId
		)
		where TaskId = @TaskId
	end
go
--Test
update TaskAssignments
set FinishedDate = '2023-01-06'
where TaskId = 4 and EmployeeId = 2
select *
from Tasks

--Câu 3
--a
if (
	exists(
		select *
		from sys.objects
		where name = 'func_CountUnfinishedTasks'
	)
)
	drop function func_CountUnfinishedTasks
go
create function func_CountUnfinishedTasks(@EmployeeId int)
returns int
as
	begin
		declare @NumOfEmployees int = (
			select count(ta.TaskId) as NumOfEmployee
			from TaskAssignments as ta
			where ta.FinishedDate is null and ta.EmployeeId = @EmployeeId
		)
		return @NumOfEmployees;
	end
go

--Test
select dbo.func_CountUnfinishedTasks(1)

--b
if (
	exists(
		select *
		from sys.objects
		where name = 'func_SummaryFinishedTasksByDate'
	)
)
	drop function func_SummaryFinishedTasksByDate
go
create function func_SummaryFinishedTasksByDate(@FromDate date, @ToDate date)
returns @tbl_ThongKe table(DateFinished date, NumOfTaskComplete int)
as
	begin
		declare @tbl_Date table (DateFinished date)
		while(@FromDate <= @ToDate)
			begin
				insert into @tbl_Date(DateFinished)
				values (@FromDate)
				set @FromDate = dateadd(day,1,@FromDate)
			end
		insert into @tbl_ThongKe (DateFinished, NumOfTaskComplete)
		select tblDate.DateFinished, isnull(tbl_Count.NumOfTask, 0)
		from (
			select ta.FinishedDate as DateFinished, count(ta.TaskId) as NumOfTask
			from TaskAssignments as ta
			group by ta.FinishedDate
			having ta.FinishedDate is not null
		) as tbl_Count right join @tbl_Date as tblDate on tbl_Count.DateFinished = tblDate.DateFinished
		return;
	end
go
--Test
select *
from dbo.func_SummaryFinishedTasksByDate('2022-01-01', '2022-12-31')