USE DataWarehouse;

--  bronze.crm_cust_info bronze.crm_prd_info bronze.crm_sales_details
--  bronze.erp_loc_a101 bronze.erp_cust_az12 bronze.erp_px_cat_g1v2
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        PRINT '==================================================';
        PRINT 'STARTING BRONZE LAYER DATA LOAD';
        PRINT '==================================================';
        DECLARE @StartTime DATETIME = GETDATE();

        -- --------------------------------------------------
        -- 1. crm_cust_info
        -- --------------------------------------------------
        PRINT 'Step 1/6: Processing crm_cust_info...';
        PRINT '   -> Truncating table bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '   -> Bulk inserting from cust_info.csv';
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\...\cust_info.csv'
        WITH (
          FIRST_ROW = 2,
          FIELDTERMINATOR = ',',
          TABLOCK
        );
        PRINT '   -> Successfully loaded crm_cust_info.';
        PRINT '--------------------------------------------------';

        -- --------------------------------------------------
        -- 2. crm_prd_info
        -- --------------------------------------------------
        PRINT 'Step 2/6: Processing crm_prd_info...';
        PRINT '   -> Truncating table bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '   -> Bulk inserting from prd_info.csv';
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\...\prd_info.csv'
        WITH (
          FIRST_ROW = 2,
          FIELDTERMINATOR = ',',
          TABLOCK
        );
        PRINT '   -> Successfully loaded crm_prd_info.';
        PRINT '--------------------------------------------------';

        -- --------------------------------------------------
        -- 3. crm_sales_details
        -- --------------------------------------------------
        PRINT 'Step 3/6: Processing crm_sales_details...';
        PRINT '   -> Truncating table bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '   -> Bulk inserting from sales_details.csv';
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\...\sales_details.csv'
        WITH (
          FIRST_ROW = 2,
          FIELDTERMINATOR = ',',
          TABLOCK
        );
        PRINT '   -> Successfully loaded crm_sales_details.';
        PRINT '--------------------------------------------------';

        -- --------------------------------------------------
        -- 4. erp_loc_a101
        -- --------------------------------------------------
        PRINT 'Step 4/6: Processing erp_loc_a101...';
        PRINT '   -> Truncating table bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '   -> Bulk inserting from LOC_A101.csv';
        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\...\LOC_A101.csv'
        WITH (
          FIRST_ROW = 2,
          FIELDTERMINATOR = ',',
          TABLOCK
        );
        PRINT '   -> Successfully loaded erp_loc_a101.';
        PRINT '--------------------------------------------------';

        -- --------------------------------------------------
        -- 5. erp_cust_az12
        -- --------------------------------------------------
        PRINT 'Step 5/6: Processing erp_cust_az12...';
        PRINT '   -> Truncating table bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '   -> Bulk inserting from CUST_AZ12.csv';
        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\...\CUST_AZ12.csv'
        WITH (
          FIRST_ROW = 2,
          FIELDTERMINATOR = ',',
          TABLOCK
        );
        PRINT '   -> Successfully loaded erp_cust_az12.';
        PRINT '--------------------------------------------------';

        -- --------------------------------------------------
        -- 6. erp_px_cat_g1v2
        -- --------------------------------------------------
        PRINT 'Step 6/6: Processing erp_px_cat_g1v2...';
        PRINT '   -> Truncating table bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '   -> Bulk inserting from PX_CAT_G1V2.csv';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\...\PX_CAT_G1V2.csv'
        WITH (
          FIRST_ROW = 2,
          FIELDTERMINATOR = ',',
          TABLOCK
        );
        PRINT '   -> Successfully loaded erp_px_cat_g1v2.';
        PRINT '--------------------------------------------------';

        PRINT '==================================================';
        PRINT 'SUCCESS: All bronze tables loaded completely.';
        PRINT 'Total Execution Time: ' + CAST(DATEDIFF(second, @StartTime, GETDATE()) AS VARCHAR) + ' seconds.';
        PRINT '==================================================';

    END TRY
    BEGIN CATCH
        PRINT '==================================================';
        PRINT 'ERROR DETECTED! Aborting Bronze execution.';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number:  ' + CAST(ERROR_NUMBER() AS VARCHAR);
        PRINT 'Error Line:    ' + CAST(ERROR_LINE() AS VARCHAR);
        PRINT 'Error State:   ' + CAST(ERROR_STATE() AS VARCHAR);
        PRINT '==================================================';
    END CATCH
END
GO

EXEC bronze.load_bronze
