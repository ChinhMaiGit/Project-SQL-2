-- OLIST EXPLORATORY ANALYSIS

-------------------------------------------------------------------------------------------------------------------------------------------
-- 1. CATEGORY_NAMES_ENGLISH:
-- Questions:
-- How many distinct catgories are there?
-------------------------------------------------------------------------------------------------------------------------------------------

--sql 1: showing data
SELECT * FROM category_names_english ORDER BY product_category;

--sql 2: counting number of distinct categories
SELECT
	COUNT(DISTINCT product_category)
FROM category_names_english;
-- 73 distinct categories

-------------------------------------------------------------------------------------------------------------------------------------------
-- 2. CUSTOMERS
-- Questions:
-- How many customers are there?
-- How many distinct cities, states are there?
-- Which are the top ten cities that have the most customers?
-- How many cities have more than 500 customers?
-- Which are the top ten states that have the most customers?
-- How many percents of the customer base do the top ten cities account for?
-- How many percents of the customer base do the top ten states account for?
-------------------------------------------------------------------------------------------------------------------------------------------

--sql 1: showing data
SELECT * FROM customers ORDER BY state LIMIT 10;

--sql 2: counting the number of customers, cities, and states
SELECT
	COUNT(*) AS no_rows,
	COUNT(DISTINCT customer_id) AS no_customer_id,
	COUNT(DISTINCT customer_unique_id) AS no_unique_customer_id,
	COUNT(DISTINCT city) AS no_distinct_city,
	COUNT(DISTINCT state) AS no_distinct_state
FROM customers;
-- no_customer_id = 99,441 > 96,096 = no_unique_customer_id so some customers might have more than one customer_id,
-- the number of distinct cities is much higher than that of states, so it might be better to aggregate data by states rather than cities

--sql 3: top ten cities having the most customers
SELECT
	city,
	COUNT(customer_unique_id) AS no_customers
FROM customers
GROUP BY city
ORDER BY no_customers DESC
LIMIT 10;
-- cities in the top ten have at least 938 customers

--sql 4: cities having at least 500 customers
WITH cte1 AS(
	SELECT
		city,
		COUNT(customer_unique_id) AS no_customers
	FROM customers
	GROUP BY city
	HAVING COUNT(customer_unique_id) > 500
	ORDER BY no_customers DESC
)
SELECT COUNT(*) FROM cte1;
-- 22 cities having more than 500 customers

--sql 5: ten states having the most customers
SELECT
	state,
	COUNT(customer_unique_id) AS no_customers
FROM customers
GROUP BY state
ORDER BY no_customers DESC
LIMIT 10;
-- any city in the top ten cities having the most customers has east least 2,020 customers

