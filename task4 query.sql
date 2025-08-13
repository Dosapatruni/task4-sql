-- Use the Mini E-Commerce database
USE mini_ecommerce;

-- 1. SELECT + WHERE + ORDER BY
-- List all orders placed after August 2, 2025, sorted by date
SELECT * 
FROM orders
WHERE order_date > '2025-08-02'
ORDER BY order_date ASC;

-- 2. GROUP BY + Aggregate
-- Total orders per customer
SELECT c.name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_orders DESC;

-- 3. INNER JOIN
-- Orders with customer name and product name
SELECT o.order_id, c.name AS customer_name, p.product_name, o.quantity
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN products p ON o.product_id = p.product_id;

-- 4. LEFT JOIN
-- Show all customers and their orders (if any)
SELECT c.name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- 5. RIGHT JOIN
-- Show all products and the orders they are in
SELECT p.product_name, o.order_id
FROM products p
RIGHT JOIN orders o ON p.product_id = o.product_id;

-- 6. Subquery
-- Customers who ordered more than the average quantity
SELECT DISTINCT customer_id
FROM orders
WHERE quantity > (
    SELECT AVG(quantity) FROM orders
);

-- 7. SUM + AVG (Aggregate Functions)
-- Total spending per customer
SELECT c.name, SUM(p.price * o.quantity) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY c.name
ORDER BY total_spent DESC;

-- 8. Create View
-- Create a view showing customer spending
CREATE OR REPLACE VIEW customer_sales AS
SELECT c.name, SUM(p.price * o.quantity) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY c.name;

-- 9. Query the View
SELECT * FROM customer_sales WHERE total_spent > 500;

-- 10. Optimize with Index
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_product_id ON orders(product_id);
CREATE INDEX idx_products_category ON products(category);
