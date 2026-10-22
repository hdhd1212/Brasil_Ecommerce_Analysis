/*
-- Juel Antonio Teixeira Baptista
-- October 16, 2026
--
*/

-- =====================================================================
-- [Question 1]
--  What payment types are most common and do they differ in order value
-- How does order value differ by payment type?"
-- [Result]
--  Credit card most common (74975) orders and a avg order value of (167)
--  Debit card least common with (1527) and an order value of (143)
-- =====================================================================

SELECT '=== most common payment type and their order value ===' AS section;
WITH order_totals AS (
    SELECT
        order_id,
        SUM(payment_value) AS order_value,
        -- the "main" payment type = the one with the largest value
        (ARRAY_AGG(payment_type ORDER BY payment_value DESC))[1] AS main_payment_type
    FROM clean.order_payments
    GROUP BY order_id
)
SELECT
    main_payment_type,
    COUNT(*)                        AS n_orders,
    round(avg(order_value)::numeric, 2)      AS avg_order_value,
    round(min(order_value)::numeric, 2)      AS min_value,
    round(max(order_value)::numeric, 2)      AS max_value
FROM order_totals
GROUP BY main_payment_type
ORDER BY avg_order_value DESC;

-- =========================================================
-- [Question 2]
--  Which product categories drives the most revenue.
-- [Answer]
-- healthy beauty, watches gifts, bed bath table generated
--         the most revenue with each crossing the 100 Million
--=============================================================

select '=== Products category that generated the most revenue ===' as section;

SELECT
    COALESCE(t.product_category_name_english, p.product_category_name) AS category,
    COUNT(DISTINCT oi.order_id)              AS n_orders,
    COUNT(*)                                 AS n_items,
    ROUND(SUM(oi.price)::numeric, 2)         AS total_revenue,
    ROUND(AVG(oi.price)::numeric, 2)         AS avg_item_price
FROM clean.order_items oi
JOIN clean.products p
  ON oi.product_id = p.product_id
LEFT JOIN clean.product_translated_to_english t
  ON p.product_category_name = t.product_category_name
GROUP BY COALESCE(t.product_category_name_english, p.product_category_name)
ORDER BY total_revenue DESC
LIMIT 10;


-- =============================================================
-- [Question 3]
-- Does late delivery hurt review score
-- [Answer]
-- Late delivery reviews avg(2.5) vs on time delivery reviews avg(4.3)
-- ===================================================================
select '=== Does late product hurt review score ===' as section;

SELECT
    orders.order_id,
    orders.order_status,
    orders.order_estimated_delivery_date,
    orders.order_delivered_customer_date,
    orders.order_delivered_customer_date - orders.order_estimated_delivery_date AS delay,
    order_reviews.score
FROM clean.orders
JOIN clean.order_reviews
ON orders.order_id = order_reviews.order_id
WHERE orders.order_status = 'delivered'
  AND orders.order_delivered_customer_date IS NOT NULL
  AND orders.order_estimated_delivery_date  IS NOT NULL
  AND orders.order_delivered_customer_date > orders.order_estimated_delivery_date  + INTERVAL '1 day'
ORDER BY delay DESC
LIMIT 10;

-- =========================================================
-- [Question 4]
-- What is the monthly order trend
-- [Answer]
-- Only 3 months in 2016. 2017 showed a steady growth. 
-- And a bigger growth in 2018 in comparison with 2017.
-- =====================================================

select '=== What is the monthly order trend? ===' as section;

select
    date_trunc('month', order_purchase_timestamp)::date as month,
    to_char(order_purchase_timestamp, 'YYYY-MM') as month_label,
    count(*) as number_of_orders
from clean.orders
group by date_trunc('month', order_purchase_timestamp), to_char(order_purchase_timestamp, 'YYYY-MM')
order by month
limit 12;

-- =================================================
-- [Question 5]
-- Do repeat customer spend more than one time buyer?
-- [Answer]
-- Yes repeat customers spend more on average(262) but one time buyer
--   contribute more to the total made
-- ==================================================
select '=== Do repeat customer spend more than one time buyer ===' as section;

WITH customer_stats AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id)      AS n_orders,
        SUM(oi.price)                   AS total_spent
    FROM clean.customers c
    JOIN clean.orders o       ON c.customer_id = o.customer_id
    JOIN clean.order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
)
SELECT
    CASE WHEN n_orders > 1 THEN 'repeat' ELSE 'one_time' END AS customer_type,
    COUNT(*)                                    AS n_customers,
    ROUND(AVG(total_spent)::numeric, 2)         AS avg_total_spent,
    round(sum(total_spent)::numeric, 2)         as totalspent
FROM customer_stats
GROUP BY customer_type;