--sql 6: customer proportions of the top ten cities
WITH cte AS (
	SELECT
		city,
		COUNT(customer_unique_id) AS no_customers
	FROM customers
	GROUP BY city
	ORDER BY no_customers DESC
)
SELECT
	city,
	no_customers,
	ROUND(no_customers / SUM(no_customers) OVER() * 100, 2) AS percentage_customer_base,
	ROUND(SUM(no_customers) OVER(ORDER BY no_customers DESC RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / SUM(no_customers) OVER() * 100, 2) AS running_total_percentage
FROM cte
ORDER BY no_customers DESC
LIMIT 10;
-- the top ten cities only account for more than 35 percents of the customer base

--sql 7: customer proportions of the top ten states
WITH cte AS (
	SELECT
		state,
		COUNT(customer_unique_id) AS no_customers
	FROM customers
	GROUP BY state
	ORDER BY no_customers DESC
)
SELECT
	state,
	no_customers,
	ROUND(no_customers / SUM(no_customers) OVER() * 100, 2) AS percentage_customer_base,
	ROUND(SUM(no_customers) OVER(ORDER BY no_customers DESC RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / SUM(no_customers) OVER() * 100, 2) AS running_total_percentage
FROM cte
ORDER BY no_customers DESC
LIMIT 10;
-- The top ten states account for over 90 percent of the customer base

-- CONCLUSIONS:
-- Since the top 10 states already acount for more than 90 percents of the customer base,
-- it is much better to focus on the states rather than the cities as a means of aggregating data

-------------------------------------------------------------------------------------------------------------------------------------------
-- 3. SELLERS
-- Questions:
-- How many sellers are there?
-- How many distinct cities, states are there?
-- Which are the top ten cities that have the most sellers?
-- Which are the top ten states that have the most sellers?
-- How many percents of the seller base do the top ten cities account for?
-- How many percents of the seller base do the top ten states account for?
-------------------------------------------------------------------------------------------------------------------------------------------

--sql 1: showing data
SELECT * FROM sellers ORDER BY state LIMIT 10;

--sql 2: counting the number of sellers, cities, and states
SELECT
	COUNT(*) AS no_rows,
	COUNT(DISTINCT seller_id) AS no_seller_id,
	COUNT(DISTINCT city) AS no_distinct_city,
	COUNT(DISTINCT state) AS no_distinct_state
FROM sellers;
-- 3,095 sellers, 611 cities, and 23 states

--sql 3: top ten cities having the most sellers
SELECT
	city,
	COUNT(seller_id) AS no_sellers
FROM sellers
GROUP BY city
ORDER BY no_sellers DESC
LIMIT 10;
-- cities in the top ten have at least 40 sellers

--sql 4: top ten states having the most sellers
SELECT
	state,
	COUNT(seller_id) AS no_sellers
FROM sellers
GROUP BY state
ORDER BY no_sellers DESC
LIMIT 10;
-- states in the top ten have at least 19 sellers

--sql 5: seller proportions of the top ten cities
WITH cte AS (
	SELECT
		city,
		COUNT(seller_id) AS no_sellers
	FROM sellers
	GROUP BY city
	ORDER BY no_sellers DESC
)
SELECT
	city,
	no_sellers,
	ROUND(no_sellers / SUM(no_sellers) OVER() * 100, 2) AS percentage_seller_base,
	ROUND(SUM(no_sellers) OVER(ORDER BY no_sellers DESC RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / SUM(no_sellers) OVER() * 100, 2) AS running_total_percentage
FROM cte
ORDER BY no_sellers DESC
LIMIT 10;
-- The top ten cities account for approximately 41 percents of the seller base

--sql 6: seller proportions of the top ten states
WITH cte AS (
	SELECT
		state,
		COUNT(seller_id) AS no_sellers
	FROM sellers
	GROUP BY state
	ORDER BY no_sellers DESC
)
SELECT
	state,
	no_sellers,
	ROUND(no_sellers / SUM(no_sellers) OVER() * 100, 2) AS percentage_seller_base,
	ROUND(SUM(no_sellers) OVER(ORDER BY no_sellers DESC RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / SUM(no_sellers) OVER() * 100, 2) AS running_total_percentage
FROM cte
ORDER BY no_sellers DESC
LIMIT 10;
-- The top ten states account for more than 98 percents of the seller base

-- CONCLUSIONS:
-- The top ten states account for more than 98 percents of the sellers so it is a better medium to aggregate data

-------------------------------------------------------------------------------------------------------------------------------------------
-- 4. PRODUCTS
-- Questions:
-- How many products are there?
-- How many values of each column is missing?
-- What are the top ten categories having the heighest product counts?
-- What are the descriptive statistics for name_length?
-- What are the descriptive statistics for description_length?
-- What are the descriptive statistics for photos_quantity?
-- What are the descriptive statistics for weight_g?
-- What are the descriptive statistics for length_cm?
-- What are the descriptive statistics for height_cm?
-- What are the descriptive statistics for width_cm?
-------------------------------------------------------------------------------------------------------------------------------------------

--sql 1: showing data
SELECT * FROM products LIMIT 10;

--sql 2: product and category counts
SELECT
	COUNT(*) AS no_rows,
	COUNT(DISTINCT product_id) AS no_products,
	COUNT(DISTINCT product_category) AS no_categories,
	COUNT(*) - COUNT(product_category) AS no_missing_category,
	COUNT(*) - COUNT(name_length) AS no_missing_name_lgth,
	COUNT(*) - COUNT(description_length) AS no_missing_description_lgth,
	COUNT(*) - COUNT(photos_quantity) AS no_missing_photos_qty,
	COUNT(*) - COUNT(weight_g) AS no_missing_weight,
	COUNT(*) - COUNT(length_cm) AS no_missing_length,
	COUNT(*) - COUNT(height_cm) AS no_misisng_height,
	COUNT(*) - COUNT(width_cm) AS no_missing_width
FROM products;
-- 32,951 products with 73 categories, some product information is missing, however the properties of these products are available, so it might
-- be the case that they belong to a category that is not yet listed in the provided list, they can be then regarded as 'others'

--sql 3: top ten categories having highest product counts
SELECT
	product_category_eng,
	COUNT(product_id) AS no_products
FROM products LEFT JOIN category_names_english USING(product_category)
GROUP BY product_category_eng
ORDER BY no_products DESC
LIMIT 10;
-- it might worth looking at these categories. Focusing on important categories is better than looking at all the categories
-- as there are up to 73 categories in total so lowering the number of categories for necessary for meaningful data visualization.
-- However, the number of products is not the right criteria to determine which categories are important, sales or revenue is a much better option

--sql 3: descriptive statistics
SELECT
	1 AS variable_no,
	'name_length' AS variable,
	COUNT(DISTINCT name_length) AS n,
	ROUND(AVG(name_length), 2) AS mean,
	ROUND(STDDEV_SAMP(name_length), 2) AS sample_stddev,
	MAX(name_length) AS max,
	MIN(name_length) AS min,
	MODE() WITHIN GROUP (ORDER BY name_length) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY name_length) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY name_length) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY name_length) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY name_length) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY name_length) AS "99_percentile"
