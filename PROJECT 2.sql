
-- DATABASE SETUP
create database project;
use project;

select * from brands;
select * from categories;
select * from customer;
select * from order_items;
select * from orders;
select * from products;
select * from staffs;
select * from stocks;
select * from stores;

-- DATA EXPLORATION AND CLEANING
# COUNTS OF DATA IN TABLES
SELECT COUNT(*) FROM BRANDS;
SELECT COUNT(*) FROM CATEGORIES;
SELECT COUNT(*) FROM CUSTOMER;
SELECT COUNT(*) FROM ORDER_ITEMS;
SELECT COUNT(*) FROM ORDERS;
SELECT COUNT(*) FROM PRODUCTS;
SELECT COUNT(*) FROM STAFFS;
SELECT COUNT(*) FROM STOCKS;
SELECT COUNT(*) FROM STORES;

# UNIQUE CUSTOMER IN DATASET
SELECT COUNT(DISTINCT CUSTOMER_ID) AS UNIQUE_CUSTOMERS FROM CUSTOMER;

# CATEGORY COUNT
SELECT DISTINCT BRAND_ID, BRAND_NAME FROM BRANDS;
SELECT DISTINCT CATEGORY_NAME , CATEGORY_ID FROM CATEGORIES;
SELECT DISTINCT PRODUCT_ID, PRODUCT_NAME FROM PRODUCTS;

#IDENTIFYING NULL VALUES
SELECT * FROM BRANDS 
WHERE BRAND_ID IS NULL OR BRAND_NAME IS NULL;


SELECT * FROM CATEGORIES 
WHERE Category_Id IS NULL OR Category_Name IS NULL;


SELECT * FROM CUSTOMER 
WHERE 
    Customer_Id IS NULL OR First_Name IS NULL OR Last_Name IS NULL OR 
    Phone IS NULL OR Email IS NULL OR Street IS NULL OR City IS NULL OR State IS NULL OR Zip_Code
    IS NULL; -- HAS 1267 NULL


SELECT * FROM ORDER_ITEMS
WHERE Order_Id IS NULL OR Item_Id IS NULL OR
Product_Id IS NULL OR Quantity IS NULL OR List_Price IS NULL OR Discount IS NULL;


SELECT * FROM ORDERS 
WHERE Order_Id IS NULL OR
Customer_Id IS NULL OR Order_Status IS NULL OR
Order_Date IS NULL OR Required_Date IS NULL OR Shipped_Date IS NULL OR
Store_Id IS NULL OR Staff_Id IS NULL; -- HAS 170 NULL

SELECT * FROM PRODUCTS 
WHERE Product_Id IS NULL OR
Product_Name IS NULL OR Brand_Id IS NULL OR
Category_Id IS NULL OR Model_Year IS NULL OR
List_Price IS NULL;

SELECT * FROM STAFFS
WHERE Staff_Id IS NULL OR
First_Name IS NULL OR Last_Name IS NULL OR
Email IS NULL OR Phone IS NULL OR Active IS NULL OR
Store_Id IS NULL OR Manager_Id IS NULL; -- HAS 1 NULL

SELECT * FROM STOCKS 
WHERE Store_Id IS NULL OR
Product_Id IS NULL OR
Quantity IS NULL;

SELECT * FROM STORES 
WHERE Store_Id IS NULL OR
Store_Name IS NULL OR
Phone IS NULL OR
Email IS NULL OR
Street IS NULL OR
City IS NULL OR
State IS NULL OR
Zip_Code IS NULL;

#  IDENTIFYING DUPLICATES
SELECT *, COUNT(*) 
FROM Brands
GROUP BY 
Brand_Id, Brand_Name
Having count(*) > 1;

SELECT *, COUNT(*) 
FROM Categories
GROUP BY 
Category_Id, Category_Name
Having count(*) > 1;


SELECT *, COUNT(*) 
FROM customer
GROUP BY 
    customer_id, first_name, last_name, phone, email, street, city, state, zip_code
HAVING COUNT(*) > 1;

SELECT *, COUNT(*) 
FROM order_items
GROUP BY 
    Order_Id, Item_Id ,Product_Id ,Quantity ,List_Price, Discount
HAVING COUNT(*) > 1;

SELECT *, COUNT(*) 
FROM orders
GROUP BY 
    Order_Id, Customer_Id ,Order_Status ,Order_Date, Required_Date, Shipped_Date ,Store_Id, Staff_Id
HAVING COUNT(*) > 1;

SELECT *, COUNT(*) 
FROM products
GROUP BY 
   Product_Id, Product_Name, Brand_Id, Category_Id, Model_Year, List_Price
HAVING COUNT(*) > 1;

SELECT *, COUNT(*) 
FROM staffs
GROUP BY 
  Staff_Id, First_Name, Last_Name, Email, Phone, Active, Store_Id ,Manager_Id
HAVING COUNT(*) > 1;

SELECT *, COUNT(*) 
FROM stocks
GROUP BY 
  Store_Id, Product_Id, Quantity
HAVING COUNT(*) > 1;

