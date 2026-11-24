# Retail Sales Performance and Customer Behaviour Analysis

## Overview

An interactive Power BI report that helps management see top-performing
products, profitable regions, customer segments, monthly sales trends, and
sales against target.

Live Preview [Sales Dashboard Preview](Dashboard.PNG)

## Dataset

Public dataset of 9,994 order lines,5,009 orders,793 customers based on 2 Jan 2014 to 30 Dec 2017

## Tools

- **Excel:** source dataset (Retail-Sales-Dataset.xlsx)
- **Python:** (pandas, matplotlib, seaborn) exploratory analysis and chart export (eda_analysis.py)
- **MySQL:** data-quality checks, aggregations, subqueries, window functions (Retail sales performace.sql)
- **Power BI (DAX):** KPI cards, gauge, slicer, drill-through and tooltip pages (Retail-sales.pbix)
- **PowerPoint:** summary presentation (Retail_Sales_presentation.pptx)

## Methodology

1. **Prepare (Excel):** loaded the full order dataset into one sheet with order, customer, location, and product fields.
2. **Validate (SQL):** checked total records, table structure, duplicate Row ID s, missing values, and date/quantity anomalies.
3. **Analyze (SQL):** ran GROUP BY aggregations, subqueries, CTEs, and window functions for regional/segment margins, product rankings, repeat customers, and YoY growth.
4. **Explore (Python):** grouped sales and profit by category, month, product, and customer, and plotted quantity against profit.
5. **Visualize (Power BI):** built a main dashboard, two drill-through pages (Product Performance, Customer Insight), a quick-insight tooltip page, and dedicated question views.


## Dashboard Pages

## Main Page: Dashboard
  - KPI cards: Total Sales, Total Profit, Profit Margin, Target Achieved %,
    Total Quantity
  - Trend of sales over time (line chart)
  - Sales vs Target (gauge)
  - Region sales and profit (clustered bar)
  - Top 5 Products and Top 5 Customers (bar charts)
  - Quantity vs Profit (scatter)
  - Order Date slicer

## Drill-Through Page
  - Product Performance (right-click a product): product name, monthly sales
    trend, total profit, quantity, region-wise sales, sales rank.
  - Customer Insight (right-click a customer): customer name, segment, region,
    total profit, profit margin, sales history, product-wise purchases.

## Tooltip Page
  - Quick Insight Tooltip: YoY growth, product rank, contribution %,
    last purchase date, mini sales trend.

## Key Results

Total sales      $2.30M
Total profit     $286K
Profit margin    12.5%
Units sold       37,873
Sales growth     2015: -2.8%   2016: +29.5%   2017: +20.4%




