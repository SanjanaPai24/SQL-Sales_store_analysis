/*
===============================================================================
Script Purpose:
    These scripts are used to check and clean up data in sales_store_main table.

===============================================================================
*/

--=============customer_id=============--

--Checking for NULL customer_id
SELECT transaction_id,customer_id,customer_name FROM sales_store_main 
WHERE customer_id is NULL; 


--Getting corresponding customer_id for the customer_names from the not NULL data
SELECT transaction_id,customer_id,customer_name FROM sales_store_main
WHERE customer_id IS NOT NULL AND customer_name IN ('Ehsaan Ram','Damini Raju')
ORDER BY customer_name;

--Getting transaction_id to update the correct customer_id
SELECT transaction_id,customer_id,customer_name FROM sales_store_main
WHERE customer_id IS NULL AND customer_name IN ('Ehsaan Ram','Damini Raju');

--Executing the solution by updating the data 
UPDATE sales_store_main
SET customer_id='CUST9494'
WHERE transaction_id='TXN977900';

UPDATE sales_store_main
SET customer_id='CUST1401'
WHERE transaction_id='TXN985663';

--=============customer_name, customer_age, gender=============--

--Checking for NULL customer_name, customer_age, gender
SELECT transaction_id,customer_id,customer_name,customer_age, gender FROM sales_store_main
WHERE customer_name is NULL; 

--Getting corresponding customer_name, customer_age, gender for the customer_id from the not NULL data
SELECT transaction_id,customer_id,customer_name,customer_age,gender FROM sales_store_main
WHERE customer_name IS NOT NULL AND customer_id IN ('CUST1003')
ORDER BY customer_id;

--Getting transaction_id to update the correct customer_id
SELECT transaction_id,customer_id,customer_name,customer_age,gender FROM sales_store_main
WHERE customer_name IS NULL AND customer_id IN ('CUST1003');

--Executing the solution by updating the data 
UPDATE sales_store_main
SET customer_name='Mahika Saini',customer_age=35,gender='M'
WHERE transaction_id='TXN432798';

--==========Checking for correct data===========--

--Check for duplicate transaction_id
SELECT transaction_id from sales_store_main
GROUP BY transaction_id
HAVING COUNT(transaction_id)>1;

--Checking for NULL vales in any column
SELECT *
FROM sales_store_main
WHERE 
transaction_id IS NULL
OR
customer_id IS NULL
OR
customer_name IS NULL
OR
customer_age IS NULL
OR
gender IS NULL
OR
product_id IS NULL
OR
product_name IS NULL
OR
product_category IS NULL
OR
quantity IS NULL
OR
price IS NULL
OR
payment_mode IS NULL
OR
purchase_date IS NULL
OR
time_of_purchase IS NULL
OR	
status IS NULL;
