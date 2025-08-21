use coffee_sales;

describe coffee_sales;

#Disable Safe Mode:
SET sql_safe_updates = 0;

#Updating transaction_date and transaction_time into date and time format respetively:
UPDATE coffee_sales
set transaction_date = str_to_date(transaction_date, '%d-%m-%Y');

alter table coffee_sales
modify column transaction_date DATE;

UPDATE coffee_sales
set transaction_time = str_to_date(transaction_time, '%H:%i:%s');

alter table coffee_sales
modify column transaction_time time;

#Adding new column "Sales":
ALTER TABLE coffee_sales 
ADD COLUMN Sales DECIMAL(10, 2) AS (unit_price * transaction_qty);

#Checking:
desc coffee_sales;

#Total Sales Analyis:
select round(sum(transaction_qty *unit_price),2) as Total_Sales from coffee_sales
where month(transaction_date) = 5;

#Finding Month to Month Sales Increase or Decrease:
select month(transaction_date) as Months,
sum(sales) as total_sale,
concat(Round((sum(sales) - lag(sum(sales),1)
over(order by month(transaction_date))) / lag(sum(sales),1)
over(order by month(transaction_date)) * 100,2),'%') as mom_percentage
from coffee_sales
where month(transaction_date) in(2,3) 

group by month(transaction_date)
order by month(transaction_date);

#Each Month Sales:
select monthname(transaction_date) as Months,
sum(sales) as Total_sale 
from coffee_Sales
group by Months
order by Months;

#Finding Difference in Sales B/W Selected Months:
select month(transaction_date) as Months,
sum(sales) as total_sale,
round(sum(sales) - lag(sum(sales),1)
over(order by month(transaction_date)),2) as Diff_in_Sales
from coffee_sales
where month(transaction_date) in(2,3) 

group by month(transaction_date)
order by month(transaction_date);

#COMPARING DAILY SALES WITH AVERAGE SALES – IF GREATER THAN “ABOVE AVERAGE” and LESSER THAN “BELOW AVERAGE”:
SELECT day_of_month,
CASE 
WHEN total_sales > avg_sales THEN 'Above Average'
WHEN total_sales < avg_sales THEN 'Below Average'
ELSE 'Average'
END AS sales_status,
total_sales
FROM (
SELECT 
DAY(transaction_date) AS day_of_month,
ROUND(SUM(unit_price * transaction_qty),2) AS total_sales,
AVG(SUM(unit_price * transaction_qty)) OVER () AS avg_sales
FROM 
coffee_sales
WHERE 
MONTH(transaction_date) = 5  -- Filter for May
GROUP BY 
DAY(transaction_date)) AS sales_data
ORDER BY day_of_month;

#Total Order Analysis#

#Total no. of Orders in each Months:
select monthname(transaction_date) as Months,
count(transaction_id) as Total_Orders 
from coffee_Sales
group by Months
order by Months;

#Orders from each store_location:
select store_location,count(transaction_id) as Total_Orders  from coffee_sales
group by store_location
order by Total_Orders;

#Total Orders, Qty & Sales  store_location:
select store_location,
sum(transaction_qty) as Total_Qty,
count(transaction_id) as Total_Orders,
round(sum(sales),2) as Total_Sales 
from coffee_sales
group by store_location
order by Total_Qty ;

#Month on Month increase or decrease in no. of orders:
select Month(transaction_date) as months,
count(transaction_id) as Orders,
concat(Round(((count(transaction_id) - lag(count(transaction_id),1)
over(order by Month(transaction_date))) / lag(count(transaction_id),1)
over(order by month(transaction_date)))*100 , 2),'%') as mom_percentage
from coffee_sales
where Month(transaction_date) in (2,3)
group by months
order by months;

#Finding Difference in Orders B/W Selected Months:
select month(transaction_date) as Months,
count(transaction_id) as total_Order,
round(count(transaction_id) - lag(count(transaction_id),1)
over(order by month(transaction_date)),2) as Diff_in_Order
from coffee_sales
where month(transaction_date) in(2,3) 

group by month(transaction_date)
order by month(transaction_date);

#COMPARING DAILY ORDER WITH AVERAGE ORDER – IF GREATER THAN “ABOVE AVERAGE” and LESSER THAN “BELOW AVERAGE”
SELECT day_of_month,
CASE 
WHEN total_order > avg_order THEN 'Above Average'
WHEN total_order < avg_order THEN 'Below Average'
ELSE 'Average'
END AS order_status,
total_order
FROM (
SELECT 
DAY(transaction_date) AS day_of_month,
count(transaction_id) AS total_order,
AVG(count(transaction_id)) OVER () AS avg_order
FROM 
coffee_sales
WHERE 
MONTH(transaction_date) = 5  -- Filter for May
GROUP BY 
DAY(transaction_date)) AS order_data
ORDER BY day_of_month;

#Total Sales & Orders by WEEKDAY / WEEKEND:
select 
case 
when dayofweek(transaction_Date) in (1,7) then "Weekends"
else "Weekdays"
end as day_type,
round(Sum(sales),2) as Total_Sales,
count(transaction_id) as Total_Orders
from coffee_sales
 
 group by day_type
 order by day_type;
 
 
select dayname(transaction_date) as Days,
sum(transaction_qty) as Total_Qty,
count(transaction_id) as Total_Orders,
round(sum(sales),2) as Total_Sales
from coffee_sales

where month(transaction_date) = 5
group by Days;









