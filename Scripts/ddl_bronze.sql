/*
This script I have created it when following Tutorial by Data with Baraa.
This scripts cretes tables in bronze schema
*/
CREATE TABLE bronze.crm_cust_info(
cst_id INT,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_material_status NVARCHAR(50),
cst_gndr NVARCHAR(50),
cst_create_date DATE
);

CREATE TABLE bronze.crm_prd_info(
prd_id INT,
prd_key NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost INT,
prd_line NVARCHAR(10),
prd_start DATE,
prd_end_dt DATE
);
ALTER TABLE bronze.crm_prd_info
ALTER COLUMN prd_start DATETIME;
ALTER TABLE bronze.crm_prd_info
ALTER COLUMN prd_end_dt DATETIME;

ALTER TABLE bronze.crm_prd_info
ALTER COLUMN prd_end_dt DATETIME;
DROP TABLE IF EXISTS bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details(
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT
)
DROP TABLE IF EXISTS bronze.erp_CUST_AZ12
CREATE TABLE bronze.erp_CUST_AZ12(
CID NVARCHAR(50),
BDATE DATE,
GEN NVARCHAR(50)
);
CREATE TABLE bronze.erp_LOC_A101(
CID NVARCHAR(50),
CNTRY NVARCHAR(50)
)
DROP TABLE IF EXISTS bronze.erp_PX_CAT_G1V2
CREATE TABLE bronze.erp_PX_CAT_G1V2(
ID NVARCHAR(50),
CAT NVARCHAR(50),
MAINTENANCE NVARCHAR(50)
);
CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
		TRUNCATE TABLE bronze.crm_cust_info;
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\Administrator\Downloads\SQL DATAWAREHOUSE PROJECT\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH(
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK
		);
		TRUNCATE TABLE bronze.crm_prd_info;
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\Administrator\Downloads\SQL DATAWAREHOUSE PROJECT\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH(
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK
		);
		SELECT* FROM bronze.crm_prd_info
		TRUNCATE TABLE bronze.crm_sales_details;
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\Administrator\Downloads\SQL DATAWAREHOUSE PROJECT\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH(
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK
		);
		SELECT* FROM bronze.crm_sales_details
		TRUNCATE TABLE bronze.erp_CUST_AZ12;
		BULK INSERT bronze.erp_CUST_AZ12
		FROM 'C:\Users\Administrator\Downloads\SQL DATAWAREHOUSE PROJECT\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH(
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK
		);
		SELECT* FROM bronze.erp_CUST_AZ12
		TRUNCATE TABLE bronze.erp_LOC_A101;
		BULK INSERT bronze.erp_LOC_A101
		FROM 'C:\Users\Administrator\Downloads\SQL DATAWAREHOUSE PROJECT\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH(
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK
		);
		SELECT* FROM bronze.erp_LOC_A101
		TRUNCATE TABLE bronze.erp_PX_CAT_G1V2
		BULK INSERT bronze.erp_PX_CAT_G1V2
		FROM 'C:\Users\Administrator\Downloads\SQL DATAWAREHOUSE PROJECT\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH(
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK
		);
END
