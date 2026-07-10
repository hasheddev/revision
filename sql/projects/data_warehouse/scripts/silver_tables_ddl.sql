/*
===================================================================================
WARNING: Running this script will DROP existing tables in the 'silver' schema. 
Any existing data in these tables will be permanently deleted. Ensure you have 
proper backups before executing this script in a production environment.

Description: DDL script to recreate the Silver Layer tables within the DataWarehouse.
Changes Made:
- Migrated schema from 'bronze' to 'silver'.
- Added 'dwh_created_at' audit column with default current date to all tables.
===================================================================================
*/

USE DataWarehouse;
GO

-- ================================================================================
-- 1. crm_cust_info
-- ================================================================================
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
 DROP TABLE silver.crm_cust_info;

CREATE TABLE silver.crm_cust_info (
        cst_id INT,
        cst_key NVARCHAR(50),
        cst_firstname NVARCHAR(50),
        cst_lastname NVARCHAR(50),
        cst_marital_status NVARCHAR(50),
        cst_gndr NVARCHAR(50),
        cst_create_date DATE,
        dwh_created_at DATETIME DEFAULT GETDATE()
);

-- ================================================================================
-- 2. crm_prd_info
-- ================================================================================
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
 DROP TABLE silver.crm_prd_info;

CREATE TABLE silver.crm_prd_info (
        prd_id INT,
        prd_key NVARCHAR(50),
        prd_nm NVARCHAR(50),
        prd_cost INT,
        prd_line NVARCHAR(50),
        prd_start_dt DATETIME,
        prd_end_dt DATETIME,
        dwh_created_at DATETIME DEFAULT GETDATE()
);

-- ================================================================================
-- 3. crm_sales_details
-- ================================================================================
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
 DROP TABLE silver.crm_sales_details;

CREATE TABLE silver.crm_sales_details (
        sls_ord_num NVARCHAR(50),
        sls_prd_key NVARCHAR(50),
        sls_cust_id INT,
        sls_order_dt INT,
        sls_ship_dt INT,
        sls_due_date INT,
        sls_sales INT,
        sls_quantity INT,
        sls_price INT,
        dwh_created_at DATETIME DEFAULT GETDATE()
);

-- ================================================================================
-- 4. erp_loc_a101
-- ================================================================================
IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
 DROP TABLE silver.erp_loc_a101;

CREATE TABLE silver.erp_loc_a101 (
         cid NVARCHAR(50),
         cntry NVARCHAR(50),
         dwh_created_at DATETIME DEFAULT GETDATE()
);

-- ================================================================================
-- 5. erp_cust_az12
-- ================================================================================
IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
 DROP TABLE silver.erp_cust_az12;

CREATE TABLE silver.erp_cust_az12 (
        cid NVARCHAR(50),
        bdate DATE,
        gen NVARCHAR(50),
        dwh_created_at DATETIME DEFAULT GETDATE()
);

-- ================================================================================
-- 6. erp_px_cat_g1v2
-- ================================================================================
IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
 DROP TABLE silver.erp_px_cat_g1v2;

CREATE TABLE silver.erp_px_cat_g1v2 (
        id NVARCHAR(50),
        cat NVARCHAR(50),
        subcat NVARCHAR(50),
        maintenace NVARCHAR(50),
        dwh_created_at DATETIME DEFAULT GETDATE()
);
