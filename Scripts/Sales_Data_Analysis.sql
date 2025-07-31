-- 1. Top 10 most selling products
SELECT TOP 10 product_name, SUM(quantity) as total_quantity 
FROM sales_store_main
WHERE status='delivered'
GROUP BY product_name
ORDER BY total_quantity DESC;

-- 2. Top 3 products purchased by each gender
SELECT gender, product_name, rn as product_rank FROM
	(SELECT gender, product_name, ROW_NUMBER() OVER(PARTITION BY gender ORDER BY total_quantity DESC) AS rn
	FROM(
		SELECT gender, product_name,SUM(quantity) as total_quantity 
		FROM sales_store_main
		GROUP BY gender, product_name)T
	)R
WHERE rn<=3;

-- 3. Most frequently cancelled products (Top 3) and how many times was it cancelled
SELECT TOP 3 product_name, COUNT(*) as cancelled_count
FROM sales_store_main
WHERE status='cancelled'
GROUP BY product_name
ORDER BY cancelled_count DESC;

-- 4. Total sales made per year
SELECT  SUM(quantity*price), DATEPART(YEAR,purchase_date) 
FROM sales_store_main
WHERE status='delivered'
GROUP BY DATEPART(YEAR,purchase_date);

-- 5. Most preferred payment mode
SELECT TOP 1 payment_mode 
FROM sales_store_main
GROUP BY payment_mode
ORDER BY COUNT(*) DESC;

-- 6. Product categories generating highest revenue (in INR)
SELECT product_category, FORMAT(SUM(price*quantity),'C0','en-IN') as Total_revenue
FROM sales_store_main
WHERE status='delivered'
GROUP BY product_category
ORDER BY Total_revenue DESC;

-- 7. Purchase behavior for different age groups
SELECT age_group, FORMAT(SUM(sale),'C0','en-IN') as total_sale 
FROM 
	(SELECT 
	CASE
		WHEN customer_age BETWEEN 18 AND 20 THEN '18-20'
		WHEN customer_age BETWEEN 21 AND 30 THEN '21-30'
		WHEN customer_age BETWEEN 31 AND 40 THEN '31-40'
		WHEN customer_age BETWEEN 41 AND 50 THEN '41-50'
		ELSE '50+'
	END AS age_group,
	price*quantity AS sale
	FROM sales_store_main) t
GROUP BY age_group
ORDER BY SUM(sale) DESC; 

-- 8. Time of the day with highest number of purchases
SELECT 
CASE
	WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 0 AND 5 THEN '12AM-5AM'
	WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 6 AND 11 THEN '6AM-11AM'
	WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 12 AND 17 THEN '12PM-5PM'
	WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 18 AND 23 THEN '6PM-11PM'
END as purchase_time,
COUNT(*) as total_purchase
FROM sales_store_main
GROUP BY CASE
	WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 0 AND 5 THEN '12AM-5AM'
	WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 6 AND 11 THEN '6AM-11AM'
	WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 12 AND 17 THEN '12PM-5PM'
	WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 18 AND 23 THEN '6PM-11PM'
END
ORDER BY total_purchase DESC;

-- 9. Return/Cancellation rate per product category
SELECT product_category, 
--COUNT(*),COUNT(CASE WHEN LOWER(status)='returned' THEN 1 END),
CAST(COUNT(CASE WHEN LOWER(status)='returned' THEN 1 END)*100/COUNT(*) AS nvarchar)+'%' AS rate,
'Returned' as category
FROM sales_store_main
GROUP BY product_category

UNION 

SELECT product_category, 
--COUNT(*), COUNT(CASE WHEN LOWER(status)='cancelled' THEN 1 END),
CAST(COUNT(CASE WHEN LOWER(status)='cancelled' THEN 1 END)*100/COUNT(*) AS nvarchar)+'%' AS rate,
'Cancelled' as category
FROM sales_store_main
GROUP BY product_category

ORDER BY product_category;

-- 10. Top 5 most spending customer details
SELECT DISTINCT TOP 5 customer_id, customer_name,customer_age, gender, 
SUM(price*quantity) OVER(PARTITION BY customer_id) as total_sale
FROM sales_store_main
ORDER BY total_sale DESC;

