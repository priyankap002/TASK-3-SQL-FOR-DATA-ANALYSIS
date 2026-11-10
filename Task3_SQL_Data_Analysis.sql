-- TASK 3: SQL FOR DATA ANALYSIS
-- Database: ecommerce_db
-- Tool: MySQL 8.0+
-- Run this complete script in MySQL Workbench.

CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- Reset tables so the script can be re-run
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. TABLE CREATION
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(60),
    country VARCHAR(60)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(60),
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_method VARCHAR(30),
    amount DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- 2. SAMPLE DATA
INSERT INTO customers VALUES
(1,'Aarav Sharma','Pune','India'),
(2,'Diya Patil','Mumbai','India'),
(3,'Rohan Mehta','Delhi','India'),
(4,'Ananya Joshi','Bengaluru','India'),
(5,'Kabir Shah','Nashik','India'),
(6,'Meera Kulkarni','Pune','India');

INSERT INTO products VALUES
(101,'Laptop','Electronics',55000.00),
(102,'Wireless Mouse','Accessories',800.00),
(103,'Smartphone','Electronics',25000.00),
(104,'Office Chair','Furniture',6500.00),
(105,'Notebook','Stationery',100.00),
(106,'Headphones','Accessories',2200.00);

INSERT INTO orders VALUES
(1001,1,'2026-01-05','Delivered'),
(1002,2,'2026-01-08','Delivered'),
(1003,1,'2026-02-10','Shipped'),
(1004,3,'2026-02-15','Delivered'),
(1005,4,'2026-03-01','Cancelled'),
(1006,5,'2026-03-12','Delivered');

INSERT INTO order_items VALUES
(1,1001,101,1,55000.00),
(2,1001,102,2,800.00),
(3,1002,103,1,25000.00),
(4,1002,105,5,100.00),
(5,1003,106,1,2200.00),
(6,1003,102,1,800.00),
(7,1004,104,2,6500.00),
(8,1005,103,1,25000.00),
(9,1006,101,1,55000.00),
(10,1006,106,2,2200.00);

INSERT INTO payments VALUES
(501,1001,'UPI',56600.00),
(502,1002,'Card',25500.00),
(503,1003,'UPI',3000.00),
(504,1004,'Net Banking',13000.00),
(505,1006,'Card',59400.00);

-- 3. SELECT, WHERE AND ORDER BY
-- Q1: Display all customers
SELECT * FROM customers;

-- Q2: Show products costing more than Rs. 5,000, highest price first
SELECT product_name, category, price
FROM products
WHERE price > 5000
ORDER BY price DESC;

-- 4. AGGREGATE FUNCTIONS: SUM, AVG, COUNT
-- Q3: Total sales amount from delivered orders
SELECT SUM(oi.quantity * oi.unit_price) AS total_sales
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Delivered';

-- Q4: Average product price
SELECT ROUND(AVG(price), 2) AS average_product_price
FROM products;

-- Q5: Revenue by product category
SELECT p.category,
       SUM(oi.quantity * oi.unit_price) AS category_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Delivered'
GROUP BY p.category
ORDER BY category_revenue DESC;

-- 5. JOINS: INNER JOIN
-- Q6: Show orders with customer names
SELECT o.order_id, c.customer_name, o.order_date, o.status
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_id;

-- 6. JOINS: LEFT JOIN
-- Q7: Show all customers, including customers who have not placed orders
SELECT c.customer_id, c.customer_name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

-- 7. JOINS: RIGHT JOIN
-- Q8: Show all products, including products that have never been ordered
SELECT p.product_id, p.product_name, oi.order_id
FROM order_items oi
RIGHT JOIN products p ON oi.product_id = p.product_id
ORDER BY p.product_id;

-- 8. SUBQUERY
-- Q9: Find products priced above the average product price
SELECT product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products)
ORDER BY price DESC;

-- Q10: Find customers who have placed at least one order
SELECT customer_name
FROM customers
WHERE customer_id IN (SELECT DISTINCT customer_id FROM orders);

-- 9. VIEW FOR ANALYSIS
-- Q11: Create a view containing delivered order revenue
CREATE OR REPLACE VIEW delivered_order_revenue AS
SELECT o.order_id, c.customer_name, o.order_date,
       SUM(oi.quantity * oi.unit_price) AS order_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Delivered'
GROUP BY o.order_id, c.customer_name, o.order_date;

-- Q12: Analyze the view
SELECT * FROM delivered_order_revenue
ORDER BY order_revenue DESC;

-- 10. INDEXING / QUERY OPTIMIZATION
-- Indexes help MySQL locate rows faster for frequently filtered/joined columns.
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_status_date ON orders(status, order_date);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

-- Q13: Inspect the execution plan for a filtered order query
EXPLAIN
SELECT order_id, order_date, status
FROM orders
WHERE status = 'Delivered' AND order_date >= '2026-01-01';

-- 11. ADDITIONAL BUSINESS ANALYSIS
-- Q14: Number of orders and revenue per customer
SELECT c.customer_name,
       COUNT(DISTINCT o.order_id) AS total_orders,
       COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_order_value
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_order_value DESC;

-- END OF ASSIGNMENT