FROM products
WHERE name_length IS NOT NULL
UNION
SELECT
	2 AS variable_no,
	'description_length' AS variable,
	COUNT(DISTINCT description_length) AS n,
	ROUND(AVG(description_length), 2) AS mean,
	ROUND(STDDEV_SAMP(description_length), 2) AS sample_stddev,
	MAX(description_length) AS max,
	MIN(description_length) AS min,
	MODE() WITHIN GROUP (ORDER BY description_length) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY description_length) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY description_length) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY description_length) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY description_length) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY description_length) AS "99_percentile"
FROM products
WHERE description_length IS NOT NULL
UNION
SELECT
	3 AS variable_no,
	'photos_quantity' AS variable,
	COUNT(DISTINCT photos_quantity) AS n,
	ROUND(AVG(photos_quantity), 2) AS mean,
	ROUND(STDDEV_SAMP(photos_quantity), 2) AS sample_stddev,
	MAX(photos_quantity) AS max,
	MIN(photos_quantity) AS min,
	MODE() WITHIN GROUP (ORDER BY photos_quantity) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY photos_quantity) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY photos_quantity) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY photos_quantity) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY photos_quantity) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY photos_quantity) AS "99_percentile"
FROM products
WHERE photos_quantity IS NOT NULL
UNION
SELECT
	4 AS variable_no,
	'weight_g' AS variable,
	COUNT(DISTINCT weight_g) AS n,
	ROUND(AVG(weight_g), 2) AS mean,
	ROUND(STDDEV_SAMP(weight_g), 2) AS sample_stddev,
	MAX(weight_g) AS max,
	MIN(weight_g) AS min,
	MODE() WITHIN GROUP (ORDER BY weight_g) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY weight_g) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY weight_g) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY weight_g) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY weight_g) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY weight_g) AS "99_percentile"
FROM products
WHERE weight_g IS NOT NULL
UNION
SELECT
	5 AS variable_no,
	'length_cm' AS variable,
	COUNT(DISTINCT length_cm) AS n,
	ROUND(AVG(length_cm), 2) AS mean,
	ROUND(STDDEV_SAMP(length_cm), 2) AS sample_stddev,
	MAX(length_cm) AS max,
	MIN(length_cm) AS min,
	MODE() WITHIN GROUP (ORDER BY length_cm) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY length_cm) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY length_cm) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY length_cm) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY length_cm) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY length_cm) AS "99_percentile"
