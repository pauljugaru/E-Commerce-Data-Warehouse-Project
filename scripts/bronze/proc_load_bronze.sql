CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE
        @start_time DATETIME,
        @end_time DATETIME,
        @start_total_time DATETIME,
        @end_total_time DATETIME;

    BEGIN TRY

        SET @start_total_time = GETDATE();

        PRINT '==============================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '==============================================================';


        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.olist_customers';
        TRUNCATE TABLE bronze.olist_customers;

        PRINT '>> Inserting Data Into: bronze.olist_customers';
        BULK INSERT bronze.olist_customers
        FROM 'C:\PAUL\E-Commerce_Project\datasets\olist_customers_dataset.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';


        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.olist_geolocation';
        TRUNCATE TABLE bronze.olist_geolocation;

        PRINT '>> Inserting Data Into: bronze.olist_geolocation';
        BULK INSERT bronze.olist_geolocation
        FROM 'C:\PAUL\E-Commerce_Project\datasets\olist_geolocation_dataset.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';


        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.olist_order_items';
        TRUNCATE TABLE bronze.olist_order_items;

        PRINT '>> Inserting Data Into: bronze.olist_order_items';
        BULK INSERT bronze.olist_order_items
        FROM 'C:\PAUL\E-Commerce_Project\datasets\olist_order_items_dataset.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';


        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.olist_order_payments';
        TRUNCATE TABLE bronze.olist_order_payments;

        PRINT '>> Inserting Data Into: bronze.olist_order_payments';
        BULK INSERT bronze.olist_order_payments
        FROM 'C:\PAUL\E-Commerce_Project\datasets\olist_order_payments_dataset.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';


        -- TEMPORAR scoatem reviews ca să verificăm restul pipeline-ului


        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.olist_orders';
        TRUNCATE TABLE bronze.olist_orders;

        PRINT '>> Inserting Data Into: bronze.olist_orders';
        BULK INSERT bronze.olist_orders
        FROM 'C:\PAUL\E-Commerce_Project\datasets\olist_orders_dataset.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';


        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.olist_products';
        TRUNCATE TABLE bronze.olist_products;

        PRINT '>> Inserting Data Into: bronze.olist_products';
        BULK INSERT bronze.olist_products
        FROM 'C:\PAUL\E-Commerce_Project\datasets\olist_products_dataset.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';


        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.olist_sellers';
        TRUNCATE TABLE bronze.olist_sellers;

        PRINT '>> Inserting Data Into: bronze.olist_sellers';
        BULK INSERT bronze.olist_sellers
        FROM 'C:\PAUL\E-Commerce_Project\datasets\olist_sellers_dataset.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';


        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.product_category_name_translation';
        TRUNCATE TABLE bronze.product_category_name_translation;

        PRINT '>> Inserting Data Into: bronze.product_category_name_translation';
        BULK INSERT bronze.product_category_name_translation
        FROM 'C:\PAUL\E-Commerce_Project\datasets\product_category_name_translation.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';


        SET @end_total_time = GETDATE();

        PRINT '==============================================================';
        PRINT 'Bronze Layer Loaded Successfully';
        PRINT '>> Total Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_total_time, @end_total_time) AS NVARCHAR)
            + ' seconds';
        PRINT '==============================================================';

    END TRY

    BEGIN CATCH

        PRINT '==============================================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT 'Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR);
        PRINT '==============================================================';

    END CATCH
END;
GO

