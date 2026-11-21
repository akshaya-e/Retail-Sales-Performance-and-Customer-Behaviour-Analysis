CREATE DATABASE IF NOT EXISTS retail_sales_analysis;
USE retail_sales_analysis;
SELECT * FROM `retail-sales-dataset` LIMIT 10;

-- STEP 1: DATA QUALITY CHECKS
-- 1.1 Check the total number of records
SELECT COUNT(*) AS total_records FROM `retail-sales-dataset`;

-- 1.2 Check table structure and data types
DESCRIBE `retail-sales-dataset`;

-- 1.3 Check for duplicate Row IDs
SELECT `Row ID`,COUNT(*) AS record_count FROM `retail-sales-dataset` GROUP BY `Row ID` HAVING COUNT(*) > 1;

-- 1.4 Check for missing values in important columns
SELECT
    COUNT(*) AS total_records,
    SUM(`Order ID` IS NULL OR `Order ID` = '') AS missing_order_id,
    SUM(`Order Date` IS NULL) AS missing_order_date,
    SUM(`Ship Date` IS NULL) AS missing_ship_date,
    SUM(`Customer ID` IS NULL OR `Customer ID` = '') AS missing_customer_id,
    SUM(`Customer Name` IS NULL OR `Customer Name` = '') AS missing_customer_name,
    SUM(`Segment` IS NULL OR `Segment` = '') AS missing_segment,
    SUM(`Region` IS NULL OR `Region` = '') AS missing_region,
    SUM(`Category` IS NULL OR `Category` = '') AS missing_category,
    SUM(`Sub-Category` IS NULL OR `Sub-Category` = '') AS missing_sub_category,
    SUM(`Product Name` IS NULL OR `Product Name` = '') AS missing_product_name,
    SUM(`Sales` IS NULL) AS missing_sales,
    SUM(`Quantity` IS NULL) AS missing_quantity,
    SUM(`Profit` IS NULL) AS missing_profit
FROM `retail-sales-dataset`;

-- 1.5 Check for invalid quantities or shipping date anomalies
SELECT COUNT(*) AS invalid_records FROM `retail-sales-dataset` WHERE `Quantity` <= 0 OR `Ship Date` < `Order Date`;

-- STEP 2: EXPLORATORY DATA ANALYSIS (EDA)
-- 2.1 Overall KPI summary (Sales, Profit, Profit Margin, Quantity, Orders, Customers)
SELECT ROUND(SUM(`Sales`), 2) AS total_sales,ROUND(SUM(`Profit`), 2) AS total_profit,ROUND((SUM(`Profit`) / NULLIF(SUM(`Sales`), 0)) * 100, 2) AS profit_margin_pct,SUM(`Quantity`) AS total_quantity,COUNT(DISTINCT `Order ID`) AS total_orders,COUNT(DISTINCT `Customer ID`) AS total_customers FROM `retail-sales-dataset`;

-- 2.2 Order date range
SELECT MIN(`Order Date`) AS earliest_order_date, MAX(`Order Date`) AS latest_order_date FROM `retail-sales-dataset`;

-- 2.3 Sales, Profit, and Profit Margin by Region
SELECT `Region`,COUNT(DISTINCT `Order ID`) AS order_count, SUM(`Quantity`) AS total_quantity,ROUND(SUM(`Sales`), 2) AS total_sales,ROUND(SUM(`Profit`), 2) AS total_profit,ROUND((SUM(`Profit`) / NULLIF(SUM(`Sales`), 0)) * 100, 2) AS profit_margin_pct FROM `retail-sales-dataset` GROUP BY `Region` ORDER BY total_sales DESC;

-- 2.4 Sales, Profit, and Profit Margin by Customer Segment
SELECT `Segment`,COUNT(DISTINCT `Order ID`) AS order_count,COUNT(DISTINCT `Customer ID`) AS customer_count,SUM(`Quantity`) AS total_quantity,ROUND(SUM(`Sales`), 2) AS total_sales,ROUND(SUM(`Profit`), 2) AS total_profit,ROUND((SUM(`Profit`) / NULLIF(SUM(`Sales`), 0)) * 100, 2) AS profit_margin_pct FROM `retail-sales-dataset`
GROUP BY `Segment` ORDER BY total_sales DESC;

-- 2.5 Sales, Profit, and Profit Margin by Category
SELECT `Category`,COUNT(DISTINCT `Order ID`) AS order_count,SUM(`Quantity`) AS total_quantity,ROUND(SUM(`Sales`), 2) AS total_sales,ROUND(SUM(`Profit`), 2) AS total_profit,ROUND((SUM(`Profit`) / NULLIF(SUM(`Sales`), 0)) * 100, 2) AS profit_margin_pct
FROM `retail-sales-dataset` GROUP BY `Category` ORDER BY total_sales DESC;

