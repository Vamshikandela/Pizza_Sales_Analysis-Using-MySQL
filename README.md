# 🍕 Pizza Sales Analysis Using SQL
- ![Uploading image.png…]()

## 📌 Project Overview

This project focuses on analyzing pizza sales data using SQL to extract meaningful business insights.
The analysis answers key business questions related to revenue, order behavior, pizza performance, and customer purchasing patterns.

## 🧩 Business Problem

A pizza restaurant chain collects large volumes of transactional sales data every day, but raw data alone does not support decision-making.

The business faces challenges such as:

Identifying which pizzas contribute most to total revenue

Understanding customer order size and purchasing behavior

Tracking daily sales trends to optimize inventory and staffing

Determining which pizza sizes perform best on average

Making data-driven decisions for pricing, promotions, and menu optimization

Without structured analysis, these decisions rely on assumptions rather than insights.

## 🎯 Project Objectives

Analyze overall sales performance

Identify top and bottom performing pizzas

Calculate revenue contribution (%) by pizza

Measure average order size (pizzas per order)

Evaluate average daily sales by pizza size

Support business decisions using SQL-driven insights

## 🗂️ Dataset Description

The dataset consists of multiple relational tables:

orders – Order-level details (order ID, date, time)

order_details – Pizza-level order quantities

pizzas – Pizza size and price information

pizza_types – Pizza names and categories

## 🧠 Key SQL Concepts Used

- **JOIN (INNER JOIN)**

- **Aggregate functions (SUM, AVG, COUNT)**

- **Subqueries**

- **Grouping (GROUP BY)**

- **Sorting (ORDER BY)**

- **Date-based analysis**


## 📊 Business Questions Answered

What is the total revenue generated?

Which pizzas contribute the highest revenue?

What percentage of total revenue does each pizza generate?

What is the average number of pizzas per order?

How many pizzas are sold per day on average?

Which pizza sizes perform best daily?

## 🧮 Sample SQL Queries
Average Order Size (Pizzas per Order)
SELECT 
    ROUND(AVG(total_pizzas), 2) AS avg_pizzas_per_order
FROM (
    SELECT 
        o.order_id,
        SUM(od.quantity) AS total_pizzas
    FROM orders o
    JOIN order_details od 
        ON o.order_id = od.order_id
    GROUP BY o.order_id
) order_totals;

Average Pizzas Sold Per Day by Size
SELECT 
    size,
    ROUND(AVG(daily_pizzas), 2) AS avg_pizzas_per_day
FROM (
    SELECT 
        o.order_date,
        p.size,
        SUM(od.quantity) AS daily_pizzas
    FROM orders o
    JOIN order_details od 
        ON o.order_id = od.order_id
    JOIN pizzas p 
        ON p.pizza_id = od.pizza_id
    GROUP BY o.order_date, p.size
) daily_size_sales
GROUP BY size
ORDER BY avg_pizzas_per_day DESC;

## 🛠️ Tools & Technologies

- **SQL (MySQL)**

- **MySQL Workbench**

- **GitHub**

## 📈 Insights Gained

Large-sized pizzas generate the highest average daily sales

A small subset of pizzas contributes a major share of revenue

Average order size helps forecast demand and manage inventory

Daily sales patterns assist in staffing and supply planning

## 🚀 Future Enhancements

Power BI / Tableau dashboard integration

Category-wise and time-based trend analysis

Promotional impact analysis

Predictive sales forecasting

## 📬 Contact

- **Author: Kandela Vamshi**
- **📧 Open to feedback, collaboration, and opportunities**
