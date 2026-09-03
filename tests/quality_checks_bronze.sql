-- ============================================
-- BRONZE LAYER - DATA QUALITY CHECKS
-- ============================================

-- Check for Nulls or Duplicates
SELECT
	customer_id,
	COUNT(*) AS record_count
FROM bronze.olist_customers
GROUP BY customer_id
HAVING COUNT(*) > 1 OR customer_id IS NULL;

SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state,
    COUNT(*) AS record_count
FROM bronze.olist_geolocation
GROUP BY
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
HAVING COUNT(*) > 1;

SELECT
    order_id,
    COUNT(*) AS record_count
FROM bronze.olist_orders
GROUP BY order_id
HAVING COUNT(*) > 1 OR order_id IS NULL;

SELECT 
    order_id
FROM bronze.olist_order_payments
WHERE order_id IS NULL;

SELECT 
    order_id
FROM bronze.olist_order_payments
WHERE payment_sequential IS NULL OR payment_value IS NULL; 

SELECT
    review_id
FROM bronze.olist_order_reviews
WHERE review_score IS NULL;

SELECT 
    order_id
FROM bronze.olist_orders
WHERE order_purchase_timestamp IS NULL;

SELECT 
    product_name_lenght AS product_name_length
FROM bronze.olist_products
WHERE product_name_lenght IS NULL

-- Check for Unwanted Spaces
SELECT 
	customer_city
FROM bronze.olist_customers
WHERE customer_city != TRIM(customer_city);

SELECT 
	customer_id
FROM bronze.olist_customers
WHERE customer_id != TRIM(customer_id);

SELECT 
	customer_unique_id
FROM bronze.olist_customers
WHERE customer_unique_id != TRIM(customer_unique_id);

SELECT 
	customer_state
FROM bronze.olist_customers
WHERE customer_state != TRIM(customer_state);

SELECT order_status
FROM bronze.olist_orders
WHERE order_status != TRIM(order_status);

SELECT
    review_id
FROM bronze.olist_order_reviews
WHERE review_id != TRIM(review_id);

SELECT
    order_id
FROM bronze.olist_order_reviews
WHERE order_id != TRIM(order_id);

SELECT 
    product_id,
    product_category_name
FROM bronze.olist_products
WHERE product_category_name != TRIM(product_category_name)

-- Check Data Standardization & Consistency
SELECT DISTINCT
	customer_state
FROM bronze.olist_customers;

SELECT DISTINCT
    geolocation_city
FROM bronze.olist_geolocation;

SELECT DISTINCT
	order_status
FROM bronze.olist_orders;

SELECT DISTINCT
	payment_type
FROM bronze.olist_order_payments;

SELECT DISTINCT
    seller_city
FROM bronze.olist_sellers
ORDER BY seller_city;


-- Check Invalid Lengths
SELECT
	customer_zip_code_prefix
FROM bronze.olist_customers
WHERE LEN(customer_zip_code_prefix) < 7 OR LEN(customer_zip_code_prefix) > 7;


-- Check Valid Ranges & Boundaries
SELECT
    geolocation_zip_code_prefix
FROM bronze.olist_geolocation
WHERE TRY_CAST(geolocation_lat AS FLOAT ) < -90 OR TRY_CAST(geolocation_lat AS FLOAT) > 90;

SELECT
    geolocation_zip_code_prefix
FROM bronze.olist_geolocation
WHERE TRY_CAST(geolocation_lng AS FLOAT ) < -180 OR TRY_CAST(geolocation_lat AS FLOAT) > 180;

SELECT
    review_id
FROM bronze.olist_order_reviews
WHERE review_score < 1 OR review_score > 10


-- Check Logical Consistency (Dates & Statuses)
SELECT 
    order_id
FROM bronze.olist_orders
WHERE order_purchase_timestamp > order_approved_at;

SELECT 
    order_id,
    order_approved_at,
    order_delivered_carrier_date 
FROM bronze.olist_orders
WHERE order_approved_at IS NULL AND  order_delivered_carrier_date IS NOT NULL ;


-- Check Specific Anomalies (Quotes)
SELECT
    order_id,
    price
FROM bronze.olist_order_items
WHERE order_id = '"2bcf1f79964f8b4f4f62f19441601b1a"';