--1. Thống kê xem mỗi một loại hàng có bao nhiêu mặt hàng

select c.CategoryId, c.CategoryName, count(p.ProductId) as SoLuong
from Categories as c join Products as p on c.CategoryId = p.CategoryId
group by c.CategoryName, c.CategoryId

--2. Thống kê xem mỗi một khách hàng đã đặt bao nhiêu đơn đặt hàng.

select ct.CustomerId, ct.CustomerName, count(od.OrderId) as SoLuongDonHang
from Customers as ct join Orders as od on ct.CustomerId = od.CustomerId
group by ct.CustomerName, ct.CustomerId

--3. Thống kê số lượng đơn hàng mà mỗi shipper đã vận chuyển.

select sp.ShipperId, sp.ShipperName, count(od.OrderId) as SoLuongDonVanChuyen
from Shippers as sp join Orders as od on sp.ShipperId = od.ShipperId
group by sp.ShipperId, sp.ShipperName

--4. Thống kê số lượng nhà cung cấp theo từng quốc gia.

select spl.Country, count(spl.SupplierId) as SoLuongNhaCungCap
from Suppliers as spl
group by spl.Country

--5. Thống kê số lượng khách hàng theo từng quốc gia.

select c.Country, count(c.CustomerId) as SoLuongKhachHang
from Customers as c
group by c.Country

--6. Thống kê tổng số lượng đơn hàng theo từng quốc gia của khách hàng.

select c.Country, count(od.OrderId) as SoDonHang
from Customers as c join Orders as od on od.CustomerId = c.CustomerId
group by c.Country

--7. Thống kê xem trong quý 4 năm 2017, mỗi nhân viên đã lập được bao nhiêu đơn đặt hàng.

select ep.EmployeeId, (ep.FirstName + ' ' + ep.LastName) as FullName, count(od.OrderId) as SoLuongDonHang
from Employees as ep join Orders as od on ep.EmployeeId = od.EmployeeId
where MONTH(od.OrderDate) >= 10 and MONTH(od.OrderDate) <= 12 and YEAR(od.OrderDate) = 2017
group by ep.EmployeeId, (ep.FirstName + ' ' + ep.LastName)

--8. Hãy cho biết trong thời gian từ tháng 6 đến tháng 12 năm 2017, mỗi một shipper đã nhận vận chuyển bao nhiêu đơn hàng.

select sp.ShipperId, sp.ShipperName, count(od.OrderId) as SoLuongDonHang
from Shippers as sp join Orders as od on sp.ShipperId = od.ShipperId
where MONTH(od.OrderDate) >= 6 and MONTH(od.OrderDate) <= 12 and YEAR(od.OrderDate) = 2017
group by sp.ShipperId, sp.ShipperName

--9. Thống kê số lượng đơn hàng trong năm 2017 của các 
--	khách hàng ở Mỹ (USA), Anh (UK), Đức (Germany) và Pháp (France).

select c.CustomerId, c.CustomerName, count(od.OrderId) as SoLuongDonHang
from Customers as c join Orders as od on od.CustomerId = c.CustomerId
where c.Country like N'%UK%' or c.Country like N'%USA%' or c.Country like N'%Germany%' or c.Country like N'%France%'
group by c.CustomerId, c.CustomerName

--10. Số tiền mà khách hàng phải thanh toán cho mỗi mặt hàng trong đơn hàng được tính theo công thức:
--		Quantity * SalePrice
--    Hãy hiển thị các thông tin sau đây của các đơn hàng được đặt trong năm 2017: 
--		Mã đơn hàng, ngày đặt hàng, thông tin của nhân viên lập đơn hàng, 
--		thông tin của khách hàng, thông tin của shipper 
--		và tổng số tiền hàng mà khách hàng phải thanh toán (tức là trị giá của đơn hàng).

select od.OrderId, od.OrderDate, ep.*, c.*, sp.*, tbl_ThanhToan.SoTienThanhToan
from Customers as c 
	 join Orders as od on c.CustomerId = od.CustomerId
	 join Shippers as sp on sp.ShipperId = od.ShipperId
	 join Employees as ep on ep.EmployeeId = od.EmployeeId
	 join (
		select od.OrderId, sum(odd.Quantity * odd.SalePrice) as SoTienThanhToan
		from Orders as od 
			 join OrderDetails as odd on od.OrderId = odd.OrderId
		group by od.OrderId
	 ) as tbl_ThanhToan on tbl_ThanhToan.OrderId = od.OrderId
where YEAR(od.OrderDate) = 2017

--11. Thống kê tổng số lượng (được bán) và tổng doanh thu của mỗi mặt hàng trong năm 2017.

select p.ProductId, p.ProductName, sum(odd.Quantity) as Quantity, sum(odd.SalePrice * odd.Quantity) as DoanhThu
from Products as p join OrderDetails odd on odd.ProductId = p.ProductId
group by p.ProductName, p.ProductId

