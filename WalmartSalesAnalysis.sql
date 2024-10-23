CREATE DATABASE walmart;

USE walmart;

SELECT * FROM w_sales;

CREATE TABLE w_sales
(invoice_id  VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender VARCHAR(30) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10, 2) NOT NULL,
quantity INT NOT NULL,
VAT FLOAT(6, 4) NOT NULL,
total DECIMAL(12, 4) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment VARCHAR(20) NOT NULL,
cogs DECIMAL (10, 2) NOT NULL,
gross_margin_pct FLOAT (11, 9),
gross_income DECIMAL (12, 4),
rating FLOAT(2, 1));

SELECT * FROM w_sales;

# Feature Engineering 
SELECT time, 
(CASE
WHEN `time` BETWEEN "00:00:00" AND "12;00;00"THEN "Morning"
WHEN `time` BETWEEN "12;01;00" AND "16;00;00" THEN "Afternoon"
ELSE "Evening"
END) AS time_of_date
FROM w_sales;

ALTER TABLE w_sales ADD COLUMN time_of_day VARCHAR(20);

SET SQL_SAFE_UPDATES = 0;

UPDATE w_sales 
SET time_of_day = (
    CASE
        WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

-- DAY NAME

SELECT date, DAYNAME(DATE) FROM w_sales;

ALTER TABLE w_sales ADD COLUMN day_name VARCHAR(20);

UPDATE w_sales
SET day_name = DAYNAME(date); 

-- Month name

ALTER TABLE w_sales ADD COLUMN month_name VARCHAR(20); 

-- SELECT DISTINCT(MONTHNAME(date)) FROM w_sales;
UPDATE w_sales
SET month_name = MONTHNAME(date);

-- --------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------GENERIC-------------------------------------------------------------------------------------
--  How many unique cities does the data have?
SELECT COUNT(DISTINCT(city)) FROM w_sales;  

--  In which city is each branch?

SELECT DISTINCT(city), branch FROM w_sales; 

-- How many unique product lines does the data have?

SELECT DISTINCT(product_line) FROM w_sales; 

-- What is the most common payment method?

SELECT payment , COUNT(payment) AS cnt FROM w_sales
GROUP BY payment
ORDER BY cnt DESC; 

-- What is the most selling product line?

SELECT DISTINCT(product_line), COUNT(gross_income) AS cnt FROM w_sales
GROUP BY product_line
ORDER BY cnt DESC;

SELECT product_line, COUNT(product_line) AS cnt FROM w_sales
GROUP BY product_line
ORDER BY cnt DESC;

-- What is the total revenue by month?

-- SELECT SUM(quantity * unit_price) AS total_revenue FROM w_sales;
SELECT SUM(total) AS total_revenue , month_name FROM w_sales
GROUP BY month_name
ORDER BY total_revenue DESC;

--  What month had the largest COGS?

SELECT month_name , SUM(cogs) AS largest_cogs FROM w_sales
GROUP BY month_name
ORDER BY largest_cogs DESC;

--  What product line had the largest revenue?

SELECT DISTINCT(product_line) , SUM(total) AS largest_revenue FROM w_sales
GROUP BY product_line
ORDER BY largest_revenue desc; 

--  What is the city with the largest revenue?

SELECT city, SUM(total) AS total_revenue FROM w_sales
GROUP BY city
ORDER BY total_revenue DESC;

-- What product line had the largest VAT?
SELECT product_line , AVG(VAT) AS largest_vat FROM w_sales
GROUP BY product_line
ORDER BY largest_vat DESC;

-- Fetch each product line and add a column to those product line showing "Good", 
-- "Bad". Good if its greater than average sale

-- Which branch sold more products than average product sold?

SELECT branch, SUM(quantity) AS qunt FROM w_sales
GROUP BY branch 
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM w_sales);

-- What is the most common product line by gender? 

SELECT product_line , gender, COUNT(gender) AS CNT FROM w_sales
GROUP BY gender,product_line
ORDER by CNT DESC;

-- What is the average rating of each product line?

SELECT product_line , ROUND(AVG(rating), 2) AS avge_rating FROM w_sales
GROUP BY product_line 
ORDER BY avge_rating DESC;

SELECT * FROM w_sales;
-- Number of sales made in each time of the day per weekday
SELECT time_of_day, COUNT(*), day_name AS total FROM w_sales
WHERE day_name = "Sunday"
GROUP BY time_of_day
ORDER BY total desc; 

-- Which of the customer types brings the most revenue?
SELECT customer_type, SUM(total) AS revenue FROM w_sales
GROUP BY customer_type
ORDER BY revenue desc; 

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city, ROUND(AVG(VAT), 2) AS avg_tax FROM w_sales
GROUP BY city
ORDER BY avg_tax DESC;

-- Which customer type pays the most in VAT?
SELECT customer_type , ROUND(AVG(VAT), 2) AS avg_vat FROM w_sales
GROUP BY customer_type
ORDER BY avg_vat DESC;

-- How many unique customer types does the data have?
SELECT DISTINCT customer_type as num_type FROM w_sales;

-- How many unique payment methods does the data have?
SELECT DISTINCT payment FROM w_sales;

-- What is the most common customer type?
SELECT customer_type, COUNT(*) AS type_1 FROM w_sales
GROUP BY customer_type;