FROM products
WHERE length_cm IS NOT NULL
UNION
SELECT
	6 AS variable_no,
	'height_cm' AS variable,
	COUNT(DISTINCT height_cm) AS n,
	ROUND(AVG(height_cm), 2) AS mean,
	ROUND(STDDEV_SAMP(height_cm), 2) AS sample_stddev,
	MAX(height_cm) AS max,
	MIN(height_cm) AS min,
	MODE() WITHIN GROUP (ORDER BY height_cm) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY height_cm) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY height_cm) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY height_cm) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY height_cm) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY height_cm) AS "99_percentile"
FROM products
WHERE height_cm IS NOT NULL
UNION
SELECT
	7 AS variable_no,
	'width_cm' AS variable,
	COUNT(DISTINCT width_cm) AS n,
	ROUND(AVG(width_cm), 2) AS mean,
	ROUND(STDDEV_SAMP(width_cm), 2) AS sample_stddev,
	MAX(width_cm) AS max,
	MIN(width_cm) AS min,
	MODE() WITHIN GROUP (ORDER BY width_cm) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY width_cm) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY width_cm) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY width_cm) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY width_cm) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY width_cm) AS "99_percentile"
FROM products
WHERE width_cm IS NOT NULL
ORDER BY variable_no;

-------------------------------------------------------------------------------------------------------------------------------------------
-- 5. ORDERS
-- Questions:
-- What is the delivery rate?
-- How does the delivery rate changes over time?
-- When do customers usually make the purchase during the day?
-- What is the average approval time?
-- How does the average approval time change over time?
-- What is the average carrier delivered time since approval?
-- How does the average carrier delivered time change over time?
-- What is the average delivery time of the carrier?
-- How does the average delivery time of the carrier change over time?
-- What are the most frequent purchase days of customers during the week?
-- What are the most frequent delivered hours during the day?
-- What are the most frequent deliverd days during the week?
-- How accurate is the estimated delivery date?
-- How does the accuracy change over time?
-------------------------------------------------------------------------------------------------------------------------------------------

--sql 1: showing order data
SELECT * FROM orders LIMIT 10;

--sql 2: counting tables
SELECT
	COUNT(*) AS no_rows,
	COUNT(DISTINCT customer_id) AS no_customers,
	COUNT(*) - COUNT(status) AS no_missing_status,
	COUNT(*) - COUNT(purchase_timestamp) AS no_missing_purchase_timestamp,
	COUNT(*) - COUNT(approval_timestamp) AS no_misisng_approval_timestamp,
	COUNT(*) - COUNT(delivered_carrier_date) AS no_missing_delivered_carrier_timestamp,
	COUNT(*) - COUNT(delivered_customer_date) AS no_missing_delivered_customer_timestamp,
	COUNT(*) - COUNT(estimated_delivery_date) AS no_missing_est_deliver_timestamp
FROM orders;
-- The data seems to show only one-time customer as the number of rows equals to the number of customers.
-- Maybe the unique_customer_id is needed to count the number of purchase per customer

--sql 3: delivery rate
WITH cte AS (
	SELECT
		status,
		COUNT(status) AS status_count
	FROM orders
	GROUP BY status
)
SELECT
	status,
	status_count,
	ROUND(status_count / SUM(status_count) OVER() * 100, 2)  AS status_rate
FROM cte
ORDER BY status_count DESC;
-- The overall successful delivery rate is more than 97 percents


--sql 4: change of the delivery rate over time
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT
	status,
	ROUND("2016 Q3" / SUM("2016 Q3") OVER() * 100, 2) AS Q3_2016,
	ROUND("2016 Q4" / SUM("2016 Q4") OVER() * 100, 2) AS Q4_2016,
	ROUND("2017 Q1" / SUM("2017 Q1") OVER() * 100, 2) AS Q1_2017,
	ROUND("2017 Q2" / SUM("2017 Q2") OVER() * 100, 2) AS Q2_2017,
	ROUND("2017 Q3" / SUM("2017 Q3") OVER() * 100, 2) AS Q3_2017,
	ROUND("2017 Q4" / SUM("2017 Q4") OVER() * 100, 2) AS Q4_2017,
	ROUND("2018 Q1" / SUM("2018 Q1") OVER() * 100, 2) AS Q1_2018,
	ROUND("2018 Q2" / SUM("2018 Q2") OVER() * 100, 2) AS Q2_2018,
	ROUND("2018 Q3" / SUM("2018 Q3") OVER() * 100, 2) AS Q3_2018,
	ROUND("2018 Q4" / SUM("2018 Q4") OVER() * 100, 2) AS Q4_2018
