-- ------------------------------------------------------------------
-- 0). First, How Many Rows are in the Products Table?
-- ------------------------------------------------------------------
SELECT COUNT(`id`) AS Num_Products
FROM northwind.products;
-- There are 45 rows in products

-- ------------------------------------------------------------------
-- 1). Product Name and Unit/Quantity
-- ------------------------------------------------------------------
SELECT product_name, quantity_per_unit FROM northwind.products;
 
 


-- ------------------------------------------------------------------
-- 2). Product ID and Name of Current Products
-- ------------------------------------------------------------------
SELECT * FROM northwind.products;
SELECT id AS product_id
, product_name
FROM northwind.products
 WHERE discontinued <> 1;
-- 0 means not discontinued, 1 means discontinued

-- ------------------------------------------------------------------
-- 3). Product ID and Name of Discontinued Products
-- ------------------------------------------------------------------
SELECT id AS product_id
, product_name
FROM northwind.products
 WHERE discontinued <> 0;
 -- no products have been discontinued
 SELECT id AS product_id
, product_name
FROM northwind.products
 WHERE discontinued is null;


-- ------------------------------------------------------------------
-- 4). Name & List Price of Most & Least Expensive Products
-- ------------------------------------------------------------------
SELECT * FROM northwind.products;
SELECT product_name, list_price
FROM northwind.products
WHERE list_price = (SELECT MIN(list_price) FROM northwind.products)
OR list_price = (SELECT MAX(list_price) FROM northwind.products);


-- ------------------------------------------------------------------
-- 5). Product ID, Name & List Price Costing Less Than $20
-- ------------------------------------------------------------------
SELECT product_code, product_name, list_price
FROM northwind.products
WHERE list_price < 20;

-- ------------------------------------------------------------------
-- 6). Product ID, Name & List Price Costing Between $15 and $20
-- ------------------------------------------------------------------
SELECT product_code, product_name, list_price
FROM northwind.products
WHERE list_price BETWEEN 15 AND 20;



-- ------------------------------------------------------------------
-- 7). Product Name & List Price Costing Above Average List Price
-- ------------------------------------------------------------------
SELECT product_name, list_price
FROM northwind.products
WHERE list_price > (SELECT AVG(list_price) FROM northwind.products);


-- ------------------------------------------------------------------
-- 8). Product Name & List Price of 10 Most Expensive Products 
-- ------------------------------------------------------------------
SELECT product_name, list_price
FROM northwind.products
ORDER BY list_price DESC
LIMIT 10;


-- ------------------------------------------------------------------ 
-- 9). Count of Current and Discontinued Products 
-- ------------------------------------------------------------------
SELECT COUNT(`id`) AS Num_Current_Products
FROM northwind.products
WHERE discontinued <> 1;

SELECT COUNT(`id`) AS Num_Discontinued_Products
FROM northwind.products
WHERE discontinued <> 0;

-- ------------------------------------------------------------------
-- 10). Product Name, Units on Order and Units in Stock
--      Where Quantity In-Stock is Less Than the Quantity On-Order. 
-- ------------------------------------------------------------------
SELECT product_name, 
target_level AS units_on_order,
reorder_level AS units_in_stock
FROM northwind.products
WHERE reorder_level < target_level; 


-- ------------------------------------------------------------------
-- EXTRA CREDIT -----------------------------------------------------
-- ------------------------------------------------------------------


-- ------------------------------------------------------------------
-- 11). Products with Supplier Company & Address Info
-- ------------------------------------------------------------------



-- ------------------------------------------------------------------
-- 12). Number of Products per Category With Less Than 5 Units
-- ------------------------------------------------------------------



-- ------------------------------------------------------------------
-- 13). Number of Products per Category Priced Less Than $20.00
-- ------------------------------------------------------------------
