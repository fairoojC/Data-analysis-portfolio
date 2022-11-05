
-- Basic queries

select * from sales;

select saledate, amount, customer from sales;

Select Amount, customers,Geoid from sales;

Select saledate, amount, boxes, (amount / boxes) from sales;

Select saledate, amount, boxes, (amount / boxes) as 'Amount per box' from sales;

Select distinct p.salesperson, count(*) as `SALES per seller`
from sales as S
join people P on s.spid = p.spid
group by p.salesperson
order by `sales per seller` desc;

select * from sales
where amount>10000;

select * from sales
where amount>10000 order by amount asc;

Select * from sales 
where Geoid= 'G1'
order by PID, Amount desc;

Select * from sales 
Where amount> 10000 and saledate >= '2022-01-01';

Select saledate, amount from sales
where amount> 10000 and year(saledate) = 2022
order by amount desc;

Select * from sales
where boxes >0 and boxes <=50;

Select * from sales
where boxes between 0 and 50;

Select Saledate, amount, boxes, weekday(saledate) as 'Day of week'
from sales
where weekday(Saledate) =4;

Select * from people;

Select * from sales;

-- SQL Joins

Select s.saledate, s.amount, p.salesperson, s.spid, p.spid
From sales as S
Join people p on p.spid = s.spid;

Select s.saledate, s.amount, s.spid, pr.product
from sales s
left join products pr on pr.pid = s.pid;

Select s.saledate, s.amount, p.salesperson, pr.product, p.team
From sales as S
Join people p on p.spid = s.spid
join products pr on pr.pid = s.pid
Where s.amount<500
and p.team = 'Delish';

Select s.saledate, s.amount, p.salesperson, pr.product, p.team
From sales as S
Join people p on p.spid = s.spid
join products pr on pr.pid = s.pid
Where s.amount<500
and p.team = '';

-- IN and Like clauses


Select s.saledate, s.amount, p.salesperson, pr.product, p.team
From sales as S
Join people p on p.spid = s.spid
join products pr on pr.pid = s.pid
join geo g on g.geoid = s.geoid
Where s.amount<500
and p.team = ''
and g.geo in ('New zealand', 'India')
order by saledate;


Select * from People 
Where team = 'Delish' OR team='Jucies';


Select * from people
Where salesperson like 'B%';

Select * from People
Where salesperson like '%B%';

-- Case operators

Select Saledate, Amount,
	case	 when amount< 1000 then 'Under 1k'
			When amount< 5000 then 'Under 5K'
            When amount< 10000 then 'Under 10k'
		else '10k or more'
	end as 'Amount catagory'
From sales;

-- Groups

Select geoid, sum(amount), avg(amount), sum(boxes)
from sales
group by geoid;

Select g.geo, sum(amount), avg(amount), sum(boxes)
from sales s 
join geo g on s.geoid = g.geoid
group by g.geo;

-- Joins and groups

Select pr.category, p.team, sum(boxes), sum(amount)
From sales s
join people p on p.spid = s.spid
join products pr on pr.pid = s.pid
where p.team <> ''
group by pr.category, p.team
order by pr.category, p.team;

-- General Calculations

Select pr.product, sum(s.amount) as 'Total Amount'
from sales s 
join products pr on pr.pid = s.pid
group by pr.product
order by `Total Amount` DESC
Limit 10;

select p.salesperson, count(*) as `sold times`
from sales s
join people p on s.spid = p.spid
where s.boxes<> 0
group by p.salesperson
order by `sold times` desc;

select p.salesperson, AVG(s.amount)
from sales s
join people p on s.spid = p.spid
where s.boxes<> 0
group by p.salesperson
order by avg(s.amount) desc;

select p.salesperson, AVG(s.amount)
from sales s
join people p on s.spid = p.spid
group by p.salesperson
having avg(s.amount)>2500
order by avg(s.amount) desc
;

-- More basic queries

select * from products;

Select * from sales 
where amount >2000 and boxes<100;

Select p.salesperson, count(*) as `sipment count`
from sales as S
join people P on s.spid = p.spid
where saledate between '2022-1-01' and '2022-1-31'
group by p.salesperson;

Select pr.product, sum(boxes) as 'total sold'
from sales S
join products Pr on s.pid = pr.pid
where pr.product in ('milk bars', 'eclairs')
group by pr.product;

Select pr.product, sum(boxes) as '7 day sales'
from sales S
join products pr on s.pid = pr.pid
where pr.product in ('Milk bars', 'Eclairs') and S.saledate between '2022-2-1' and '2022-2-7'
Group by pr.product;

select * from sales;

--  Which shipments had under 100 customers & under 100 boxes? Did any of them occur on Wednesday

Select *,
case when weekday(saledate)=2 then 'wednesday shipping'
else 'not wednesday'
end as 'W shipment'
from sales 
where customers<100 and boxes<100; 

--  What are the names of salespersons who had at least one shipment (sale) in the first 7 days of January 2022?

Select distinct p.salesperson
from sales S
join people P on p.spid = s.spid
where s.saledate between '2022-1-1' and '2022-1-7';

--  Which salespersons did not make any shipments in the first 7 days of January 2022?

Select distinct p.salesperson
from Sales S
Join people P where p.spid not in
(select distinct s.spid from sales s where s.saledate between '2022-1-1' and '2022-1-7');

-- How many times we shipped more than 1,000 boxes in each month?

