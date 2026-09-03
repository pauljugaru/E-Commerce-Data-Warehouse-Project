EXEC silver.load_silver;

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE 
        @start_time DATETIME,
        @end_time DATETIME,
        @start_total_time DATETIME,
        @end_total_time DATETIME;

    BEGIN TRY

        SET @start_total_time = GETDATE();

        PRINT '==============================================================';
        PRINT 'Loading Silver Layer';
        PRINT '==============================================================';

        PRINT '--------------------------------------------------------------';
        PRINT 'Loading Olist Tables';
        PRINT '--------------------------------------------------------------';


        -- =========================================================
        -- OLIST CUSTOMERS
        -- =========================================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.olist_customers';
        TRUNCATE TABLE silver.olist_customers;

        PRINT '>> Inserting Data Into: silver.olist_customers';

        INSERT INTO silver.olist_customers
        (
            customer_id,
            customer_unique_id,
            customer_zip_code_prefix,
            customer_city,
            customer_state
        )
        SELECT 
            TRIM('"' FROM customer_id) AS customer_id,
            TRIM('"' FROM customer_unique_id) AS customer_unique_id,
            TRIM('"' FROM customer_zip_code_prefix) AS customer_zip_code_prefix,
            customer_city,
            customer_state
        FROM bronze.olist_customers;

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '';


        -- =========================================================
        -- OLIST GEOLOCATION
        -- =========================================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.olist_geolocation';
        TRUNCATE TABLE silver.olist_geolocation;

        PRINT '>> Inserting Data Into: silver.olist_geolocation';

        INSERT INTO silver.olist_geolocation
        (
            geolocation_zip_code_prefix,
            geolocation_lat,
            geolocation_lng,
            geolocation_city,
            geolocation_state
        )
        SELECT DISTINCT
            TRIM('"' FROM geolocation_zip_code_prefix) AS geolocation_zip_code_prefix,

            TRY_CAST(geolocation_lat AS DECIMAL(9,6)) AS geolocation_lat,

            TRY_CAST(geolocation_lng AS DECIMAL(9,6)) AS geolocation_lng,

            LOWER(
                TRANSLATE(
                    TRIM('"' FROM geolocation_city),
                    N'áàâãäéèêëíìîïóòôõöúùûüç',
                    N'aaaaaeeeeiiiiooooouuuuc'
                )
            ) AS geolocation_city,

            CASE
                WHEN LEN(REPLACE(geolocation_state, '"', '')) > 2
                    THEN RIGHT(REPLACE(geolocation_state, '"', ''), 2)
                ELSE REPLACE(geolocation_state, '"', '')
            END AS geolocation_state

        FROM bronze.olist_geolocation;

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '';


        -- =========================================================
        -- OLIST ORDERS
        -- =========================================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.olist_orders';
        TRUNCATE TABLE silver.olist_orders;

        PRINT '>> Inserting Data Into: silver.olist_orders';

        INSERT INTO silver.olist_orders
        (
            order_id,
            customer_id,
            order_status,
            order_purchase_timestamp,
            order_approved_at,
            order_delivered_carrier_date,
            order_delivered_customer_date,
            order_estimated_delivery_date
        )
        SELECT 
            TRIM(' "' FROM order_id) AS order_id,
            TRIM(' "' FROM customer_id) AS customer_id,
            order_status,

            TRY_CAST(
                NULLIF(order_purchase_timestamp, '')
                AS DATETIME2
            ) AS order_purchase_timestamp,

            TRY_CAST(
                NULLIF(order_approved_at, '')
                AS DATETIME2
            ) AS order_approved_at,

            TRY_CAST(
                NULLIF(order_delivered_carrier_date, '')
                AS DATETIME2
            ) AS order_delivered_carrier_date,

            TRY_CAST(
                NULLIF(order_delivered_customer_date, '')
                AS DATETIME2
            ) AS order_delivered_customer_date,

            TRY_CAST(
                NULLIF(order_estimated_delivery_date, '')
                AS DATETIME2
            ) AS order_estimated_delivery_date

        FROM bronze.olist_orders;

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '';


        -- =========================================================
        -- OLIST ORDER ITEMS
        -- =========================================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.olist_order_items';
        TRUNCATE TABLE silver.olist_order_items;

        PRINT '>> Inserting Data Into: silver.olist_order_items';

        INSERT INTO silver.olist_order_items
        (
            order_id,
            order_item_id,
            product_id,
            seller_id,
            shipping_limit_date,
            price,
            freight_value
        )
        SELECT 
            TRIM(' "' FROM order_id) AS order_id,

            TRY_CAST(order_item_id AS INT) AS order_item_id,

            TRIM(' "' FROM product_id) AS product_id,

            TRIM(' "' FROM seller_id) AS seller_id,

            TRY_CAST(
                shipping_limit_date AS DATETIME2
            ) AS shipping_limit_date,

            TRY_CAST(
                NULLIF(price, '')
                AS DECIMAL(10,2)
            ) AS price,

            TRY_CAST(
                NULLIF(freight_value, '')
                AS DECIMAL(10,2)
            ) AS freight_value

        FROM bronze.olist_order_items;

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '';


        -- =========================================================
        -- OLIST ORDER PAYMENTS
        -- =========================================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.olist_order_payments';
        TRUNCATE TABLE silver.olist_order_payments;

        PRINT '>> Inserting Data Into: silver.olist_order_payments';

        INSERT INTO silver.olist_order_payments
        (
            order_id,
            payment_sequential,
            payment_type,
            payment_installments,
            payment_value
        )
        SELECT 
            TRIM(' "' FROM order_id) AS order_id,

            TRY_CAST(
                payment_sequential AS INT
            ) AS payment_sequential,

            payment_type,

            TRY_CAST(
                payment_installments AS INT
            ) AS payment_installments,

            TRY_CAST(
                payment_value AS DECIMAL(10,2)
            ) AS payment_value

        FROM bronze.olist_order_payments;

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '';


        -- =========================================================
        -- OLIST ORDER REVIEWS
        -- =========================================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.olist_order_reviews';
        TRUNCATE TABLE silver.olist_order_reviews;

        PRINT '>> Inserting Data Into: silver.olist_order_reviews';

        INSERT INTO silver.olist_order_reviews
        (
            review_id,
            order_id,
            review_score,
            review_comment_title,
            review_comment_message,
            review_creation_date,
            review_answer_timestamp
        )
        SELECT 
            review_id,
            order_id,

            TRY_CAST(
                review_score AS INT
            ) AS review_score,

            review_comment_title,
            review_comment_message,

            TRY_CAST(
                review_creation_date AS DATETIME2
            ) AS review_creation_date,

            TRY_CAST(
                review_answer_timestamp AS DATETIME2
            ) AS review_answer_timestamp

        FROM bronze.olist_order_reviews;

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '';


        -- =========================================================
        -- OLIST PRODUCTS
        -- =========================================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.olist_products';
        TRUNCATE TABLE silver.olist_products;

        PRINT '>> Inserting Data Into: silver.olist_products';

        INSERT INTO silver.olist_products
        (
            product_id,
            product_category_name,
            product_name_length,
            product_description_length,
            product_photos_qty,
            product_weight_g,
            product_length_cm,
            product_height_cm,
            product_width_cm
        )
        SELECT 
            TRIM(' "' FROM product_id) AS product_id,

            product_category_name,

            TRY_CAST(
                NULLIF(product_name_lenght, '')
                AS INT
            ) AS product_name_length,

            TRY_CAST(
                NULLIF(product_description_lenght, '')
                AS INT
            ) AS product_description_length,

            TRY_CAST(
                NULLIF(product_photos_qty, '')
                AS INT
            ) AS product_photos_qty,

            TRY_CAST(
                NULLIF(product_weight_g, '')
                AS INT
            ) AS product_weight_g,

            TRY_CAST(
                NULLIF(product_length_cm, '')
                AS INT
            ) AS product_length_cm,

            TRY_CAST(
                NULLIF(product_height_cm, '')
                AS INT
            ) AS product_height_cm,

            TRY_CAST(
                NULLIF(product_width_cm, '')
                AS INT
            ) AS product_width_cm

        FROM bronze.olist_products;

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '';


        -- =========================================================
        -- OLIST SELLERS
        -- =========================================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.olist_sellers';
        TRUNCATE TABLE silver.olist_sellers;

        PRINT '>> Inserting Data Into: silver.olist_sellers';

        INSERT INTO silver.olist_sellers
        (
            seller_id,
            seller_zip_code_prefix,
            seller_city,
            seller_state
        )
        SELECT 
            TRIM(' "' FROM seller_id) AS seller_id,

            TRIM(' "' FROM seller_zip_code_prefix) AS seller_zip_code_prefix,

            CASE 
                WHEN TRIM(' "' FROM seller_city) = '04482255'
                    THEN 'rio de janeiro'
                ELSE TRIM(' "' FROM seller_city)
            END AS seller_city,

            seller_state

        FROM bronze.olist_sellers;

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '';


        -- =========================================================
        -- PRODUCT CATEGORY NAME TRANSLATION
        -- =========================================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.product_category_name_translation';
        TRUNCATE TABLE silver.product_category_name_translation;

        PRINT '>> Inserting Data Into: silver.product_category_name_translation';

        INSERT INTO silver.product_category_name_translation
        (
            product_category_name,
            product_category_name_english
        )
        SELECT 
            product_category_name,
            product_category_name_english
        FROM bronze.product_category_name_translation;

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '';


        -- =========================================================
        -- TOTAL LOAD TIME
        -- =========================================================

        SET @end_total_time = GETDATE();

        PRINT '==============================================================';
        PRINT 'Silver Layer Loaded Successfully';
        PRINT '>> Total Load Duration: '
            + CAST(
                DATEDIFF(
                    SECOND,
                    @start_total_time,
                    @end_total_time
                ) 
                AS NVARCHAR
            )
            + ' seconds';
        PRINT '==============================================================';

    END TRY

    BEGIN CATCH

        PRINT '==============================================================';
        PRINT 'ERROR OCCURRED DURING LOADING SILVER LAYER';
        PRINT '==============================================================';

        PRINT 'Error Message: ' 
            + ERROR_MESSAGE();

        PRINT 'Error Number: '
            + CAST(ERROR_NUMBER() AS NVARCHAR);

        PRINT 'Error State: '
            + CAST(ERROR_STATE() AS NVARCHAR);

        PRINT 'Error Line: '
            + CAST(ERROR_LINE() AS NVARCHAR);

        PRINT '==============================================================';

    END CATCH
END;
GO
