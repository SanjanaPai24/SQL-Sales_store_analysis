/*
===============================================================================
Stored Procedure: Load Table (Source ->sales_store )
===============================================================================
Script Purpose:
    This stored procedure loads data into the sales_store table from external CSV files. 
    It performs the following actions:
    - Truncates the sales_store table before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to the sales_store table.

Usage Example:
    EXEC load_sales_store;
===============================================================================
*/

--Stored procudure load_sales_store
IF OBJECT_ID('load_sales_store','P') IS NULL
	EXEC('CREATE PROCEDURE load_sales_store AS BEGIN RETURN; END;');
GO

ALTER PROCEDURE load_sales_store 
AS
BEGIN
    DECLARE @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading sales_store table';
        PRINT '================================================';

		-- Loading sales_store
		PRINT '>> Truncating Table: sales_store <<';
		TRUNCATE TABLE sales_store;
		PRINT '>> Inserting Data Into: sales_store <<';
		--Formating the input date values to load as per DATE datatype
		SET DATEFORMAT dmy;
		BULK INSERT sales_store
		FROM 'C:\SQL_Data\Project1_dataset\sales_store.csv'
			WITH (
				FIRSTROW=2,
				FIELDTERMINATOR=',',
				ROWTERMINATOR='\n'
			);
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
