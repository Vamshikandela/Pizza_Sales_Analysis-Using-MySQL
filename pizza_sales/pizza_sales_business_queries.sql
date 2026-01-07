 -- Analysis & Queries
-- 1. Orders Volume Analysis
-- Total unique orders, orders by month,
-- orders by date
SELECT 
    COUNT(distinct(order_id)) total_orders, order_date
FROM
    orders
    group by(order_date);
    -- monthly orders
    SELECT 
    MONTH(order_date) month,
    COUNT(DISTINCT (order_id)) total_orders
FROM
    orders
GROUP BY MONTH(order_date);
   

-- 2. Total Revenue from Pizza Sales
-- Calculate total revenue from all pizza sales.
SELECT 
    SUM(od.quantity * p.price) AS total_revenue
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id;



-- 3. Highest-Priced Pizza
-- Identify the most expensive pizza on the menu.
SELECT 
    pizza_id , pizza_type_id pizza, price
FROM
    pizzas
ORDER BY (price) DESC
LIMIT 1;

-- 4. Most Common Pizza Size Ordered
-- Determine the most frequently ordered pizza size.
SELECT 
     p.size, COUNT(od.order_id) total_orders
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY (p.size)
ORDER BY total_orders desc
LIMIT 1;




-- 5. Top 5 Most Ordered Pizza Types
-- Find the top 5 pizza types based on quantity sold.
SELECT 
    p.pizza_type_id,
    pt.name pizza_type,
    SUM(od.quantity) quantity_sold
FROM
    pizzas p
        JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY (pt.pizza_type_id)
ORDER BY quantity_sold DESC
LIMIT 5;
-- 6. Total Quantity by Pizza Category
-- Calculate total pizzas sold in each category.

-- first way
SELECT 
    pt.category, SUM(od.quantity) total_pizzas_sold
FROM
    pizza_types pt
        JOIN
    pizzas p ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY (pt.category);

-- another way
SELECT 
    pt.category, COUNT(p.pizza_id) total_pizzas_sold
FROM
    pizza_types pt
        JOIN
    pizzas p ON p.pizza_type_id = pt.pizza_type_id
GROUP BY (pt.category);

-- 7. Orders by Hour of the Day
-- Understand peak ordering hours to optimize staffing.
SELECT 
    HOUR(order_time) hour_in_day, COUNT(order_id) total_orders
FROM
    orders
GROUP BY HOUR(order_time)
order by total_orders desc limit 1;

-- in a day 18 hour or 6 pm having more orders
-- 18 or 6 hour has 21 orders


-- 8. Category-Wise Pizza Distribution
-- Analyze category-wise sales and percentage share.
select pt.category,sum(od.quantity) total_orders from pizza_types pt
join pizzas p on p.pizza_type_id=pt.pizza_type_id
join order_details od on od.pizza_id=p.pizza_id
group by(pt.category) 
order by total_orders desc;
-- here category classic has highest orders 91 all the category 
 
-- total orders by category
select pt.category , sum(od.quantity) total_orders from pizza_types pt
join pizzas p on p.pizza_type_id=pt.pizza_type_id
join order_details od on od.pizza_id=p.pizza_id
group by(pt.category) 
order by total_orders desc;

-- category-wise percentage share
-- category orders/total orders
SELECT 
    pt.category,
    SUM(od.quantity) total_orders,
    ROUND(SUM(od.quantity) * 100.0 / (SELECT 
                    SUM(od.quantity)
                FROM
                    order_details od),
            2) AS percentage_share
FROM
    pizza_types pt
        JOIN
    pizzas p ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY (pt.category)
ORDER BY total_orders DESC;




-- 9. Average Pizzas Ordered per Day
-- Measure daily pizza demand consistency.
SELECT 
    round(avg(total_sales),2) AS avg_orders_day
FROM
    (SELECT 
        o.order_date, SUM(od.quantity) total_sales
    FROM
        orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY (o.order_date)) daily_sales;


-- 10. Top 3 Pizzas by Revenue
-- Identify pizzas generating the highest revenue.
SELECT 
    pt.name pizza,
    ROUND(SUM(p.price * od.quantity), 2) total_revenue
FROM
    pizzas p
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.name 
ORDER BY total_revenue DESC
LIMIT 3;

-- 11. Revenue Contribution per Pizza
-- Percentage contribution of each pizza to total revenue.
select * from pizza_types;
select * from order_details;
select * from pizzas;

SELECT 
    pt.name,sum(od.quantity*p.price) as revenue,
    ROUND(SUM(od.quantity * p.price) / (SELECT 
                    SUM(od2.quantity * p2.price)
                FROM
                    order_details od2
                        JOIN
                    pizzas p2 ON od2.pizza_id = p2.pizza_id) * 100,
            2) AS 'Contribution to revenue(%)'
FROM
    pizza_types pt
        JOIN
    pizzas p ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.name
ORDER BY revenue DESC; 



-- 12. Cumulative Revenue Over Time
-- Monthly cumulative revenue trend since launch.
select * from orders;
select * from order_details; 
select * from pizza_types;
select * from pizzas;
select o.order_time,sum(p.price*od.quantity) Revenue from order_details od 
join  orders o on o.order_id=od.order_id
join pizzas p on p.pizza_id=od.pizza_id
where hour(o.order_time)>=12
group by o.order_time
order by revenue desc;
-- 13. Top 3 Pizzas by Category (Revenue-Based)
-- Top 3 pizzas by revenue in each category.
SELECT 
    pt.category, SUM(p.price * od.quantity) revenue
FROM
    pizzas p
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.category
ORDER BY revenue DESC
LIMIT 3;

-- top 3 supreme(1376.75) ,classic(1341.50),chicken(1131.25) by hishest revenue generated 
-- 14. Average Order Size
-- Calculate average number of pizzas per order.
SELECT 
   size, ceil(avg(total_sales)) AS avg_orders_day
FROM
    (SELECT 
        o.order_date, p.size,SUM(od.quantity) total_sales
    FROM
        orders o
    JOIN order_details od ON o.order_id = od.order_id
    join pizzas p on p.pizza_id=od.pizza_id
    GROUP BY o.order_date,p.size) daily_sales
    group by size
    order by avg_orders_day desc;
-- the avg_oders is high by l size pizza per day 
    




-- 15. Revenue by Pizza Size
-- Revenue contribution of each pizza size (S, M, L, XL, XXL).
select p.size , sum(od.quantity*p.price) revenue from pizzas p 
join order_details od on p.pizza_id=od.pizza_id
group by p.size
order by revenue desc;

-- the Highest revenue is generated L size pizza 2727.75 total revenue