-- 2.6 Yearly sales and profit performance (2014–2017)
SELECT YEAR(`Order Date`) AS order_year,COUNT(DISTINCT `Order ID`) AS order_count,SUM(`Quantity`) AS total_quantity,ROUND(SUM(`Sales`), 2) AS total_sales,ROUND(SUM(`Profit`), 2) AS total_profit,
ROUND((SUM(`Profit`) / NULLIF(SUM(`Sales`), 0)) * 100, 2) AS profit_margin_pct FROM `retail-sales-dataset` GROUP BY YEAR(`Order Date`)
ORDER BY order_year;

-- 2.7 Monthly sales trend for 2017
SELECT MONTH(`Order Date`) AS month_num,DATE_FORMAT(`Order Date`, '%b') AS month_name,COUNT(DISTINCT `Order ID`) AS order_count,SUM(`Quantity`) AS total_quantity,
ROUND(SUM(`Sales`), 2) AS total_sales,ROUND(SUM(`Profit`), 2) AS total_profit FROM `retail-sales-dataset` WHERE YEAR(`Order Date`) = 2017
GROUP BY MONTH(`Order Date`), DATE_FORMAT(`Order Date`, '%b')ORDER BY month_num;

-- STEP 3: PRODUCT & CATEGORY PERFORMANCE ANALYSIS
-- 3.1 Top 5 Products by Total Sales
SELECT `Product Name`,`Category`,`Sub-Category`,SUM(`Quantity`) AS total_quantity,ROUND(SUM(`Sales`), 2) AS total_sales,ROUND(SUM(`Profit`), 2) AS total_profit
FROM `retail-sales-dataset` GROUP BY `Product Name`, `Category`, `Sub-Category` ORDER BY total_sales DESC LIMIT 5;

-- 3.2 Sub-Category profit performance (identify loss-making sub-categories)
SELECT `Category`,`Sub-Category`,SUM(`Quantity`) AS total_quantity,ROUND(SUM(`Sales`), 2) AS total_sales,ROUND(SUM(`Profit`), 2) AS total_profit,
ROUND((SUM(`Profit`) / NULLIF(SUM(`Sales`), 0)) * 100, 2) AS profit_margin_pct FROM `retail-sales-dataset` GROUP BY `Category`, `Sub-Category`
ORDER BY total_profit ASC;

-- 3.3 Product Sales Rank across products
SELECT `Product Name`,ROUND(SUM(`Sales`), 2) AS total_sales,ROUND(SUM(`Profit`), 2) AS total_profit,DENSE_RANK() OVER (ORDER BY SUM(`Sales`) DESC) AS product_sales_rank
FROM `retail-sales-dataset` GROUP BY `Product Name` ORDER BY product_sales_rank, total_sales DESC;

-- 3.4 Product contribution % to total sales
SELECT `Product Name`,ROUND(SUM(`Sales`), 2) AS product_sales,ROUND((SUM(`Sales`) / NULLIF(SUM(SUM(`Sales`)) OVER (), 0)) * 100, 2) AS contribution_pct
FROM `retail-sales-dataset`GROUP BY `Product Name`ORDER BY product_sales DESC LIMIT 15;

-- STEP 4: CUSTOMER BEHAVIOUR & YoY ANALYSIS
-- 4.1 Top 5 Customers by Total Sales
SELECT
    `Customer ID`,`Customer Name`,`Segment`,`Region`,COUNT(DISTINCT `Order ID`) AS order_count,MAX(`Order Date`) AS last_purchase_date,
    SUM(`Quantity`) AS total_quantity,ROUND(SUM(`Sales`), 2) AS total_sales,ROUND(SUM(`Profit`), 2) AS total_profit FROM `retail-sales-dataset`
    GROUP BY `Customer ID`, `Customer Name`, `Segment`, `Region` ORDER BY total_sales DESC LIMIT 5;

-- 4.2 Customer order frequency (One-Time vs Repeat Customers)
SELECT CASE WHEN order_cnt = 1 THEN 'One-Time Customer' ELSE 'Repeat Customer' END AS customer_type,COUNT(*) AS customer_count,ROUND(SUM(cust_sales), 2) AS total_sales,ROUND(SUM(cust_profit), 2) AS total_profit
FROM (SELECT `Customer ID`,COUNT(DISTINCT `Order ID`) AS order_cnt,SUM(`Sales`) AS cust_sales,SUM(`Profit`) AS cust_profit FROM `retail-sales-dataset`GROUP BY `Customer ID`) AS customer_orders
GROUP BY customer_type ORDER BY customer_count DESC;

