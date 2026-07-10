-- ===================================================================================
-- PIPELINE STEP 1: PRE-LOAD DATA QUALITY INVESTIGATION
-- Use these queries to identify anomalies (duplicates, nulls, whitespace) in Bronze.
-- ===================================================================================

-- Check 1: Find duplicate customer IDs or completely missing IDs
-- Expected target issues: 29449, 29473, 29433, NULL, 29483, 29466
SELECT
    cst_id,
    COUNT(*) AS duplicate_count
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check 2: Check for unwanted leading/trailing spaces in names
SELECT cst_firstname FROM bronze.crm_cust_info WHERE cst_firstname != TRIM(cst_firstname);
SELECT cst_lastname FROM bronze.crm_cust_info WHERE cst_lastname != TRIM(cst_lastname);

-- Check 3: Check for unwanted spaces or non-standardized values in categorical fields
SELECT cst_gndr FROM bronze.crm_cust_info WHERE cst_gndr != TRIM(cst_gndr);
SELECT cst_marital_status FROM bronze.crm_cust_info WHERE cst_marital_status != TRIM(cst_marital_status);

-- Check 4: Inspect distinct gender and marital variations to map standardization logic
SELECT DISTINCT cst_gndr FROM bronze.crm_cust_info;
SELECT DISTINCT cst_marital_status FROM bronze.crm_cust_info;

-- Check 5: Isolate completely null Customer rows for inspection
SELECT * FROM bronze.crm_cust_info WHERE cst_id IS NULL;


-- ===================================================================================
-- PIPELINE STEP 2: TRANSFORMATION AND LOADING (ETL)
-- Truncates Silver, standardizes text, cleans codes, handles deduplication, and loads.
-- ===================================================================================

-- Clear old Silver data before reloading (Truncate and Load approach)
TRUNCATE TABLE silver.crm_cust_info;

-- Insert cleaned, deduplicated, and audited data into Silver Layer
INSERT INTO silver.crm_cust_info (
    cst_id, 
    cst_key, 
    cst_firstname, 
    cst_lastname, 
    cst_marital_status, 
    cst_gndr, 
    cst_create_date
)
SELECT 
    cst_id,
    cst_key,
    TRIM(cst_firstname) AS cst_firstname,
    TRIM(cst_lastname) AS cst_lastname,
    CASE 
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        ELSE 'n/a'
    END AS cst_marital_status,
    CASE
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        ELSE 'n/a'
    END AS cst_gndr,
    cst_create_date
FROM (
    SELECT 
        *,
        -- Rank records by date per customer to isolate the most recent entry
        ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
    FROM bronze.crm_cust_info
    -- Data Quality Gate: Drop rows missing the structural primary key entirely
    WHERE cst_id IS NOT NULL
) t
-- Filter rule: Keep only the latest record, filtering out historical duplicates
WHERE flag_last = 1;


-- ===================================================================================
-- PIPELINE STEP 3: POST-LOAD VALIDATION (QA)
-- Run these queries after the load to guarantee data cleaning rules executed perfectly.
-- ===================================================================================


-- Check A: Verify duplicates and NULL keys are 100% eliminated (Should return 0 rows)
SELECT cst_id, COUNT(*) 
FROM silver.crm_cust_info 
GROUP BY cst_id 
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check B: Verify gender values are strictly standardized (Should only return 'Male', 'Female', or 'n/a')
SELECT DISTINCT cst_gndr FROM silver.crm_cust_info;
SELECT DISTINCT cst_marital_status FROM silver.crm_cust_info;

SELECT * FROM silver.crm_cust_info;

SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- Check 3: Check for unwanted spaces or non-standardized values in categorical fields
SELECT cst_gndr
FROM silver.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

SELECT cst_marital_status
FROM silver.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status);

