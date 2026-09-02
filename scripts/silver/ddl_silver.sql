IF OBJECT_ID ('silver.olist_customers', 'U') IS NOT NULL
    DROP TABLE silver.olist_customers;
GO

CREATE TABLE silver.olist_customers (
    customer_id NVARCHAR(50),
    customer_unique_id NVARCHAR(50),
    customer_zip_code_prefix NVARCHAR(20),
    customer_city NVARCHAR(100),
    customer_state NVARCHAR(10),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID ('silver.olist_geolocation', 'U') IS NOT NULL
    DROP TABLE silver.olist_geolocation;
GO

CREATE TABLE silver.olist_geolocation (
    geolocation_zip_code_prefix NVARCHAR(20),
    geolocation_lat NVARCHAR(50),
    geolocation_lng NVARCHAR(50),
    geolocation_city NVARCHAR(100),
    geolocation_state NVARCHAR(10),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID ('silver.olist_order_items', 'U') IS NOT NULL
    DROP TABLE silver.olist_order_items;
GO

CREATE TABLE silver.olist_order_items (
    order_id NVARCHAR(50),
    order_item_id NVARCHAR(50),
    product_id NVARCHAR(50),
    seller_id NVARCHAR(50),
    shipping_limit_date NVARCHAR(50),
    price NVARCHAR(50),
    freight_value NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID ('silver.olist_order_payments', 'U') IS NOT NULL
    DROP TABLE silver.olist_order_payments;
GO

CREATE TABLE silver.olist_order_payments (
    order_id NVARCHAR(50),
    payment_sequential NVARCHAR(50),
    payment_type NVARCHAR(50),
    payment_installments NVARCHAR(50),
    payment_value NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID ('silver.olist_order_reviews', 'U') IS NOT NULL
    DROP TABLE silver.olist_order_reviews;
GO

CREATE TABLE silver.olist_order_reviews (
    review_id NVARCHAR(50),
    order_id NVARCHAR(50),
    review_score NVARCHAR(50),
    review_comment_title NVARCHAR(255),
    review_comment_message NVARCHAR(MAX),
    review_creation_date NVARCHAR(50),
    review_answer_timestamp NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID ('silver.olist_orders', 'U') IS NOT NULL
    DROP TABLE silver.olist_orders;
GO

CREATE TABLE silver.olist_orders (
    order_id NVARCHAR(50),
    customer_id NVARCHAR(50),
    order_status NVARCHAR(50),
    order_purchase_timestamp NVARCHAR(50),
    order_approved_at NVARCHAR(50),
    order_delivered_carrier_date NVARCHAR(50),
    order_delivered_customer_date NVARCHAR(50),
    order_estimated_delivery_date NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID ('silver.olist_products', 'U') IS NOT NULL
    DROP TABLE silver.olist_products;
GO

CREATE TABLE silver.olist_products (
    product_id NVARCHAR(50),
    product_category_name NVARCHAR(100),
    product_name_lenght NVARCHAR(50),
    product_description_lenght NVARCHAR(50),
    product_photos_qty NVARCHAR(50),
    product_weight_g NVARCHAR(50),
    product_length_cm NVARCHAR(50),
    product_height_cm NVARCHAR(50),
    product_width_cm NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID ('silver.olist_sellers', 'U') IS NOT NULL
    DROP TABLE silver.olist_sellers;
GO

CREATE TABLE silver.olist_sellers (
    seller_id NVARCHAR(50),
    seller_zip_code_prefix NVARCHAR(20),
    seller_city NVARCHAR(100),
    seller_state NVARCHAR(10),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID ('silver.product_category_name_translation', 'U') IS NOT NULL
    DROP TABLE silver.product_category_name_translation;
GO

CREATE TABLE silver.product_category_name_translation (
    product_category_name NVARCHAR(100),
    product_category_name_english NVARCHAR(100),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO