create database retail_analysis;

-- Create Table
drop table if exists retail;
create table retail(
	transactions_id int primary key,
    sale_date date,
	sale_time time,
	customer_id int,
	gender varchar(15),
	age int,	
    category varchar(15),
	quantiy	int,
    price_per_unit float,
	cogs float,
	total_sale float
);

select * from retail_sales;

select
	count(*)
from retail_sales;


-- Data Cleaning
select *
from retail_sales
where 
	transactions_id is null
	or
    sale_date is null
    or
    sale_time is null
    or
    customer_id is null
    or
    gender is null
    or
    age is null
    or
    age is null
    or
    category is null
    or
    quantiy is null
    or
    price_per_unit is null
    or
    cogs is null
    or
    total_sale is null
;

delete from retail_sales
where
	transactions_id is null
	or
    sale_date is null
    or
    sale_time is null
    or
    customer_id is null
    or
    gender is null
    or
    age is null
    or
    age is null
    or
    category is null
    or
    quantiy is null
    or
    price_per_unit is null
    or
    cogs is null
    or
    total_sale is null
;

select count(*) from retail_sales;

alter table retail_sales
rename column quantiy to quantity;


-- Data Exploration

-- Number of Unique Customers
select count(distinct customer_id) from retail_sales;
select distinct category from retail_sales;

-- Data Analysis and Business key problems

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retail_sales
where sale_date = '2022-11-05'
;

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 2 in the month of Nov-2022
select * from retail_sales
where 
	category = 'Clothing'
    and
    sale_date between '2022-11-01' AND '2022-11-30'
    and quantity > 2
group by 1
;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category, sum(total_sale) as 'Net Sale', count(*) as 'Total Orders'
from retail_sales
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select category, avg(age) as 'Average Age', count(*) as 'Total Orders' 
from retail_sales
where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category, gender, count(*) as total_transactions
from retail_sales
group by category, gender
order by 1
;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
select year, month, average_sale from
(
	select
		year(sale_date) as 'year',
		month(sale_date) as 'month',
		avg(total_sale) as 'average_sale',
		rank() over(partition by year(sale_date) order by avg(total_sale) desc) as ranking
	from retail_sales
	group by 1, 2
) as t1
where ranking = 1
;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
select customer_id, sum(total_sale )
from retail_sales
group by 1
order by 2 desc
limit 5
;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category, count(distinct customer_id) as 'Number of Customers'
from retail_sales
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with hourly_sales as
(
select *, 
	case
		when hour(sale_time) < 12 then 'Morning'
		when hour(sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
from retail_sales
)
select shift, count(*) as 'Total Orders'
from hourly_sales
group by shift
order by 2 desc
;

-- End of Analysis
select hour(current_time()), minute(current_time()), second(current_time());
