CREATE TABLE sales (
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    tax_pct DECIMAL(6,4) NOT NULL CHECK (tax_pct >= 0),
    total DECIMAL(12,4) NOT NULL CHECK (total >= 0),
    date TIMESTAMP NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL CHECK (cogs >= 0),
    gross_margin_pct DECIMAL(11,9) NULL CHECK (gross_margin_pct >= 0),
    gross_income DECIMAL(12,4) NULL CHECK (gross_income >= 0),
    rating DECIMAL(3,1) NULL CHECK (rating BETWEEN 0 AND 10)  -- FIXED
);


ALTER TABLE sales RENAME COLUMN payment TO payment_method;

-- Featuring Engineering --------- 

-- time_of_day -- 

SELECT 
	time,
CASE 
    WHEN "time" BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
    WHEN "time" BETWEEN '12:00:01' AND '16:00:00' THEN 'Afternoon'
    ELSE 'Evening'
END AS time_of_day
FROM sales; 

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR (20);

UPDATE sales
SET time_of_day = 
    CASE 
        WHEN "time" BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN "time" BETWEEN '12:00:01' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END;

SELECT * FROM sales;

-- day_name -- 

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = TO_CHAR(date, 'Day');

SELECT * FROM sales;

-- month_name -- 

ALTER TABLE sales ADD COLUMN month_name VARCHAR(15);

UPDATE sales 
SET month_name =TO_CHAR(date, 'Month');

-- ------------------------------------------------------- 

-- Business Questions To Answer ------------------------
-- Generic Question -------------------------
-- 1. How many unique cities does the data have? 

SELECT 
DISTINCT (city)	
FROM sales; 

-- 2. In which city is each branch? 

SELECT 
	DISTINCT (city), 
	branch
FROM sales;

-- Product ------------------------------- 
-- 1. How many unique product lines does the data have?

SELECT 
	DISTINCT (product_line)
FROM sales;

-- 2. What is the most common payment method?

SELECT 
    payment_method AS common_payment_method, 
    COUNT(*) AS count 
FROM sales 
GROUP BY payment_method 
ORDER BY count DESC;

-- 3. What is the most selling product line? 

SELECT 
    product_line, 
    COUNT(product_line) AS cnt
FROM sales
GROUP BY 1
ORDER BY 2 DESC;

-- 4. What is the total revenue by month? 

SELECT 
	month_name AS month,
	SUM(total) AS total_revenue
FROM sales
GROUP BY 1
ORDER BY 2 DESC; 

-- 5. What month had the largest COGS?

SELECT 
	month_name AS month,
	SUM(cogs) AS largest_cogs
FROM sales
GROUP BY 1
ORDER BY 2 DESC;

-- 6. What product line had the largest revenue?

SELECT 
	product_line,
	SUM(total) AS largest_revenue
FROM sales
GROUP BY 1
ORDER BY 2 DESC; 

-- 5. What is the city with the largest revenue? 

SELECT 
	city,
	SUM(total) AS largest_revenue 
FROM sales
GROUP BY 1
ORDER BY 2 DESC; 

-- 6. What product line had the largest VAT?

SELECT 
	product_line,
	SUM(tax_pct) AS largest_VAT
FROM sales
GROUP BY 1
ORDER BY 2 DESC; 

-- 7 Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

SELECT 
    product_line, 
    ROUND(AVG(total),2) AS avg_sale,
    CASE 
        WHEN AVG(total) > (SELECT AVG(total) FROM sales) THEN 'Good'
        ELSE 'Bad'
    END AS sales_category
FROM sales
GROUP BY 1
ORDER BY 2 DESC;

-- 8. Which branch sold more products than average product sold?

SELECT 
    branch, 
    SUM(quantity) AS total_products_sold
FROM sales
GROUP BY 1
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales)
ORDER BY 2 DESC;

-- 9. What is the most common product line by gender?

SELECT 
	product_line,
	gender,
	COUNT(gender) AS common_gender
FROM sales
GROUP BY 1 , 2
ORDER BY 3 DESC; 

-- 10. What is the average rating of each product line? 

SELECT 
	product_line, 
	ROUND(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY 1
ORDER BY 2 DESC;