FROM CROSSTAB($$
	SELECT
		status,
		DATE_PART('year', purchase_timestamp) || ' Q' || DATE_PART('quarter', purchase_timestamp) AS quarter_timestamp,
		COUNT(status) AS status_count
	FROM orders
	GROUP BY status, quarter_timestamp
	ORDER BY 1, 2
$$) AS ct (status TEXT, "2016 Q3" BIGINT, "2016 Q4" BIGINT,
					    "2017 Q1" BIGINT, "2017 Q2" BIGINT, "2017 Q3" BIGINT, "2017 Q4" BIGINT,
					    "2018 Q1" BIGINT, "2018 Q2" BIGINT, "2018 Q3" BIGINT, "2018 Q4" BIGINT);
-- delivery rate increases and remains high over time

--sql 5: common purchasing time during a day
SELECT
	DATE_PART('hour', purchase_timestamp) AS purchase_hour,
	COUNT(order_id)
FROM orders
GROUP BY purchase_hour
ORDER BY purchase_hour;
-- It seems that the common purchasing times are 10am ~ 17pm and 20pm ~ 21pm

--sql 6: average approval time
SELECT
	AVG(approval_timestamp - purchase_timestamp) AS avg_approval_time
FROM orders;
-- The average approval time is approximately 10 hour 30 mins from when the purchase order is made

--sql 7: changes in the average approval time
SELECT
	DATE_PART('year', purchase_timestamp) || ' Q' || DATE_PART('quarter', purchase_timestamp) AS quarter_timestamp,
	COUNT(order_id) AS no_purchases,
	AVG(approval_timestamp - purchase_timestamp) AS avg_approval_time
FROM orders
GROUP BY quarter_timestamp
ORDER BY quarter_timestamp;
-- As the number of purchases change over the quarters, it is hard to see the changes in the average approval time.
-- For quarters with more than 5 thousands observations, the average approval time ranges from approximately 8 hours 20 minutes to more than 11 hours

--sql 8: average carrier delivery time since approval
SELECT
	AVG(delivered_carrier_date - approval_timestamp) AS average_carrier_delivery_time
FROM orders;
-- The average carrier delivery time since approval is more than 2 days 19 hours

--sql 9: changes in the average carrier delivery time over time
SELECT
	DATE_PART('year', purchase_timestamp) || ' Q' || DATE_PART('quarter', purchase_timestamp) AS quarter_timestamp,
	COUNT(order_id) AS no_purchases,
	AVG(delivered_carrier_date - approval_timestamp) AS average_carrier_delivery_time
FROM orders
GROUP BY quarter_timestamp
ORDER BY quarter_timestamp;
-- Similarly, as the number of orders changes over the quarters, the changes in the average carrier delivery time might not be comparable.
-- For quarters with more than 5 thousands observations, the average delivery time seems to be decreasing

--sql 10: average delivery time of the carrier
SELECT
	AVG(delivered_customer_date - delivered_carrier_date) AS average_customer_delivery_time
FROM orders;

--sql 11: changes in the average customer delivery time
SELECT
	DATE_PART('year', purchase_timestamp) || ' Q' || DATE_PART('quarter', purchase_timestamp) AS quarter_timestamp,
	COUNT(order_id) AS no_purchases,
	AVG(delivered_customer_date - delivered_carrier_date) AS average_customer_delivery_time
FROM orders
GROUP BY quarter_timestamp
ORDER BY quarter_timestamp;
-- For quarters with more than 5 thousands observations, the average customer delivery time ranges from more than 5 days to over 11 days.

--sql 12: common purchasing day during the week
SELECT
	CASE WHEN EXTRACT(DOW FROM purchase_timestamp) = 0 THEN '0_Sunday'
		 WHEN EXTRACT(DOW FROM purchase_timestamp) = 1 THEN '1_Monday'
		 WHEN EXTRACT(DOW FROM purchase_timestamp) = 2 THEN '2_Tuesday'
		 WHEN EXTRACT(DOW FROM purchase_timestamp) = 3 THEN '3_Wednesday'
		 WHEN EXTRACT(DOW FROM purchase_timestamp) = 4 THEN '4_Thursday'
		 WHEN EXTRACT(DOW FROM purchase_timestamp) = 5 THEN '5_Friday'
		 ELSE '6_Saturday' END AS day_of_week,
	COUNT(order_id) AS order_count
