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
