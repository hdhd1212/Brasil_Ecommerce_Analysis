/*
-- Juel Antonio Teixeira Baptista
-- October 15, 2026
-- Cleaning.
*/

/*
-- [1]  The first is types. As I have everything as a [Text] I want to convert some of them.
-- [2]  Also I want to find empty string '' and make sure they are [NULL]
-- [3]  Carefully working with duplicates in many cases.
-- [4]  Rows where ID dont exist anywhere else.
-- [5]  Values that does not behave as I want.
-- [6]  Text that are anomalies.
*/


-- [1]
-- create a new table and assign with data type into them.
-- Chaning some names if necessary.
-- Using [nullif] to handle empty strings/values.

create schema if not exists clean;
create table clean.customers as
select
    customer_id, 
    customer_unique_id,
    nullif(customer_zip_code_prefix, '')::integer as customer_zip_code,
    customer_city,
    customer_state
from brasil_ecommerce.olist_customers_dataset;


-- [3.3]
-- Geolocation Duplicates.
-- [Not really a problem as mutiple data can be available for same zip]

create table clean.geolocations as
select
    nullif(geolocation_zip_code_prefix, '')::integer                as geo_zipcode,
    nullif(geolocation_lat, '')             ::double precision       as geo_latitude,
    nullif(geolocation_lng, '')             ::double precision       as geo_longitude,
    geolocation_city,                                    
    geolocation_state                                
from brasil_ecommerce.olist_geolocation_dataset;

create table clean.order_items as
select
    order_id,    
    order_item_id,
    product_id,
    seller_id,
    nullif(shipping_limit_date, '')::timestamp as shipping_limit_date,
    nullif(price, '')::double precision as price,
    nullif(freight_value, '')::double precision as freight_value
from brasil_ecommerce.olist_order_items_dataset;

create table clean.order_payments as
select
    order_id,
    payment_sequential,
    payment_type,
    nullif(payment_installments, '')::double precision as payment_installments,
    nullif(payment_value, '')::double precision as payment_value
from brasil_ecommerce.olist_order_payments_dataset;

-- [3.3]
-- to remove duplicattes.

create table clean.order_reviews as
select
    review_id,
    order_id,
    nullif(review_score, '')::double precision as score,
    review_comment_title,
    review_comment_message,
    nullif(review_creation_date, '')::timestamp as review_creation_date,
    nullif(review_answer_timestamp, '')::timestamp as review_answer_timestamp
from (
    select *,
        row_number() over (
            partition by review_id
            order by review_answer_timestamp desc
        ) as rn
    from brasil_ecommerce.olist_order_reviews_dataset
) t
where rn = 1;
 
create table clean.orders as
select
    order_id, 
    customer_id,
    order_status,
    nullif(order_purchase_timestamp, '')::timestamp as order_purchase_timestamp,
    nullif(order_approved_at, '')::timestamp as order_approved_at,
    nullif(order_delivered_carrier_date, '')::timestamp as order_delivered_carrier_date,
    nullif(order_delivered_customer_date, '')::timestamp as order_delivered_customer_date,
    nullif(order_estimated_delivery_date, '')::timestamp as order_estimated_delivery_date
from brasil_ecommerce.olist_orders_dataset;

create table clean.products as
select
    product_id,
    product_category_name,
    nullif(product_name_length, '')::integer as product_name_length,
    product_description_length,
    product_photos_qty,
    nullif(product_weight_g, '')::integer as product_weight_g, 
    nullif(product_height_cm, '')::double precision as product_height_cm,
    nullif(product_width_cm, '')::integer as product_width_cm
from brasil_ecommerce.olist_products_dataset;


-- [3.5]
-- sellers_id should be unique.
create table clean.sellers as 
select
    seller_id,
    nullif(seller_zip_code_prefix, '')::integer,
    seller_city,
    seller_state
from brasil_ecommerce.olist_sellers_dataset;

create table clean.product_translated_to_english as
select
    product_category_name,
    product_category_name_english
from brasil_ecommerce.product_category_name_translation;