FROM orders
GROUP BY day_of_week
ORDER BY day_of_week;
-- The number of orders peaks on Monday and decreases through the week and reaches its minimum on Saturday

--sql 13: common delivery time during the day
SELECT
	DATE_PART('hour', delivered_customer_date) AS delivery_hour,
	COUNT(order_id)
FROM orders
WHERE delivered_customer_date IS NOT NULL
GROUP BY purchase_hour
ORDER BY purchase_hour;
-- The customer delivery time might be misleading because it ranges from 0:00 to 24:00 so it might be the case
-- that the devlivery time is reported later than when the actual deliver took place
-- The delivery frequency increases from 9am and peaks at 18pm then decreases after that

--sql 14: common delivery day during the week
SELECT
	CASE WHEN EXTRACT(DOW FROM delivered_customer_date) = 0 THEN '0_Sunday'
		 WHEN EXTRACT(DOW FROM delivered_customer_date) = 1 THEN '1_Monday'
		 WHEN EXTRACT(DOW FROM delivered_customer_date) = 2 THEN '2_Tuesday'
		 WHEN EXTRACT(DOW FROM delivered_customer_date) = 3 THEN '3_Wednesday'
		 WHEN EXTRACT(DOW FROM delivered_customer_date) = 4 THEN '4_Thursday'
		 WHEN EXTRACT(DOW FROM delivered_customer_date) = 5 THEN '5_Friday'
		 ELSE '6_Saturday' END AS day_of_week,
	COUNT(order_id) AS delivery_count
FROM orders
GROUP BY day_of_week
ORDER BY day_of_week;
-- The deliveries happen mostly on Monday and decrease through the week, some deliveries are made even on weekends

--sql 15: accuracy of the estimated delivery date
SELECT
	SUM(CASE WHEN delivered_customer_date < estimated_delivery_date THEN 1 ELSE 0 END) / COUNT(delivered_customer_date) :: NUMERIC AS estimate_accuracy
FROM orders;
-- the average accuracy is around 92 precents

--sql 16: change in the accuracy of the estimated delivery date over time
SELECT
	DATE_PART('year', purchase_timestamp) || ' Q' || DATE_PART('quarter', purchase_timestamp) AS quarter_timestamp,
	COUNT(delivered_customer_date) AS no_available_delivery_date,
	ROUND(SUM(CASE WHEN delivered_customer_date < estimated_delivery_date THEN 1 ELSE 0 END) / COUNT(delivered_customer_date) :: NUMERIC * 100, 2) AS estimate_accuracy
FROM orders
GROUP BY quarter_timestamp
HAVING COUNT(delivered_customer_date) > 0
ORDER BY quarter_timestamp;
-- the average estimate accuracy is not stable throughout the given period

-------------------------------------------------------------------------------------------------------------------------------------------
-- 6. ORDER ITEMS:
-- Questions:
-- What is the product-order ratio?
-- Who are the top 1% sellers in terms of product counts?
-- What are the descriptive statistics for the price?
-- What are the descriptive statistics for the freight_value?
-------------------------------------------------------------------------------------------------------------------------------------------

--sql 1: showing order data
SELECT * FROM order_items ORDER BY price DESC LIMIT 10;

--sql 2: product-order ratio
SELECT COUNT(DISTINCT order_id) AS order_count,
	   COUNT(DISTINCT product_id) AS product_count,
	   ROUND(COUNT(DISTINCT order_id) / COUNT(DISTINCT product_id) :: NUMERIC, 2) AS product_order_ratio
FROM order_items;
-- The product-order ratio is approximately 3, which is a rough proxy indicating that a product is ordered three times on average

