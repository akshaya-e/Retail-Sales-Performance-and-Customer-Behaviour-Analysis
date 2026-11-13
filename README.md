RETAIL SALES PERFORMANCE AND CUSTOMER BEHAVIOUR - POWER BI DASHBOARD

OVERVIEW

An interactive Power BI report that helps management see top-performing
products, profitable regions, customer segments, monthly sales trends, and
sales against target.

Live Preview [Sales Dashboard Preview](dashnoard.PNG)

DATASET

Table: Retails Order Full Dataset
9,994 order lines | 5,009 orders | 793 customers | 2 Jan 2014 to 30 Dec 2017

Order columns:     Row ID, Order ID, Order Date, Ship Date, Ship Mode, Returned
Customer columns:  Customer ID, Customer Name, Segment
Location columns:  Country, State, City, Postal Code, Region, Retail Sales People
Product columns:   Product ID, Category, Sub-Category, Product Name
Number columns:    Sales, Quantity, Discount, Profit

Regions:     West, East, Central, South
Categories:  Furniture, Office Supplies, Technology
Segments:    Consumer, Corporate, Home Office


DAX MEASURES

Total Sales, Total Profit, Total Quantity   Sums of Sales, Profit and Quantity
Profit Margin                Total Profit / Total Sales
Previous year sales          Sales for the same period last year
YoY Sales Growth %, YoY Sales %   Year-over-year comparison
MoM Sales %                  Change from the previous month
Sales Target                 Q4 2016 sales (1 Oct to 31 Dec 2016) x 1.10
Target Achieved %            Total Sales / Sales Target
Max Gauge, Target Value Measure   Gauge maximum (1.25) and target marker (1)
Product Sales Rank           Dense rank of products by sales
Contribution %               Share of total sales
Customer Profit Margin %     Profit divided by sales per customer
Last Purchase Date           Latest order date


REPORT PAGES

MAIN PAGE: DASHBOARD (1280 x 720)
  - KPI cards: Total Sales, Total Profit, Profit Margin, Target Achieved %,
    Total Quantity
  - Trend of sales over time (line chart)
  - Sales vs Target (gauge)
  - Region sales and profit (clustered bar)
  - Top 5 Products and Top 5 Customers (bar charts)
  - Quantity vs Profit (scatter)
  - Order Date slicer

DRILL-THROUGH PAGES
  - Product Performance (right-click a product): product name, monthly sales
    trend, total profit, quantity, region-wise sales, sales rank.
  - Customer Insight (right-click a customer): customer name, segment, region,
    total profit, profit margin, sales history, product-wise purchases.

TOOLTIP PAGE
  - Quick Insight Tooltip: YoY growth, product rank, contribution %,
    last purchase date, mini sales trend.

QUESTION PAGES (one visual each)
  Highest-sales region, two-year monthly trend, top 5 customers, category with
  highest margin, quarterly target %, quantity vs profit, sales-drop month,
  most profitable segment. There are also KPI, Top 5, Region, Target, Trend
  and Filters pages.


KEY RESULTS

Total sales      $2.30M
Total profit     $286K
Profit margin    12.5%
Units sold       37,873
Sales growth     2015: -2.8%   2016: +29.5%   2017: +20.4%


ANSWERS TO THE PROJECT QUESTIONS

1. Region with the highest sales
   West: $725K (31.6% of total)

2. Monthly sales trend, last two years
   Rising: $609K (2016) to $733K (2017); peaks in November and December

3. Top 5 customers by revenue
   Sean Miller ($25.0K), Tamara Chand ($19.1K), Raymond Buch ($15.1K),
   Tom Ashbrook ($14.6K), Adrian Barton ($14.5K)

4. Category with the highest profit margin
   Technology: 17.4% (Office Supplies 17.0%, Furniture 2.5%)

5. Target achieved this quarter
   Q4 2017: 100.2%

6. Quantity vs profit correlation
   Weak (r = 0.07); sales vs profit is r = 0.48

7. Month with a significant drop
   April 2017: -47.7% vs March (December 2017: -36.2%)

8. Most profitable segment
   Home Office: 14.0% margin (Corporate 13.0%, Consumer 11.5%)