Select year(saledate) 'year', month(saledate) 'month', count(*) 'How many times we shipped 1k boxes'
from sales
where boxes>1000
group by year(saledate), month(saledate)
order by year(saledate), month(saledate);

--  Did we ship at least one box of ‘After Nines’ to ‘New Zealand’ on all the months?

Set @product_name = 'After Nines';
Set @country_name = 'New Zealand';

Select Year(s.saledate) 'year', Month(s.saledate) 'month',
if(sum(s.boxes)>1, 'yes','No') 'status' 
from sales s
join products pr on pr.pid = s.pid
join Geo G on G.geoid = S.geoid
where pr.product = @product_name and G.geo= @country_name
group by year(saledate), month(saledate)
order by year(saledate), month(saledate);

--  India or Australia? Who buys more chocolate boxes on a monthly basis?

select year(saledate) 'year', month(saledate) 'month',
sum(case when g.geo='india' = 1 then boxes else 0 end) 'india boxes',
sum(CASE WHEN g.geo= 'Australia' = 1  THEN boxes ELSE 0 END) 'Australia Boxes'
from sales s
join geo g on g.geoid = s.geoid
group by year(saledate), month(saledate);


-- Print details of shipments (sales) where amounts are > 2,000 and boxes are <100? 

Select * from sales 
Where Amount>2000 and boxes< 100;

-- How many shipments (sales) each of the sales persons had in the month of January 2022?

Select p.salesperson, count(*) as `shipment count`
from sales as S
join People P on s.spid = P.spid
where saledate between '2022-1-01' and '2022-1-31'
group by p.salesperson;


-- Which product sells more boxes? Milk Bars or Eclairs?

Select pr.product, Sum(boxes) as 'Total Sold'
from Sales S
join Products Pr on S.pid = pr.pid
where pr.product  in ('Milk bars', 'Eclairs')
group by Pr.product;

-- Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs?

Select pr.product, sum(boxes) as 'Total 7 day sales'
from Sales S
join Products Pr on s.pid =pr.pid
where pr.product in ('milk bars', 'eclairs') and s.saledate between '2022-2-01' and '2022-2-07'
group by pr.product;

-- Which shipments had under 100 customers & under 100 boxes? Did any of them occur on Wednesday

Select *, 
Case when weekday(saledate) =2 then 'Shipping on Wednesday'
else 'Not wednesday'
end 'Wednesday shipping'
from sales S
join products Pr on s.pid =pr.pid
where s.customers<100 and s.boxes<100;

Select distinct p.salesperson
from sales s
join people p on s.spid = p.spid
where s.saledate between '2022-1-1' and '2022-1-7';

-- Which salespersons did not make any shipments in the first 7 days of January 2022?

Select distinct p.salesperson
from sales s
join people p where p.spid not in
(select distinct s.spid from sales s where s.saledate between '2022-1-1' and '2022-1-7');

--  How many times we shipped more than 1,000 boxes in each month?

Select year(saledate) 'year', month(saledate) 'month', count(*) as 'How many times more than 1k boxes were shipped'
from sales
where boxes>1000
group by year(saledate), month(saledate)
order by year(saledate), month(saledate);


-- UK or Australia? Who buys more chocolate boxes on a monthly basis?

Select year(saledate) 'year', month(saledate) 'month',
sum(case when g.geo='UK' = 1 then boxes else 0 end) 'UK boxes',
Sum(case when g.geo='Australia' = 1 then boxes else 0 end) 'AUS boxes'
from sales s
join geo g on g.geoid = s.geoid
group by year(saledate), month(saledate)
order by year(saledate), month(saledate);

-- What was the most sold chocolate box in 2021

Select pr.product, sum(boxes) 'total sold'
from sales s
join products pr on pr.pid =s.pid
where s.saledate between '2022-1-1' and '2022-12-31'
group by pr.product
order by pr.product Desc;

-- which sales person sold the most in feb 2022 and what was their highest sale?

Select p.salesperson, count(*) `total feb sales`
from sales as s
join people p on p.spid = s.spid
where saledate between '2022-2-1' and '2022-2-28'
group by p.salesperson
order by `total feb sales` desc;

-- which product sold the most boxes in feb?

Select  pr.product, sum(boxes) `Total feb sales`
from sales as s
join products pr on pr.pid = s.pid
where saledate between '2022-2-1' and '2022-2-28'
group by pr.product
order by `total feb sales` desc;

-- which sales person sold the most manuka honey choco

Select p.salesperson, count(*) `total feb sales`
from sales as s
join people p on p.spid = s.spid
join products pr on pr.pid = s.pid
where pr.product = 'manuka honey choco' and saledate between '2022-2-1' and '2022-2-28' 
group by p.salesperson
order by `total feb sales` DESC;

select * from sales;

-- what is van Tuxwell most sold product?

Select pr.product, sum(s.boxes) 'total sold'
from sales as s
join people p on p.spid = s.spid
join products pr on pr.pid = s.pid
where p.salesperson = 'van Tuxwell' and saledate between '2022-2-1' and '2022-2-28' 
group by pr.product
order by 'total sold' DESC;

-- Wilone O'kielt most popular product in feburary


Select pr.product, sum(s.boxes) as `total sold`
from sales as s
join people p on p.spid = s.spid
join products pr on pr.pid = s.pid
where p.salesperson = "Wilone o'kielt" and saledate between '2022-2-1' and '2022-2-28' 
group by pr.product
order by `total sold` DESC;