SELECT *, COUNT(*) 
FROM stores
GROUP BY 
  Store_Id, Store_Name, Phone, Email, Street, City, State, Zip_Code
HAVING COUNT(*) > 1;

# FIXING NULL 

UPDATE customer
SET phone = 'NA'
WHERE phone IS NULL;    

UPDATE orders
SET Shipped_Date = 'NA'
WHERE Shipped_Date IS NULL; 

UPDATE staff
SET Manager_Id = 'NA'
WHERE Manager_Id IS NULL;

--


    
    
    
#TOTAL ORDERS
SELECT COUNT(*) AS Total_orders
FROM orders;

#TOTAL CUSTOMERS
SELECT COUNT(*) AS total_customers
FROM customer;

#TOTAL REVENUE
SELECT ROUND(SUM(quantity * list_price), 2) AS total_revenue
FROM order_items;

#AFTER 2018
SELECT * FROM orders
WHERE order_date > '2015-01-01';

#TOP 5 EXPENSIVE PRODUCTS
SELECT product_name, list_price
FROM products
ORDER BY list_price DESC
LIMIT 5;

# AVERAGE PRODUCT PRICE
SELECT ROUND(AVG(list_price), 2) AS avg_price
FROM products;

# CUSTOMERS PER CITY
SELECT city, COUNT(*) AS total_customers
FROM customer
GROUP BY city;

# ORDERS PER CUSTOMER
SELECT customer_id, COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id;

# PRODUCTS PER CATEGORY
SELECT category_id, COUNT(*) AS total_products
FROM products
GROUP BY category_id;

# ORDERS WITH CUSTOMER NAMES
SELECT o.order_id, c.first_name, c.last_name
FROM orders o
JOIN customer c 
ON o.customer_id = c.customer_id;

# PRODUCTS WITH CATEGORY NAME
SELECT p.product_name, c.category_name
FROM products p
JOIN categories c 
ON p.category_id = c.category_id;

# CUSTOMERS WHO NEVER ORDERED
SELECT * FROM customer
WHERE customer_id NOT IN (
    SELECT customer_id FROM orders);
    
# TOTAL ORDERS PER STORE
SELECT store_id, COUNT(*) AS total_orders
FROM orders
GROUP BY store_id;

# ORDERS BY STATUS
SELECT order_status, COUNT(*) AS total
FROM orders
GROUP BY order_status;

# LOW STOCK PRODUCTS
SELECT * FROM stocks
WHERE quantity < 10;

# OUT OF STOCK PRODUCTS
SELECT * FROM stocks
WHERE quantity = 0;

# ORDER HANDLED BY EACH STAFF
SELECT staff_id, COUNT(order_id) AS total_orders
FROM orders
GROUP BY staff_id;

# REGULAR CUSTOMERS
SELECT customer_id, COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;

# MOST EXPENSIVE PRODUCTS
SELECT product_name, list_price
FROM products
ORDER BY list_price DESC
LIMIT 10;

# REVENUE OVER TIME
SELECT 
    o.order_date,
    ROUND(SUM(oi.quantity * oi.list_price), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_date
ORDER BY o.order_date;

# REVENUE BY STORES
SELECT 
    s.store_name,
    ROUND(SUM(oi.quantity * oi.list_price), 2) AS revenue
FROM stores s
JOIN orders o ON s.store_id = o.store_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY s.store_name;


# MONTHLY SALES TREND
SELECT 
    YEAR(STR_TO_DATE(order_date, '%Y-%m-%d')) AS year,
    MONTH(STR_TO_DATE(order_date, '%Y-%m-%d')) AS month,
    ROUND(SUM(oi.quantity * oi.list_price), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY year, month
ORDER BY year;

# DAILY SALES TREND
SELECT 
    o.order_date,
    ROUND(SUM(oi.quantity * oi.list_price), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_date
ORDER BY o.order_date;

# CITY WITH MOST CUSTOMERS
SELECT 
    city,
    COUNT(*) AS total_customers
FROM customer
GROUP BY city
ORDER BY total_customers DESC
LIMIT 1;

# STATE WITH MORE CUSTOMERS
SELECT 
    state,
    COUNT(*) AS total_customers
FROM customer
GROUP BY state
ORDER BY total_customers DESC
LIMIT 1;

# BEST SELLING STORE
SELECT 
    s.store_name,
    ROUND(SUM(oi.quantity * oi.list_price), 2) AS revenue
FROM stores s
JOIN orders o ON s.store_id = o.store_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY s.store_name
ORDER BY revenue DESC
LIMIT 1;


# LEAST SELLING STORE
SELECT 
    s.store_name,
    ROUND(SUM(oi.quantity * oi.list_price), 2) AS revenue
FROM stores s
JOIN orders o ON s.store_id = o.store_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY s.store_name
ORDER BY revenue ASC
LIMIT 1;

# SALES PER PRODUCT
SELECT 
    p.product_name,
    ROUND(SUM(oi.quantity * oi.list_price), 2) AS total_sales
FROM order_items oi
JOIN products p 
    ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_sales DESC;