--12. Hãy cho biết mỗi một quốc gia có bao nhiêu nhà cung cấp, bao nhiêu khách hàng 
--    (kết quả hiển thị bao gồm 3 cột: Country, CountOfSuppliers, CountOfCustomers).

select tbl_Customer.Country, isnull(tbl_Supplier.SoLuongSupperliers, 0) as CountOfSuppliers, 
	   isnull(tbl_Customer.SoLuongCustomer, 0) as CountOfCustomers
from (
	select c.Country, count(c.CustomerId) as SoLuongCustomer
	from Customers as c
	group by c.Country
) as tbl_Customer left join (
	select sp.Country, count(sp.SupplierId) as SoLuongSupperliers
	from Suppliers as sp
	group by sp.Country
) as tbl_Supplier on tbl_Supplier.Country = tbl_Customer.Country

--13. Cho biết mã đơn hàng, ngày đặt hàng và thông tin khách hàng của những đơn hàng có tổng trị giá lớn hơn 1000$.

select od.OrderId, od.OrderDate, c.*, tbl_ThanhToan.SoTienThanhToan
from Orders as od 
	 join Customers as c on od.CustomerId = c.CustomerId
	 join (
		select od.OrderId, sum(odd.Quantity * odd.SalePrice) as SoTienThanhToan
		from Orders as od 
			 join OrderDetails as odd on od.OrderId = odd.OrderId
		group by od.OrderId
	 ) as tbl_ThanhToan on tbl_ThanhToan.OrderId = od.OrderId
where tbl_ThanhToan.SoTienThanhToan > 1000

--14. Những nhân viên nào có số lượng đơn hàng lập trong tháng 8 năm 2017 lớn 5

select ep.EmployeeId, (ep.FirstName + ' ' + ep.LastName) as FullName, COUNT(od.OrderId) as SoLuong
from Employees as ep join Orders as od on ep.EmployeeId = od.EmployeeId
where MONTH(od.OrderDate) = 8 and YEAR(od.OrderDate) = 2017
group by ep.EmployeeId, ep.FirstName + ' ' + ep.LastName
having COUNT(od.OrderId) > 5

--15. Giả sử, mức phí vận chuyển mà công ty phải chi trả cho các shipper trên mỗi đơn hàng được qui định như sau:
--	- Các đơn hàng của khách hàng tại USA và Canada: mức phí vận chuyển là 3% trị giá của đơn hàng.
--	- Các đơn hàng của khách hàng tại Argentina, Brazil, Mexico và Venezuela: mức phí vận chuyển là 5% trị giá của đơn hàng.
--	- Các đơn hàng của khách hàng ở các quốc gia khác: mức phí vận chuyển là 7% trị giá của đơn hàng.
--   Hãy cho biết mã đơn hàng, ngày đặt hàng, thông tin khách hàng, thông tin shipper, trị giá của đơn hàng và mức phí vận chuyển của mỗi đơn hàng. 

if (
	exists (
		select *
		from sys.objects
		where name = func_MucPhiVanChuyen
	)
)
	drop function MucPhiVanChuyen
go
create function MucPhiVanChuyen (
	@Country nvarchar(50)
)
returns money
as
	return (
		select sum(odd.Quantity * odd.SalePrice) * 3%
		from Orders as od
			 join OrderDetails as odd on od.OrderId = odd.OrderId
			 join Customers as c on c.CustomerId = od.CustomerId
		where c.Country = @Country
		group by odd.OrderId
	)
go

select od.OrderId, od.OrderDate, c.*, sp.*, tbl_ThanhToan.SoTienThanhToan,
case
			when c.Country like N'%USA%' then tbl_ThanhToan.SoTienThanhToan * 3%
			when c.Country like N'%Argentina%' or
				 c.Country like N'%Brazil%' or
				 c.Country like N'%Mexico%' or
				 c.Country like N'%Venezuela%' then tbl_ThanhToan.SoTienThanhToan * 5%
end as MucPhiVanChuyen
from Shippers as sp 
	 join Orders as od on sp.ShipperId = od.ShipperId
	 join Customers as c on c.CustomerId = od.CustomerId
	 join (
		select od.OrderId, sum(odd.Quantity * odd.SalePrice) as SoTienThanhToan
		from Orders as od 
			 join OrderDetails as odd on od.OrderId = odd.OrderId
		group by od.OrderId
	 ) as tbl_ThanhToan on tbl_ThanhToan.OrderId = od.OrderId

--16. Dựa vào cách tính như đã qui định ở trên, hãy cho biết tổng số tiền mà công ty phải chi trả cho mỗi shipper là bao nhiêu.
--17. Cho biết mã, tên, địa chỉ và số lượng mặt hàng của những nhà cung cấp có số lượng mặt hàng cung cấp cho công ty nhiều nhất.

