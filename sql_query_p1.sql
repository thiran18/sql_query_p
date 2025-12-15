create database Retail_Sales_Data_Analysis;
use Retail_Sales_Data_Analysis;

CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id VARCHAR(50),
    gender VARCHAR(50),
    age INT,
    category VARCHAR(50),
    quantiy INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
show tables;


SELECT 
    *
FROM
    retail_sales;
SELECT 
    COUNT(*)
FROM
    retail_sales;
-- ==============================================================================================
-- Data Cleaning
-- ===================================
-- NUll Handling
-- ================================


SELECT 
    COUNT(*)
FROM
    retail_sales
WHERE
    transactions_id IS NULL
        OR sale_date IS NULL
        OR sale_time IS NULL
        OR customer_id IS NULL
        OR gender IS NULL
        OR age IS NULL
        OR category IS NULL
        OR quantity IS NULL
        OR price_per_unit IS NULL
        OR cogs IS NULL
        OR total_sale IS NULL;
     
     

-- TYPE 2
SELECT 
    COUNT(*)
FROM
    retail_sales
WHERE
    COALESCE(transactions_id,
            sale_date,
            sale_time,
            customer_id,
            gender,
            age,
            category,
            quantity,
            price_per_unit,
            cogs,
            total_sale) IS NULL;


alter table  retail_sales
change quantiy quantity int;

-- type 1
DELETE FROM retail_sales 
WHERE
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
     
-- type 2     
DELETE FROM retail_sales 
WHERE
    COALESCE(transactions_id,
        sale_date,
        sale_time,
        customer_id,
        gender,
        age,
        category,
        quantity,
        price_per_unit,
        cogs,
        total_sale) IS NULL;

-- ===============================================================================================
-- =====================
-- data exploration  
-- =====================
-- how many sales we have?
SELECT 
    COUNT(*) AS total_sale
FROM
    retail_sales;
 --  how many coustomers we have?
SELECT 
    COUNT(customer_id) AS total_customer
FROM
    retail_sales;
--  how many unique coustomer we have?
SELECT 
    COUNT(DISTINCT customer_id) AS total_customer
FROM
    retail_sales;
-- how many category we have?
SELECT DISTINCT
    category AS total_category
FROM
    retail_sales;

-- ===========================================================================================================
-- ================================
-- data analysis or business key problems & answers
-- ================================
-- 1.	Write a SQL query to retrieve all columns for sales made on '2022-11-05:
-- 2.	Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
-- 3.	Write a SQL query to calculate the total sales (total_sale) for each category.:
-- 4.	Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
-- 5.	Write a SQL query to find all transactions where the total_sale is greater than 1000.:
-- 6.	Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
-- 7.	Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
-- 8.	**Write a SQL query to find the top 5 customers based on the highest total sales **:
-- 9.	Write a SQL query to find the number of unique customers who purchased items from each category.:
-- 10.	Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

SELECT 
    *
FROM
    retail_sales
WHERE
    sale_date = '2022-11-05';

-- 2.	Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT 
    *
FROM
    retail_sales
WHERE
    category = 'Clothing'
        AND sale_date BETWEEN '2022-11-01' AND '2022-12-01'
        AND quantity >= 4;
-- another
SELECT 
    *
FROM
    retail_sales
WHERE
    category = 'Clothing'
        AND YEAR(sale_date) = '2022'
        AND MONTH(sale_date) = '11'
        AND quantity >= 4;

-- 3.	Write a SQL query to calculate the total sales (total_sale) for each category.:

SELECT 
    category,
    SUM(total_sale) AS net_sales,
    COUNT(*) AS total_order
FROM
    retail_sales
GROUP BY category;

-- 4.	Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT 
    ROUND(AVG(age), 2) AS avg_age
FROM
    retail_sales
WHERE
    category = 'Beauty';

-- 5.	Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT 
    *
FROM
    retail_sales
WHERE
    total_sale > 1000;

-- 6.	Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT 
    category, gender, COUNT(*) AS total_transaction
FROM
    retail_sales
GROUP BY category , gender
ORDER BY category;

-- 7.	Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
select * from(select 
extract(year from sale_date)as year,
extract(month from sale_date)as month,
avg(total_sale) as avg_sale,
rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as Rank_
from retail_sales
group by year,month
) as t1
where Rank_=1;

-- with cte
with monthly_avg as(
select 
extract(year from sale_date)as year,
extract(month from sale_date)as month,
avg(total_sale) as avg_sale,
rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as Rank_
from retail_sales
group by year,month
) select * from monthly_avg
where Rank_=1;

-- 8.	**Write a SQL query to find the top 5 customers based on the highest total sales **:
SELECT 
    customer_id, SUM(total_sale) AS total_sales
FROM
    retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- 9.	Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT 
    category, COUNT(DISTINCT customer_id) AS unique_customer
FROM
    retail_sales
GROUP BY category;

-- 10.	Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
 with hourly_sales as(
 SELECT 
    *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN EXTRACT(HOUR FROM sale_time) > 17 THEN 'Evening'
    END AS Shift
FROM retail_sales
)select Shift,count(*)as total_orders
from hourly_sales
group by Shift;


select extract(minute from current_timestamp());