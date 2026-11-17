-- CREATE TABLE: products
-- Create this table FIRST, because the orders table
-- refers to it through a foreign key.

CREATE TABLE products (
    product_id      INTEGER PRIMARY KEY,
    product_name    VARCHAR(100)  NOT NULL,
    category        VARCHAR(50),
    price           NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    stock_quantity  INTEGER       NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    is_available    BOOLEAN       NOT NULL DEFAULT TRUE,
    added_on        DATE
);

-- CREATE TABLE: orders
-- Create this table SECOND, after products exists.

CREATE TABLE orders (
    order_id        INTEGER PRIMARY KEY,
    product_id      INTEGER NOT NULL,
    quantity        INTEGER NOT NULL CHECK (quantity > 0),
    order_date      DATE,
    customer_name   VARCHAR(100),
    payment_method  VARCHAR(50),
    CONSTRAINT fk_orders_product
        FOREIGN KEY (product_id) REFERENCES products (product_id)
);

select * from products;

-- Q1. Show each order along with the product name and price

SELECT o.order_id,
       o.customer_name,
       p.product_name,
       p.price,
       o.quantity
FROM orders o
JOIN products p ON o.product_id = p.product_id;

-- Q2. Show all products even if they were never ordered

SELECT p.product_id,
       p.product_name,
       o.order_id,
       o.quantity
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id;

-- Q3. Show orders for only 'Electronics' category

SELECT o.order_id,
       o.customer_name,
       p.product_name,
       p.category,
       o.quantity,
       o.order_date
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE p.category = 'Electronics';

-- Q4. List all orders sorted by product price (high to low)

SELECT o.order_id,
       p.product_name,
       p.price,
       o.quantity
FROM orders o
JOIN products p ON o.product_id = p.product_id
ORDER BY p.price DESC;

-- Q5. Show number of orders placed for each product

SELECT p.product_id,
       p.product_name,
       COUNT(o.order_id) AS total_orders
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_orders DESC;

-- Q6. Show total revenue earned per product

SELECT p.product_id,
       p.product_name,
       COALESCE(SUM(o.quantity * p.price), 0) AS total_revenue
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC;

-- Q7. Show products where total order revenue > 

SELECT p.product_id,
       p.product_name,
       SUM(o.quantity * p.price) AS total_revenue
FROM products p
JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(o.quantity * p.price) > 2000
ORDER BY total_revenue DESC

-- Q8. Show unique customers who ordered 'Fitness' products

SELECT DISTINCT o.customer_name
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE p.category = 'Fitness';






