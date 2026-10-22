-- =============================================
-- Juel Antonio Teixeira Baptista
-- October 16, 2026
-- =============================================


-- Normal run down to see whether data loaded and data cleaned macths up (size wise)
-- Row counts and key uniqueness for every clean table.
-- Order [[schema -> laodFiles -> clean -> data_quality]]
-- ============================================================


-- Check The data 
/*
select count(*) from brasil_ecommerce.customers;
select count(*) from brasil_ecommerce.geolocations;
select count(*) from brasil_ecommerce.order_items;
select count(*) from brasil_ecommerce.order_payments;
select count(*) from brasil_ecommerce.order_reviews;
select count(*) from brasil_ecommerce.orders;
select count(*) from brasil_ecommerce.products;
select count(*) from brasil_ecommerce.sellers;
select count(*) from brasil_ecommerce.product_translated_to_english;
*/

SELECT '=== row counts ===' AS section;

SELECT 'orders' AS tbl, COUNT(*) AS rows FROM clean.orders
UNION ALL SELECT 'order_items',      COUNT(*) FROM clean.order_items
UNION ALL SELECT 'order_payments',   COUNT(*) FROM clean.order_payments
UNION ALL SELECT 'order_reviews',    COUNT(*) FROM clean.order_reviews
UNION ALL SELECT 'customers',        COUNT(*) FROM clean.customers
UNION ALL SELECT 'products',         COUNT(*) FROM clean.products
UNION ALL SELECT 'sellers',          COUNT(*) FROM clean.sellers
UNION ALL SELECT 'geolocation',      COUNT(*) FROM clean.geolocations
UNION ALL SELECT 'category_translation', COUNT(*) FROM clean.product_translated_to_english;

-- ============================================================
SELECT '=== key uniqueness (total should equal unique) ===' AS section;

SELECT 'orders' AS tbl,
       COUNT(*) AS total,
       COUNT(DISTINCT order_id) AS unique_key
FROM clean.orders
UNION ALL
SELECT 'order_reviews',
       COUNT(*),
       COUNT(DISTINCT review_id)
FROM clean.order_reviews
UNION ALL
SELECT 'order_items',
       COUNT(*),
       COUNT(DISTINCT (order_id, order_item_id))
FROM clean.order_items
UNION ALL
SELECT 'order_payments',
       COUNT(*),
       COUNT(DISTINCT (order_id, payment_sequential))
FROM clean.order_payments
UNION ALL
SELECT 'customers',
       COUNT(*),
       COUNT(DISTINCT customer_id)
FROM clean.customers
UNION ALL
SELECT 'products',
       COUNT(*),
       COUNT(DISTINCT product_id)
FROM clean.products
UNION ALL
SELECT 'sellers',
       COUNT(*),
       COUNT(DISTINCT seller_id)
FROM clean.sellers;

-- ============================================================
SELECT '=== missing values ===' AS section;

SELECT 'orders missing delivery date' AS check_name,
       COUNT(*) FILTER (WHERE order_delivered_customer_date IS NULL) AS n,
       ROUND(100.0 * COUNT(*) FILTER (WHERE order_delivered_customer_date IS NULL) / COUNT(*), 2) AS pct
FROM clean.orders

UNION ALL

SELECT 'orders missing approval date',
       COUNT(*) FILTER (WHERE order_approved_at IS NULL),
       ROUND(100.0 * COUNT(*) FILTER (WHERE order_approved_at IS NULL) / COUNT(*), 2)
FROM clean.orders

UNION ALL

SELECT 'reviews with no comment',
       COUNT(*) FILTER (WHERE review_comment_message IS NULL),
       ROUND(100.0 * COUNT(*) FILTER (WHERE review_comment_message IS NULL) / COUNT(*), 2)
FROM clean.order_reviews;


-- An overeview of the orders.
select order_status, count(*) as orders,
    count(*) filter (where order_delivered_customer_date is null) as missing_delivery
from clean.orders
group by order_status
order by orders desc;