-- sql 3: top 1% sellers
SELECT COUNT(DISTINCT seller_id) / 100 FROM order_items;
-- 1 percent sellers is 30
WITH cte AS (
	SELECT
		seller_id,
		COUNT(product_id) AS product_count
	FROM order_items
	GROUP BY seller_id
	ORDER BY product_count DESC
)
SELECT
	seller_id,
	product_count,
	ROUND(product_count /
		SUM(product_count) OVER() * 100, 2) AS percentage_product_count,
	ROUND(SUM(product_count) OVER(ORDER BY product_count DESC RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) /
		SUM(product_count) OVER() * 100, 2) AS accumulated_percentage_product_count
FROM cte
LIMIT 30;
-- 1% sellers account for more than 26 percents of products sold

-- sql 4: descriptive statistics
SELECT
	1 AS variable_no,
	'price' AS variable,
	COUNT(DISTINCT price) AS n,
	ROUND(AVG(price), 2) AS mean,
	ROUND(STDDEV_SAMP(price), 2) AS sample_stddev,
	MAX(price) AS max,
	MIN(price) AS min,
	MODE() WITHIN GROUP (ORDER BY price) AS mode,
	PERCENTILE_CONT(0.01) WITHIN GROUP (ORDER BY price) AS "01_percentile",
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY price) AS "25_percentile",
	PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY price) AS median,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY price) AS "75_percentile",
	PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY price) AS "99_percentile"
FROM order_items
WHERE price IS NOT NULL
UNION
SELECT
	2 AS variable_no,
	'freight_value' AS variable,
	COUNT(DISTINCT freight_value) AS n,
	ROUND(AVG(freight_value), 2) AS mean,
	ROUND(STDDEV_SAMP(freight_value), 2) AS sample_stddev,
	MAX(freight_value) AS max,
	MIN(freight_value) AS min,
	MODE() WITHIN GROUP (ORDER BY freight_value) AS mode,
	PERCENTILE_CONT(0.01) WITHIN GROUP (ORDER BY freight_value) AS "01_percentile",
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY freight_value) AS "25_percentile",
	PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY freight_value) AS median,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY freight_value) AS "75_percentile",
	PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY freight_value) AS "99_percentile"
FROM order_items
WHERE freight_value IS NOT NULL
ORDER BY variable_no;

-------------------------------------------------------------------------------------------------------------------------------------------
-- 7. ORDER PAYMENTS:
-- Questions:
-- What are the shares of payment types?
-- What are the descriptive statistics of payment_sequential?
-- What are the descriptive statistics of payment_installments?
-- What are the descriptive statistics of payment_value?
-- What is the total value of the top 1% order in terms of payment_value?
-------------------------------------------------------------------------------------------------------------------------------------------

--sql 1: showing data
SELECT * FROM order_payments LIMIT 10;

--sql 2: shares of payment types
WITH cte AS (
SELECT
	payment_type,
	COUNT(payment_type) AS payment_count
FROM order_payments
GROUP BY payment_type
ORDER BY payment_count DESC
)
SELECT
	payment_type,
	payment_count,
	ROUND(payment_count / SUM(payment_count) OVER() * 100, 2) AS share_of_payment_type,
	ROUND(SUM(payment_count) OVER (ORDER BY payment_count DESC RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / SUM(payment_count) OVER() * 100, 2) AS accumulated_share
FROM cte
ORDER BY payment_count DESC;
-- Credit_card and boleto account for approximately 93% of the payment type

--sql 3: descriptive statistics
SELECT
	1 AS variable_no,
	'payment_sequential' AS variable,
	COUNT(DISTINCT payment_sequential) AS n,
	ROUND(AVG(payment_sequential), 2) AS mean,
	ROUND(STDDEV_SAMP(payment_sequential), 2) AS sample_stddev,
	MAX(payment_sequential) AS max,
	MIN(payment_sequential) AS min,
	MODE() WITHIN GROUP (ORDER BY payment_sequential) AS mode,
	PERCENTILE_CONT(0.01) WITHIN GROUP (ORDER BY payment_sequential) AS "01_percentile",
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY payment_sequential) AS "25_percentile",
	PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY payment_sequential) AS median,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY payment_sequential) AS "75_percentile",
	PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY payment_sequential) AS "99_percentile"
