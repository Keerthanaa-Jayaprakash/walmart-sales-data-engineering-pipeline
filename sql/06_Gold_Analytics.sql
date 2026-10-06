-- Databricks notebook source
-- ============================================================
-- Business Question 1: What is the overall sales performance?
-- ============================================================
-- This query calculates the key business KPIs for the
-- complete Walmart retail sales dataset.
--
-- Metrics:
--   total_orders          -> Number of sales transactions
--   total_sales           -> Total revenue generated
--   total_profit          -> Total profit generated
--   avg_profit_margin_pct -> Average profit margin
--   total_units_sold      -> Total quantity of products sold
-- ============================================================

SELECT
    COUNT(*) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(profit_margin_pct), 2) AS avg_profit_margin_pct,
    ROUND(SUM(order_quantity), 0) AS total_units_sold
FROM walmart_retail.sales.gold_fact_sales;

-- COMMAND ----------

-- ============================================================
-- Business Question 2: Which product categories drive
-- sales and profitability?
-- ============================================================
-- This query compares revenue, profit, units sold, and
-- average profit margin across product categories.
--
-- The results help identify:
--   - Highest-revenue categories
--   - Most profitable categories
--   - Categories with weaker margins
-- ============================================================

SELECT
    p.product_category,
    COUNT(*) AS total_orders,
    ROUND(SUM(f.sales), 2) AS total_sales,
    ROUND(SUM(f.profit), 2) AS total_profit,
    SUM(f.order_quantity) AS total_units_sold,
    ROUND(AVG(f.profit_margin_pct), 2) AS avg_profit_margin_pct
FROM walmart_retail.sales.gold_fact_sales f
JOIN walmart_retail.sales.gold_dim_product p
    ON f.product_key = p.product_key
GROUP BY
    p.product_category
ORDER BY
    total_sales DESC;

-- COMMAND ----------

-- ============================================================
-- Business Question 3: Which regions generate the most
-- sales and profit?
-- ============================================================
-- This query analyzes sales performance by geographic region.
--
-- Metrics:
--   total_orders          -> Number of sales transactions
--   total_sales           -> Revenue generated
--   total_profit          -> Profit generated
--   total_units_sold      -> Quantity sold
--   profit_margin_pct     -> Overall profit margin for the region
--
-- The results help identify strong and weak-performing regions.
-- ============================================================

