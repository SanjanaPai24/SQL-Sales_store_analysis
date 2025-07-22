/*
===============================================================================
DDL Script: Create sales_store_main Table
This table consists the cleaned up data from sales_store table
===============================================================================
Script Purpose:
    This script creates the table sales_store_main, dropping existing table
    if it already exists.
	  Run this script to re-define the DDL structure of sales_store_main Table
===============================================================================
*/
IF OBJECT_ID('sales_store_main', 'U') IS NOT NULL
    DROP TABLE sales_store_main;
GO

CREATE TABLE sales_store_main (
	transaction_id	VARCHAR(10),
	customer_id	VARCHAR(10),
	customer_name VARCHAR(40),
	customer_age INT,
	gender VARCHAR(10),
	product_id VARCHAR(10),
	product_name VARCHAR(40),
	product_category VARCHAR(40),
	quantity INT,
	price INT,
	payment_mode VARCHAR(20),
	purchase_date DATE,
	time_of_purchase TIME,	
	status VARCHAR(15)
);
GO
