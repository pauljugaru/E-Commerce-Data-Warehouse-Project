CREATE OR ALTER VIEW gold.dim_customers AS
SELECT
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
FROM
(
    SELECT
        c.customer_unique_id,
        c.customer_zip_code_prefix,
        c.customer_city,
        c.customer_state,
        ROW_NUMBER() OVER
        (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp DESC
        ) AS rn
    FROM silver.olist_customers c
    LEFT JOIN silver.olist_orders o
        ON c.customer_id = o.customer_id
) t
WHERE rn = 1;


CREATE OR ALTER VIEW gold.dim_geolocation AS
SELECT 
    geolocation_zip_code_prefix,
    AVG(geolocation_lat) AS geolocation_lat,
    AVG(geolocation_lng) AS geolocation_lng,
    MAX(geolocation_city) AS geolocation_city,
    MAX(geolocation_state) AS geolocation_state
FROM silver.olist_geolocation
GROUP BY geolocation_zip_code_prefix;


CREATE OR ALTER VIEW gold.dim_sellers AS
SELECT
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
FROM silver.olist_sellers;


CREATE OR ALTER VIEW gold.dim_products AS
SELECT 
    p.product_id,
    p.product_category_name,
    t.product_category_name_english,
    p.product_name_length,
    p.product_description_length,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm    
FROM silver.olist_products p
LEFT JOIN silver.product_category_name_translation t
ON p.product_category_name = t.product_category_name;


CREATE OR ALTER VIEW gold.fact_sales AS
SELECT 
    oi.order_id,
    oi.order_item_id,
    c.customer_unique_id,
    oi.product_id,
    oi.seller_id,
    oi.price,
    oi.freight_value,
    CAST(oi.price + oi.freight_value AS DECIMAL(15,2)) AS total_value,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    oi.shipping_limit_date
FROM silver.olist_order_items oi
LEFT JOIN silver.olist_orders o
ON oi.order_id = o.order_id
LEFT JOIN silver.olist_customers c
ON o.customer_id = c.customer_id;


CREATE OR ALTER VIEW gold.fact_payments AS 
SELECT
    p.order_id,
    p.payment_sequential,
    c.customer_unique_id,
    p.payment_type,
    p.payment_installments,
    p.payment_value
FROM silver.olist_order_payments p
LEFT JOIN silver.olist_orders o
ON p.order_id = o.order_id
LEFT JOIN silver.olist_customers c
ON o.customer_id = c.customer_id


CREATE OR ALTER VIEW gold.fact_reviews AS
SELECT 
    r.review_id,
    r.order_id,
    c.customer_unique_id,
    r.review_score,
    r.review_comment_title,
    r.review_comment_message,
    r.review_creation_date,
    r.review_answer_timestamp
FROM silver.olist_order_reviews r
LEFT JOIN silver.olist_orders o
    ON r.order_id = o.order_id
LEFT JOIN silver.olist_customers c
    ON o.customer_id = c.customer_id;