SELECT
    l.region,
    COUNT(*) AS total_orders,
    ROUND(SUM(f.sales), 2) AS total_sales,
    ROUND(SUM(f.profit), 2) AS total_profit,
    SUM(f.order_quantity) AS total_units_sold,
    ROUND(
        SUM(f.profit) / NULLIF(SUM(f.sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM walmart_retail.sales.gold_fact_sales f
JOIN walmart_retail.sales.gold_dim_location l
    ON f.location_key = l.location_key
GROUP BY
    l.region
ORDER BY
    total_sales DESC;

-- COMMAND ----------

-- ============================================================
-- Business Question 4: How do sales and profit change over
-- time?
-- ============================================================
-- A Year-Month field is created so the dashboard can display
-- the sales trend in chronological order.
-- ============================================================

SELECT
    d.year,
    d.month,
    CONCAT(
        CAST(d.year AS STRING),
        '-',
        LPAD(CAST(d.month AS STRING), 2, '0')
    ) AS year_month,
    COUNT(*) AS total_orders,
    ROUND(SUM(f.sales), 2) AS total_sales,
    ROUND(SUM(f.profit), 2) AS total_profit,
    SUM(f.order_quantity) AS total_units_sold,
    ROUND(
        SUM(f.profit) / NULLIF(SUM(f.sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM walmart_retail.sales.gold_fact_sales f
JOIN walmart_retail.sales.gold_dim_date d
    ON f.date_key = d.date_key
GROUP BY
    d.year,
    d.month
ORDER BY
    d.year,
    d.month;

-- COMMAND ----------

-- ============================================================
-- Business Question 5: Which products generate the most sales?
-- ============================================================
-- This query identifies the top 10 products based on total
-- sales and also shows their profitability.
--
-- The results help identify:
--   - Highest-revenue products
--   - Best-selling product categories
--   - Whether high sales also translate into profit
-- ============================================================

SELECT
    p.product_name,
    p.product_category,
    p.product_sub_category,
    ROUND(SUM(f.sales), 2) AS total_sales,
    ROUND(SUM(f.profit), 2) AS total_profit,
    SUM(f.order_quantity) AS total_units_sold,
    ROUND(
        SUM(f.profit) / NULLIF(SUM(f.sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM walmart_retail.sales.gold_fact_sales f
JOIN walmart_retail.sales.gold_dim_product p
    ON f.product_key = p.product_key
GROUP BY
    p.product_name,
    p.product_category,
    p.product_sub_category
ORDER BY
    total_sales DESC
LIMIT 10;

-- COMMAND ----------

-- ============================================================
-- Business Question 6: Which customer segments generate the
-- most sales and profit?
-- ============================================================
-- This query compares business performance across customer
-- segments.
--
-- Metrics:
--   total_orders          -> Number of transactions
--   total_sales           -> Revenue generated
--   total_profit          -> Profit generated
--   total_units_sold      -> Quantity purchased
--   profit_margin_pct     -> Overall profit margin
--
-- This helps identify the most valuable customer segments.
-- ============================================================

SELECT
    c.customer_segment,
    COUNT(*) AS total_orders,
    ROUND(SUM(f.sales), 2) AS total_sales,
    ROUND(SUM(f.profit), 2) AS total_profit,
    SUM(f.order_quantity) AS total_units_sold,
    ROUND(
        SUM(f.profit) / NULLIF(SUM(f.sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM walmart_retail.sales.gold_fact_sales f
JOIN walmart_retail.sales.gold_dim_customer c
    ON f.customer_key = c.customer_key
GROUP BY
    c.customer_segment
ORDER BY
    total_sales DESC;

-- COMMAND ----------

-- ============================================================
-- Business Question 7: Which states generate the most sales?
-- ============================================================
-- This query ranks states based on total sales and shows
-- their corresponding profitability.
--
-- The results help identify:
--   - Highest-revenue states
--   - Strongest markets by profit
--   - States with lower or negative profitability
-- ============================================================

SELECT
    l.state,
    COUNT(*) AS total_orders,
    ROUND(SUM(f.sales), 2) AS total_sales,
    ROUND(SUM(f.profit), 2) AS total_profit,
    SUM(f.order_quantity) AS total_units_sold,
    ROUND(
        SUM(f.profit) / NULLIF(SUM(f.sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM walmart_retail.sales.gold_fact_sales f
JOIN walmart_retail.sales.gold_dim_location l
    ON f.location_key = l.location_key
GROUP BY
    l.state
ORDER BY
    total_sales DESC
LIMIT 10;

-- COMMAND ----------

-- ============================================================
-- Business Question 8: How does shipping performance vary
-- across shipping modes?
-- ============================================================
-- This query evaluates shipping modes using:
--   - Number of orders
--   - Shipping cost
--   - Average shipping time
--   - Total sales
--   - Total profit
--
-- This helps identify shipping modes that are frequently used
-- and their impact on operational performance.
-- ============================================================

SELECT
    f.ship_mode,
    COUNT(*) AS total_orders,
    ROUND(SUM(f.shipping_cost), 2) AS total_shipping_cost,
    ROUND(AVG(f.shipping_days), 2) AS avg_shipping_days,
    ROUND(SUM(f.sales), 2) AS total_sales,
    ROUND(SUM(f.profit), 2) AS total_profit
FROM walmart_retail.sales.gold_fact_sales f
GROUP BY
    f.ship_mode
ORDER BY
    total_orders DESC;

-- COMMAND ----------

-- ============================================================
-- Business Question 9: Which products are generating losses?
-- ============================================================
-- This query identifies products where total profit is
-- negative.
--
-- The results help identify:
--   - Loss-making products
--   - Revenue generated despite negative profitability
--   - Products that may require pricing or discount review
-- ============================================================

SELECT
    p.product_name,
    p.product_category,
    p.product_sub_category,
    ROUND(SUM(f.sales), 2) AS total_sales,
    ROUND(SUM(f.profit), 2) AS total_profit,
    SUM(f.order_quantity) AS total_units_sold,
    ROUND(
        SUM(f.profit) / NULLIF(SUM(f.sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM walmart_retail.sales.gold_fact_sales f
JOIN walmart_retail.sales.gold_dim_product p
    ON f.product_key = p.product_key
GROUP BY
    p.product_name,
    p.product_category,
    p.product_sub_category
HAVING
    SUM(f.profit) < 0
ORDER BY
    total_profit ASC
LIMIT 10;

-- COMMAND ----------

-- ============================================================
-- Business Question 10: What is the overall business summary?
-- ============================================================
-- This query provides the final executive-level KPIs from
-- the Gold fact table.
--
-- Metrics:
--   total_orders          -> Total transactions
--   total_sales           -> Total revenue
--   total_profit          -> Total profit
--   profit_margin_pct     -> Overall weighted profit margin
--   total_units_sold      -> Total quantity sold
--   avg_order_value       -> Average revenue per transaction
--   avg_shipping_days     -> Average delivery time
--
-- This provides a concise summary of the complete dataset.
-- ============================================================

SELECT
    COUNT(*) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct,
    SUM(order_quantity) AS total_units_sold,
    ROUND(
        SUM(sales) / NULLIF(COUNT(*), 0),
        2
    ) AS avg_order_value,
    ROUND(AVG(shipping_days), 2) AS avg_shipping_days
FROM walmart_retail.sales.gold_fact_sales;