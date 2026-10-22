/*
-- October 15, 2026
-- Juel Antonio Teixeira Baptista
-- schema for working with the data.
*/
create schema brasil_ecommerce;

create table brasil_ecommerce.olist_customers_dataset(
    customer_id text,
    customer_unique_id text,
    customer_zip_code_prefix text,
    customer_city text,
    customer_state text
);
create table brasil_ecommerce.olist_geolocation_dataset(
    geolocation_zip_code_prefix text,
    geolocation_lat text,
    geolocation_lng text,
    geolocation_city text,
    geolocation_state text
);
create table brasil_ecommerce.olist_order_items_dataset(
    order_id text,
    order_item_id text,
    product_id text,
    seller_id text,
    shipping_limit_date text,
    price text,
    freight_value text

);
create table brasil_ecommerce.olist_order_payments_dataset(
    order_id text,
    payment_sequential text,
    payment_type text,
    payment_installments text,
    payment_value text

);
create table brasil_ecommerce.olist_order_reviews_dataset(
    review_id text,
    order_id text,
    review_score text,
    review_comment_title text,
    review_comment_message text,
    review_creation_date text,
    review_answer_timestamp text --timestamp

);
create table brasil_ecommerce.olist_orders_dataset(
    order_id text,
    customer_id text,
    order_status text,
    order_purchase_timestamp text, --timestamp,
    order_approved_at text, --timestamp,
    order_delivered_carrier_date text, --timestamp,
    order_delivered_customer_date text, --timestamp,
    order_estimated_delivery_date text --timestamp,
);
create table brasil_ecommerce.olist_products_dataset(
    product_id text,
    product_category_name text,
    product_name_length text,
    product_description_length text,
    product_photos_qty text,
    product_weight_g text,
    product_length_cm text,
    product_height_cm text,
    product_width_cm text
);
create table brasil_ecommerce.olist_sellers_dataset(
    seller_id text,
    seller_zip_code_prefix text,
    seller_city text,
    seller_state text
);
create table brasil_ecommerce.product_category_name_translation(
    product_category_name text, 
    product_category_name_english text
);