FROM order_payments
WHERE payment_sequential IS NOT NULL
UNION
SELECT
	2 AS variable_no,
	'payment_installments' AS variable,
	COUNT(DISTINCT payment_installments) AS n,
	ROUND(AVG(payment_installments), 2) AS mean,
	ROUND(STDDEV_SAMP(payment_installments), 2) AS sample_stddev,
	MAX(payment_installments) AS max,
	MIN(payment_installments) AS min,
	MODE() WITHIN GROUP (ORDER BY payment_installments) AS mode,
	PERCENTILE_CONT(0.01) WITHIN GROUP (ORDER BY payment_installments) AS "01_percentile",
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY payment_installments) AS "25_percentile",
	PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY payment_installments) AS median,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY payment_installments) AS "75_percentile",
	PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY payment_installments) AS "99_percentile"
FROM order_payments
WHERE payment_installments IS NOT NULL
UNION
SELECT
	3 AS variable_no,
	'payment_value' AS variable,
	COUNT(DISTINCT payment_value) AS n,
	ROUND(AVG(payment_value), 2) AS mean,
	ROUND(STDDEV_SAMP(payment_value), 2) AS sample_stddev,
	MAX(payment_value) AS max,
	MIN(payment_value) AS min,
	MODE() WITHIN GROUP (ORDER BY payment_value) AS mode,
	PERCENTILE_CONT(0.01) WITHIN GROUP (ORDER BY payment_value) AS "01_percentile",
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY payment_value) AS "25_percentile",
	PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY payment_value) AS median,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY payment_value) AS "75_percentile",
	PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY payment_value) AS "99_percentile"
FROM order_payments
WHERE payment_value IS NOT NULL;

--sql 4: value of the top 1% orders
SELECT COUNT(order_id)/100 FROM order_payments;
--top 1% order consists of 1,038 orders
WITH cte AS (
	SELECT
		order_id,
		SUM(payment_value) AS order_value
	FROM order_payments
	GROUP BY order_id
	ORDER BY order_value DESC
)
SELECT
	order_id,
	order_value,
	ROUND(order_value / SUM(order_value) OVER() * 100, 4) AS order_value_share,
	ROUND(SUM(order_value) OVER(ORDER BY order_value DESC RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / SUM(order_value) OVER() * 100, 4) AS accumulated_share
FROM cte
ORDER BY accumulated_share
LIMIT 1038;
-- The top 1% order account for approximately 11% value share

-------------------------------------------------------------------------------------------------------------------------------------------
-- 7. ORDER REVIEWS:
-- Questions:
-- What are the descriptive statistics of rating?
-- What is the average answering time?
-- How does the average answer time change over time?
-------------------------------------------------------------------------------------------------------------------------------------------

--sql 1: showing data
SELECT * FROM order_reviews LIMIT 10;

--sql 2: descriptive statistics of rating
SELECT
	1 AS variable_no,
	'rating' AS variable,
	COUNT(DISTINCT rating) AS n,
	ROUND(AVG(rating), 2) AS mean,
	ROUND(STDDEV_SAMP(rating), 2) AS sample_stddev,
	MAX(rating) AS max,
	MIN(rating) AS min,
	MODE() WITHIN GROUP (ORDER BY rating) AS mode,
	PERCENTILE_CONT(0.01) WITHIN GROUP (ORDER BY rating) AS "01_percentile",
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY rating) AS "25_percentile",
	PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY rating) AS median,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY rating) AS "75_percentile",
	PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY rating) AS "99_percentile"
FROM order_reviews
WHERE rating IS NOT NULL;

--sql 3: average answering time
SELECT
	AVG(answer_timestamp - creation_timestamp) AS average_answering_time
FROM order_reviews;
-- it takes more than two days on average for a review to be answered

--sql 4: changes of answering time over time
SELECT
	DATE_PART('year', creation_timestamp) || ' Q' || DATE_PART('quarter', creation_timestamp) AS quarter_timestamp,
	COUNT(answer_timestamp) AS no_observations,
	AVG(answer_timestamp - creation_timestamp) AS average_answering_time
FROM order_reviews
GROUP BY quarter_timestamp
ORDER BY quarter_timestamp;
-- with periods having more than 4 thousands reviews, the average answering time ranges from more than three days to more than two days
