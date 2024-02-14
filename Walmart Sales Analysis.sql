-- creating the db 
CREATE DATABASE IF NOT EXISTS walmartSalesData;


-- creating a table
CREATE TABLE IF NOT EXISTS sales (
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10 , 2 ) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6 , 4 ) NOT NULL,
    total DECIMAL(12 , 4 ) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10 , 2 ) NOT NULL,
    gross_margin_pct FLOAT(11 , 9 ),
    gross_income DECIMAL(12 , 4 ) NOT NULL,
    rating FLOAT(2 , 1 )
);


-- looking at data. Data wrangling is not needed here because of "NOT NULL" clauses when creating the table
SELECT 
    *
FROM
    walmartsalesdata.sales;


-- creating new column called "time_of_day" to gain insight on when the sales occured (Morning, Afternoon, or Evening). This is to show which part of the day most sales are made
SELECT 
    time,
    (CASE
        WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time` BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END) AS time_of_day
FROM
    sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales 
SET 
    time_of_day = (CASE
        WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time` BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END);


-- Adding a new column called  "day_name" that contains the days of the week on which each transaction took place (Mon, Tue, etc,). This is to demonstrate which day of the week each branch was the busiest.
SELECT 
    date, DAYNAME(date) AS day_name
FROM
    sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales 
SET 
    day_name = DAYNAME(date);


-- Adding a new column called  "month_name" that contains the month of the year on which each transaction took place (Jan, Feb, etc,). This is to demonstrate which month of the year has the most sales and profits.
SELECT 
    date, MONTHNAME(date) AS month_name
FROM
    sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales 
SET 
    month_name = MONTHNAME(date);
-- ---------------------------------------------------------------
-- ------------------------------general info

SELECT DISTINCT
    (city)
FROM
    sales;


-- branch location to city
SELECT DISTINCT
    (city), branch
FROM
    sales;
    
-- ----------------------------product related info


SELECT 
    COUNT(DISTINCT (product_line)) AS unique_num_of_products
FROM
    sales;


-- most common payment method
SELECT 
    payment_method, COUNT(payment_method) AS payment_count
FROM
    sales
GROUP BY payment_method;


--  most selling product
SELECT 
    product_line, COUNT(product_line) AS product_cnt
FROM
    sales
GROUP BY product_line;


-- total revenue by month
SELECT 
    month_name AS month, SUM(total) AS total_revenue
FROM
    sales
GROUP BY month_name;


-- which month had the largest COGS (positive correlation between more revenue and higher COGS)
SELECT 
    month_name AS month, SUM(cogs) AS cogs
FROM
    sales
GROUP BY month_name
ORDER BY cogs DESC;


-- product line with largest revenue
SELECT 
    product_line, SUM(total) AS total_revenue
FROM
    sales
GROUP BY product_line
ORDER BY total_revenue;


-- city with largest revenue
SELECT 
    city, branch, SUM(total) AS total_revenue
FROM
    sales
GROUP BY city , branch
ORDER BY total_revenue;


-- product with largest VAT
SELECT 
    product_line AS product, AVG(vat) AS avg_tax
FROM
    sales
GROUP BY product_line
ORDER BY avg_tax;

-- branch that sold more than average
SELECT 
    branch, SUM(quantity) AS total_sold
FROM
    sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT 
        AVG(quantity)
    FROM
        sales);

-- most commone product line by gender
SELECT
gender,
product_line,
COUNT(gender) AS total_count
FROM sales
GROUP BY
gender,
product_line
ORDER BY total_count


-- average rating of each product line
SELECT
ROUND(AVG(rating), 2) AS rating_avg,
product_line
FROM sales
GROUP BY product_line
ORDER BY rating_avg;


-- ----------------------------sales related info

SELECT 
    time_of_day, COUNT(*) AS total_sales
FROM
    sales
GROUP BY time_of_day;


-- customer type that brings in most revenue
SELECT 
    customer_type, ROUND(SUM(total), 2) AS total_revenue
FROM
    sales
GROUP BY customer_type;


-- city with largest VAT
SELECT 
    city, branch, ROUND(AVG(vat), 2) AS highest_vat_rate
FROM
    sales
GROUP BY city , branch
ORDER BY highest_vat_rate;


-- customer type that pays the most in VAT
SELECT 
    customer_type, ROUND(AVG(vat), 2) AS vat_avg
FROM
    sales
GROUP BY customer_type
ORDER BY vat_avg;


-- ----------------------------customer related info

SELECT 
    customer_type, COUNT(customer_type) AS num_of_customers
FROM
    sales
GROUP BY customer_type;


-- # of unique payment methods
SELECT 
    payment_method, COUNT(payment_method) AS payment_type_count
FROM
    sales
GROUP BY payment_method;


--  customer type that buys the most
SELECT 
    customer_type,
    ROUND(SUM(total), 2) AS total_amount_spent,
    COUNT(customer_type) AS num_of_customers
FROM
    sales
GROUP BY customer_type;


-- gender of most customers
SELECT 
    gender, COUNT(gender) AS gender_count
FROM
    sales
GROUP BY gender;


-- gender distribution per branch
-- branch A
SELECT 
    gender, COUNT(gender) AS gender_count
FROM
    sales
WHERE
    branch = 'A'
GROUP BY gender;

-- branch B
SELECT 
    gender, COUNT(gender) AS gender_count
FROM
    sales
WHERE
    branch = 'B'
GROUP BY gender;


-- branch C
SELECT 
    gender, COUNT(gender) AS gender_count
FROM
    sales
WHERE
    branch = 'C'
GROUP BY gender;


-- time of day customers give ratings
SELECT 
    time_of_day, AVG(rating) AS avg_rating
FROM
    sales
GROUP BY time_of_day
ORDER BY avg_rating;

-- time of day customers give ratings per branch
-- branch A
SELECT 
    time_of_day, AVG(rating) AS avg_rating
FROM
    sales
WHERE
    branch = 'A'
GROUP BY time_of_day
ORDER BY avg_rating;

-- branch B
SELECT 
    time_of_day, AVG(rating) AS avg_rating
FROM
    sales
WHERE
    branch = 'B'
GROUP BY time_of_day
ORDER BY avg_rating;

-- branch C
SELECT 
    time_of_day, AVG(rating) AS avg_rating
FROM
    sales
WHERE
    branch = 'C'
GROUP BY time_of_day
ORDER BY avg_rating;


-- day of the week with best avg rating
SELECT 
    day_name, AVG(rating) AS avg_rating
FROM
    sales
GROUP BY day_name
ORDER BY avg_rating DESC;


-- day of the week with best avg rating per branch
-- branch A
SELECT 
    day_name, AVG(rating) AS avg_rating
FROM
    sales
WHERE
    branch = 'A'
GROUP BY day_name
ORDER BY avg_rating DESC;

-- branch B
SELECT 
    day_name, AVG(rating) AS avg_rating
FROM
    sales
WHERE
    branch = 'B'
GROUP BY day_name
ORDER BY avg_rating DESC;

-- branch C
SELECT 
    day_name, AVG(rating) AS avg_rating
FROM
    sales
WHERE
    branch = 'C'
GROUP BY day_name
ORDER BY avg_rating DESC;