select *
from (
	select spl.SupplierId, spl.SupplierName, spl.Address, count(p.ProductId) as SoLuongMatHang,
	   rank() over (order by count(p.ProductId) DESC) as Rank
	from Suppliers as spl join Products as p on spl.SupplierId = p.SupplierId
	group by spl.SupplierId, spl.SupplierName, spl.Address 
) as tbl_Rank
where tbl_Rank.Rank = 1

--18. Trong năm 2017, những mặt hàng nào có tổng doanh thu cao nhất? Doanh thu là bao nhiêu?

select *
from (
	select p.ProductId, p.ProductName, sum(odd.Quantity * odd.SalePrice) as DoanhThu,
		   rank() over (order by sum(odd.Quantity * odd.SalePrice) DESC) as Rank
	from Products as p 
		 join OrderDetails as odd on p.ProductId = odd.ProductId
	group by p.ProductId, p.ProductName
) as tbl_Rank
where tbl_Rank.Rank = 1

--19. Trong năm 2018, những nhân viên nào đem lại doanh thu cao nhất cho công ty? Là bao nhiêu? 
--    (doanh thu mà mỗi nhân viên đem lại cho công ty được tính dựa trên tổng giá trị các đơn hàng mà nhân viên đó phụ trách)

select *
from (
	select ep.EmployeeId, (ep.FirstName + ' ' + ep.LastName) as FullName, od.OrderId
	from Employees as ep join Orders as od on od.EmployeeId = ep.EmployeeId
) as tbl_Employ join (
	select p.ProductId, p.ProductName, odd.OrderId,sum(odd.Quantity * odd.SalePrice) as DoanhThu,
		   rank() over (order by sum(odd.Quantity * odd.SalePrice) DESC) as Rank
	from Products as p 
		 join OrderDetails as odd on p.ProductId = odd.ProductId
	group by p.ProductId, p.ProductName, odd.OrderId
) as tbl_Rank on tbl_Employ.OrderId = tbl_Rank.OrderId
where tbl_Rank.Rank = 1

--20. Hãy lập bảng thống kê doanh thu của mỗi mặt hàng trong năm 2017, kết quả truy vấn được hiển thị theo mẫu sau đây:

if (
	exists (
		select *
		from sys.objects
		where name = 'func_Result_NameMonth'
	)
)
	drop function func_Result_NameMonth
go
create function func_Result_NameMonth (
	@Month int
)
returns nvarchar(50)
as
	begin
		declare @Name_Month nvarchar(50);
		if (@Month = 1)
			set @Name_Month = 'Jan';
		else if (@Month = 2)
			set @Name_Month = 'Feb';
		else if (@Month = 3)
			set @Name_Month = 'Mar';
		else if (@Month = 4)
			set @Name_Month = 'Apr';
		else if (@Month = 5)
			set @Name_Month = 'May';
		else if (@Month = 6)
			set @Name_Month = 'Jun';
		else if (@Month = 7)
			set @Name_Month = 'Jul';
		else if (@Month = 8)
			set @Name_Month = 'Aug';
		else if (@Month = 9)
			set @Name_Month = 'Sep';
		else if (@Month = 10)
			set @Name_Month = 'Oct';
		else if (@Month = 11)
			set @Name_Month = 'Nov';
		else if (@Month = 12)
			set @Name_Month = 'Dec';
		return @Name_Month;
	end
go

declare @tbl_Month table (
		Month int primary key, 
		NameMonth nvarchar(50)
)
declare @index int = 1;
while (@index <= 12)
	begin
		insert into @tbl_Month(Month, NameMonth)
		values (@index, (select dbo.func_Result_NameMonth(@index)))
		set @index = @index + 1
	end
select * from @tbl_Month

if (
	exists (
		select *
		from sys.objects
		where name  = 'proc_ThongKe_DoanhThu_MatHang_2017'
	)
)
	drop procedure proc_ThongKe_DoanhThu_MatHang_2017
go
create procedure proc_ThongKe_DoanhThu_MatHang_2017
as
	begin
		set nocount on;
		select p.ProductId, p.ProductName, sum(od.Quantity*od.SalePrice) as DoanhThu
		from Products as p 
			 join OrderDetails as od on p.ProductId = od.ProductId
			 join Orders as o on o.OrderId = od.OrderId
		where YEAR(o.OrderDate) = 2017
		group by p.ProductId, p.ProductName

		if(
			exists (
					select *
					from sys.objects
					where name  = '#tbl_Temporary_ThongKeDoanhThu'
			)
		)
			drop table #tbl_Temporary_ThongKeDoanhThu

		create table #tbl_Temporary_ThongKeDoanhThu (
			ProductId int primary key,
			ProductName nvarchar(50)
		)


		declare @index int = 1;
		while (@index <= 12)
			begin
				alter table #tbl_Temporary_ThongKeDoanhThu
				add a nvarchar(50)
			end
		select *
		from #tbl_Temporary_ThongKeDoanhThu
	end
go

select [Beverages]
from Categories