use fly1
go

declare @fname varchar(50)
declare @lname varchar(50)
declare @iata1 varchar(5)
declare @iata2 varchar(5)
declare @seatno int
declare @seat varchar(10)
declare @airline varchar(2)
declare @flight varchar(5)
declare @flightno int

select top 1 last_name into #templname from employee order by newid()
select @lname = (select last_name from #templname)
select top 1 first_name into #tempfname from employee order by newid()
select @fname = (select first_name from #tempfname)
select top 1 iata_code into #tempiata1 from airport order by newid()
select @iata1 = (select iata_code from #tempiata1)
select top 1 iata_code into #tempiata2 from airport order by newid()
select @iata2 = (select iata_code from #tempiata2)
select @seatno = ( select (convert(int, round(rand() * 60,2))))
select @seat = (select (cast(@seatno as varchar(10))) + 'F')
select @airline = ( select char((rand()*25 + 65))+char((rand()*25 + 65)) )
select @flightno = ( select (convert(int, round(rand() * 999,2))))
select @flight = (select @airline + "123")

insert into
reservation
(lname, fname, seatno, flightno, dep, arr, reservedate)
values
( @lname,
  @fname,
  @seat , 
  @flight,
  @iata1,
  @iata2,
  getdate()
)
go
select count(*) from reservation
go
