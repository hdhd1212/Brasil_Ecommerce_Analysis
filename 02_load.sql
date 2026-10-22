--
-- Juel Teixeira Baptista
-- October 15, 2026
--


-- Load Files.
\copy brasil_ecommerce.olist_customers_dataset      from 'Archieve/olist_customers_dataset.csv' with (FORMAT csv, header true, NUll '');
\copy brasil_ecommerce.olist_geolocation_dataset    from 'Archieve/olist_geolocation_dataset.csv' with (FORMAT csv, header true, NULL '');
\copy brasil_ecommerce.olist_order_items_dataset    from 'Archieve/olist_order_items_dataset.csv' with (FORMAT csv, header true, NUll '');
\copy brasil_ecommerce.olist_order_payments_dataset from 'Archieve/olist_order_payments_dataset.csv' with (FORMAT csv, header true, NULL '');
\copy brasil_ecommerce.olist_order_reviews_dataset  from 'Archieve/olist_order_reviews_dataset.csv' with (FORMAT csv, header true, NUll '');
\copy brasil_ecommerce.olist_orders_dataset         from 'Archieve/olist_orders_dataset.csv' with (FORMAT csv, header true, NUll '');
\copy brasil_ecommerce.olist_products_dataset       from 'Archieve/olist_products_dataset.csv' with (FORMAT csv, header true, NULL '');
\copy brasil_ecommerce.olist_sellers_dataset        from 'Archieve/olist_sellers_dataset.csv' with (FORMAT csv, header true, NUll '');
\copy brasil_ecommerce.product_category_name_translation from 'Archieve/product_category_name_translation.csv' with (FORMAT csv, header true, NULL '');

