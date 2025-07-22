/*
===============================================================================
DDL Script: Create sales_store Table
===============================================================================
Script Purpose:
    This script creates the table sales_store, dropping existing table
    if it already exists.
	  Run this script to re-define the DDL structure of sales_store Table
===============================================================================
*/

USE PracticeDatabase;

IF OBJECT_ID('sales_store', 'U') IS NOT NULL
    DROP TABLE sales_store;
GO

CREATE TABLE sales_store (
	transaction_id	VARCHAR(10),
	customer_id	VARCHAR(10),
	customer_name VARCHAR(40),
	customer_age INT,
	gender VARCHAR(10),
	product_id VARCHAR(10),
	product_name VARCHAR(40),
	product_category VARCHAR(40),
	quantiy	INT,
	prce INT,
	payment_mode VARCHAR(20),
	purchase_date DATE,
	time_of_purchase TIME,	
	status VARCHAR(15)
);
GO


--Correction of Headers
EXEC sp_rename 'sales_store.quantiy','quantity','COLUMN';
EXEC sp_rename 'sales_store.prce','price','COLUMN';
