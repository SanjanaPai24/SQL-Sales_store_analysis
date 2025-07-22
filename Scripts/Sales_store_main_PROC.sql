/*
===============================================================================
Stored Procedure: Load Table (sales_store ->sales_store_main )
===============================================================================
Script Purpose:
    This stored procedure loads data into the sales_store_main table from sales_store table. 
    It performs the following actions:
    - Truncates the sales_store table before loading data.
    - Inserts data from sales_store table to sales_store_main table.

Usage Example:
    EXEC load_sales_store_main;
===============================================================================
*/

--Stored procudure load_sales_store_main
IF OBJECT_ID('load_sales_store_main','P') IS NULL
	EXEC('CREATE PROCEDURE load_sales_store_main AS BEGIN RETURN; END;');
GO

ALTER PROCEDURE load_sales_store_main 
AS
BEGIN
    DECLARE @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading sales_store_main table';
        PRINT '================================================';

		-- Loading sales_store
		PRINT '>> Truncating Table: sales_store_main <<';
		TRUNCATE TABLE sales_store_main;
		PRINT '>> Inserting Data Into: sales_store_main <<';
		INSERT INTO sales_store_main (
			transaction_id,
			customer_id,
			customer_name,
			customer_age,
			gender,
			product_id,
			product_name,
			product_category,
			quantity,
			price,
			payment_mode,
			purchase_date,
			time_of_purchase,	
			status
		)
		SELECT  
			transaction_id,
			customer_id,
			customer_name,
			customer_age,
			--gender,
			CASE	
				WHEN UPPER(gender) IN ('MALE','M') THEN 'M'
				WHEN UPPER(gender) IN ('FEMALE','F') THEN 'F'
				ELSE 'NA'
			END as gender,
			product_id,
			product_name,
			product_category,
			quantity,
			price,
			--payment_mode,
			CASE payment_mode
				WHEN 'CC' THEN 'Credit Card'
				ELSE payment_mode
			END as payment_mode,
			purchase_date,
			time_of_purchase,	
			status 
			from (
				SELECT *, ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY transaction_id DESC) AS transaction_id_flag
				FROM sales_store 
				WHERE transaction_id IS NOT NULL
				)t 
				WHERE transaction_id_flag=1; --Incase of duplicates, select first row records
		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading sales_store is completed';
        PRINT '  - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Message: ' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message: ' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END