-- 4.3 Year-over-Year (YoY) Sales Growth by Year
WITH yearly_summary AS (SELECT YEAR(`Order Date`) AS order_year,SUM(`Sales`) AS current_year_sales,SUM(`Profit`) AS current_year_profit FROM `retail-sales-dataset` GROUP BY YEAR(`Order Date`)
)SELECT order_year,ROUND(current_year_sales, 2) AS current_year_sales,ROUND(LAG(current_year_sales) OVER (ORDER BY order_year), 2) AS previous_year_sales,ROUND(
((current_year_sales - LAG(current_year_sales) OVER (ORDER BY order_year))/ NULLIF(LAG(current_year_sales) OVER (ORDER BY order_year), 0)) * 100,2) AS yoy_sales_growth_pct,
ROUND(current_year_profit, 2) AS current_year_profit FROM yearly_summary ORDER BY order_year;

-- 4.4 Monthly sales comparison with previous year (YoY monthly check)
WITH monthly_summary AS (SELECT YEAR(`Order Date`) AS order_year,MONTH(`Order Date`) AS order_month,DATE_FORMAT(`Order Date`, '%b') AS month_name,SUM(`Sales`) AS monthly_sales
FROM `retail-sales-dataset` GROUP BY YEAR(`Order Date`), MONTH(`Order Date`), DATE_FORMAT(`Order Date`, '%b'))
SELECT order_year,order_month,month_name,ROUND(monthly_sales, 2) AS current_sales,ROUND(LAG(monthly_sales, 12) OVER (ORDER BY order_year, order_month), 2) AS prior_year_same_month_sales,ROUND(
((monthly_sales - LAG(monthly_sales, 12) OVER (ORDER BY order_year, order_month))/ NULLIF(LAG(monthly_sales, 12) OVER (ORDER BY order_year, order_month), 0)) * 100,2
) AS yoy_monthly_growth_pct FROM monthly_summary ORDER BY order_year, order_month;


-- STEP 5: FINAL INSIGHTS & INTEGRATED SUMMARY
-- 5.1 Region and Segment sales & profit summary
SELECT `Region`,`Segment`,COUNT(DISTINCT `Order ID`) AS order_count,SUM(`Quantity`) AS total_quantity,ROUND(SUM(`Sales`), 2) AS total_sales,ROUND(SUM(`Profit`), 2) AS total_profit,ROUND((SUM(`Profit`) / NULLIF(SUM(`Sales`), 0)) * 100, 2) AS profit_margin_pct
FROM `retail-sales-dataset` GROUP BY `Region`, `Segment` ORDER BY total_sales DESC;

-- 5.2 High-value orders exceeding overall average order value
SELECT `Order ID`,`Order Date`,`Customer Name`,`Region`,`Segment`,SUM(`Quantity`) AS order_quantity,ROUND(SUM(`Sales`), 2) AS order_sales,ROUND(SUM(`Profit`), 2) AS order_profit
FROM `retail-sales-dataset` GROUP BY `Order ID`, `Order Date`, `Customer Name`, `Region`, `Segment` HAVING SUM(`Sales`) > (
SELECT AVG(order_total)FROM ( SELECT SUM(`Sales`) AS order_total FROM `retail-sales-dataset` GROUP BY `Order ID`) AS avg_order_table
)ORDER BY order_sales DESC LIMIT 20;

-- 5.3 Monthly running total sales over time
SELECT DATE_FORMAT(`Order Date`, '%Y-%m') AS year_month_label,ROUND(SUM(`Sales`), 2) AS monthly_sales,ROUND(SUM(SUM(`Sales`)) OVER (ORDER BY DATE_FORMAT(`Order Date`, '%Y-%m')), 2) AS running_total_sales,
ROUND(SUM(`Profit`), 2) AS monthly_profit FROM `retail-sales-dataset` GROUP BY DATE_FORMAT(`Order Date`, '%Y-%m')ORDER BY year_month_label;

-- FINAL SQL INSIGHTS
/*
1. The dataset covers 9,994 order lines across 5,009 orders and
   793 customers from January 2014 to December 2017.

2. Overall sales reach approximately $2.30M with ~$286K in total
   profit and a ~12.5% profit margin across 37,873 units sold.

3. Annual sales grew in 2016 and 2017 with strong Q4 and November
   seasonality, while April 2017 saw a sharp monthly drop.

4. The West region leads total sales and margin, whereas the
   Central region lags in profit margin.

5. Technology and Office Supplies drive stronger margins than
   Furniture, and sub-categories such as Tables, Bookcases, and
   Supplies show negative profit performance.

6. Top products (such as the Canon imageCLASS copier) and top
   customers (such as Sean Miller, Tamara Chand, Raymond Buch,
   Tom Ashbrook, and Adrian Barton) account for major revenue,
   though high sales do not always guarantee positive profit.
*/
