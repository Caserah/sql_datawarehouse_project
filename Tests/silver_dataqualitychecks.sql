SELECT TOP(1000)[cst_id]
               ,[cst_key]
			   ,[cst_firstname]
			   ,[cst_lastname]
			   ,[cst_material_status]
			   ,[cst_gndr]
			   ,[cst_create_date]
FROM [DataWarehouse].[Bronze].[crm_cust_info]

SELECT TOP (1000) [prd_id]
      ,[prd_key]
      ,[prd_nm]
      ,[prd_cost]
      ,[prd_line]
      ,[prd_start]
      ,[prd_end_dt]
  FROM [DataWarehouse].[Bronze].[crm_prd_info]

  SELECT TOP (1000) [sls_ord_num]
      ,[sls_prd_key]
      ,[sls_cust_id]
      ,[sls_order_dt]
      ,[sls_ship_dt]
      ,[sls_due_dt]
      ,[sls_sales]
      ,[sls_quantity]
      ,[sls_price]
  FROM [DataWarehouse].[Bronze].[crm_sales_details]

  SELECT TOP (1000) [CID]
      ,[BDATE]
      ,[GEN]
  FROM [DataWarehouse].[Bronze].[erp_CUST_AZ12]
  
  SELECT TOP (1000) [ID]
      ,[CAT]
      ,[MAINTENANCE]
  FROM [DataWarehouse].[Bronze].[erp_PX_CAT_G1V2]

  
  SELECT TOP (1000) [CID]
      ,[CNTRY]
  FROM [DataWarehouse].[Bronze].[erp_LOC_A101]
SELECT
cst_id,
COUNT(*)
FROM Bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) >1 OR cst_id IS NULL

SELECT*FROM(SELECT*,
ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
FROM Bronze.crm_cust_info
WHERE cst_id IS NOT NULL)t WHERE flag_last = 1
/* UNWANTED SPACES*/
SELECT cst_lastname
FROM Bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

SELECT
prd_id,
COUNT(*)
FROM Bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL
SELECT
prd_id,
prd_key,
REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,
SUBSTRING(prd_key,7,LEN(prd_key))AS prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start,
prd_end_dt
FROM Bronze.crm_prd_info
 WHERE REPLACE(SUBSTRING(prd_key,1,5),'-','_') NOT IN
 (SELECT distinct id FROM bronze.erp_PX_CAT_G1V2);
ALTER TABLE Silver.erp_CUST_AZ12
ADD cid_last5 VARCHAR(5);
UPDATE Silver.erp_CUST_AZ12
SET cid_last5 = RIGHT(CAST([CID] AS VARCHAR(50)), 5);
-- Add the new column
ALTER TABLE Silver.crm_prd_info 
ADD cat_id VARCHAR(10);

-- Update it with the first 5 characters, replacing '-' with '_'
UPDATE Silver.crm_prd_info 
SET cat_id = REPLACE(LEFT(prd_key, 5), '-', '_');
-- Add the new subcat column (MAINTENANCE column already exists)
ALTER TABLE Silver.erp_PX_CAT_G1V2
ADD subcat VARCHAR(100);

-- Update both columns
UPDATE Silver.erp_PX_CAT_G1V2
SET subcat      = LEFT(MAINTENANCE, CHARINDEX(',', MAINTENANCE) - 1),
    MAINTENANCE = LTRIM(SUBSTRING(MAINTENANCE, CHARINDEX(',', MAINTENANCE) + 1, LEN(MAINTENANCE)));
 
			SELECT	
			ci.cst_gndr,
			az.GEN,
			CASE WHEN ci.cst_gndr !='n/a' THEN ci.cst_gndr --CRM IS THE MASTER FOR GENDER INFO
			     ELSE COALESCE(az.GEN,'n/a')
			END AS new_gen
			FROM Silver.crm_cust_info ci
			LEFT JOIN Silver.erp_CUST_AZ12 az
			ON RIGHT(CAST(ci.cst_key AS VARCHAR(50)), 5) = az.cid_last5
			LEFT JOIN Silver.erp_LOC_A101 la
			ON   RIGHT(CAST(ci.cst_key AS VARCHAR(50)), 5)=la.cid_new
-- Add the new column
ALTER TABLE Silver.crm_prd_info
ADD new_prd_key NVARCHAR(50);

-- Update it with the last 9 characters from prd_key
UPDATE Silver.crm_prd_info
SET new_prd_key = RIGHT(prd_key, 9);


