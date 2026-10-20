---Understanding completed sales
select
    COUNT(DISTINCT o.order_id) AS completed_orders,
    SUM(oi.gross_amount) AS gross_sales,
    SUM(oi.discount_amount) AS total_discounts,
    SUM(oi.net_amount) AS net_sales
FROM retail.orders AS o
INNER JOIN retail.order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed';

---Analyzing order status

SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM retail.orders
GROUP BY order_status
ORDER BY total_orders DESC;

--- Calculate average order value (AOV)
WITH completed_order_totals AS (
    SELECT
        o.order_id,
        SUM(oi.net_amount) AS order_net_sales
    FROM retail.orders AS o
    INNER JOIN retail.order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY o.order_id
)
SELECT
    COUNT(*) AS completed_orders,
    ROUND(AVG(order_net_sales), 2) AS average_order_value,
    ROUND(SUM(order_net_sales), 2) AS completed_net_sales
FROM completed_order_totals;

--- The best-selling products
SELECT
    p.product_name,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.net_amount) AS total_net_sales
FROM retail.orders AS o
INNER JOIN retail.order_items AS oi
    ON o.order_id = oi.order_id
INNER JOIN retail.products AS p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_net_sales DESC
LIMIT 10;

--- The products with the lowest net sales
SELECT
    p.product_name,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.net_amount) AS total_net_sales
FROM retail.orders AS o
INNER JOIN retail.order_items AS oi
    ON o.order_id = oi.order_id
INNER JOIN retail.products AS p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_net_sales ASC
LIMIT 10;

--- Analysis of sales by product category
SELECT
    c.category_name,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.net_amount), 2) AS total_net_sales
FROM retail.orders AS o
INNER JOIN retail.order_items AS oi
    ON o.order_id = oi.order_id
INNER JOIN retail.products AS p
    ON oi.product_id = p.product_id
INNER JOIN retail.categories AS c
    ON p.category_id = c.category_id
WHERE o.order_status = 'Completed'
GROUP BY
    c.category_id,
    c.category_name
ORDER BY total_net_sales DESC;

-- Identifying  the most valuable customers

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    SUM(oi.quantity) AS units_purchased,
    ROUND(SUM(oi.net_amount), 2) AS total_net_sales
FROM retail.customers AS c
INNER JOIN retail.orders AS o
    ON c.customer_id = o.customer_id
INNER JOIN retail.order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_net_sales DESC
LIMIT 10;

-- Analyzing order status and customer behavior
 SELECT
    order_count,
    COUNT(*) AS number_of_customers
FROM (
    SELECT
        c.customer_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM retail.customers AS c
    LEFT JOIN retail.orders AS o
        ON c.customer_id = o.customer_id
       AND o.order_status = 'Completed'
    GROUP BY c.customer_id
) AS customer_orders
GROUP BY order_count
ORDER BY order_count;

--- Analyzing monthly sales trends
SELECT
    DATE_TRUNC('month', o.order_date)::date AS sales_month,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.net_amount), 2) AS net_sales
FROM retail.orders AS o
INNER JOIN retail.order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY sales_month;

-- Analyzing discounts by product category
SELECT
    c.category_name,
    ROUND(SUM(oi.gross_amount), 2) AS gross_sales,
    ROUND(SUM(oi.discount_amount), 2) AS total_discounts,
    ROUND(
        100.0 * SUM(oi.discount_amount)
        / NULLIF(SUM(oi.gross_amount), 0),
        2
    ) AS discount_percentage,
    ROUND(SUM(oi.net_amount), 2) AS net_sales
FROM retail.orders AS o
INNER JOIN retail.order_items AS oi
    ON o.order_id = oi.order_id
INNER JOIN retail.products AS p
    ON oi.product_id = p.product_id
INNER JOIN retail.categories AS c
    ON p.category_id = c.category_id
WHERE o.order_status = 'Completed'
GROUP BY
    c.category_id,
    c.category_name
ORDER BY total_discounts DESC;

--Finding  the highest-value individual orders
SELECT
    o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    COUNT(oi.order_item_id) AS number_of_line_items,
    SUM(oi.quantity) AS total_units,
    ROUND(SUM(oi.net_amount), 2) AS order_net_sales
FROM retail.orders AS o
INNER JOIN retail.customers AS c
    ON o.customer_id = c.customer_id
INNER JOIN retail.order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY
    o.order_id,
    o.order_date,
    c.first_name,
    c.last_name
ORDER BY order_net_sales DESC
LIMIT 10;

--Check data quality
SELECT
    COUNT(*) AS total_products,
    COUNT(*) FILTER (
        WHERE product_name IS NULL
           OR TRIM(product_name) = ''
    ) AS missing_product_names,
    COUNT(*) FILTER (
        WHERE list_price IS NULL
           OR list_price < 0
    ) AS invalid_prices
FROM retail.products;

-- Run only the data-quality query
SELECT
    COUNT(*) AS total_products,
    COUNT(*) FILTER (
        WHERE product_name IS NULL
           OR TRIM(product_name) = ''
    ) AS missing_product_names,
    COUNT(*) FILTER (
        WHERE list_price IS NULL
           OR list_price < 0
    ) AS invalid_prices
FROM retail.products;

-- Check customer data quality
SELECT
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (
        WHERE first_name IS NULL
           OR TRIM(first_name) = ''
    ) AS missing_first_names,
    COUNT(*) FILTER (
        WHERE last_name IS NULL
           OR TRIM(last_name) = ''
    ) AS missing_last_names,
    COUNT(*) FILTER (
        WHERE email IS NULL
           OR TRIM(email) = ''
    ) AS missing_emails,
    COUNT(*) - COUNT(DISTINCT LOWER(TRIM(email)))
        AS duplicate_email_count
FROM retail.customers;

--Check order data quality
SELECT
    COUNT(*) AS total_orders,
    COUNT(*) FILTER (
        WHERE customer_id IS NULL
    ) AS missing_customer_ids,
    COUNT(*) FILTER (
        WHERE order_date IS NULL
    ) AS missing_order_dates,
    COUNT(*) FILTER (
        WHERE order_status IS NULL
           OR TRIM(order_status) = ''
    ) AS missing_order_statuses
FROM retail.orders;

--Check order-item data quality
SELECT
    COUNT(*) AS total_order_items,
    COUNT(*) FILTER (
        WHERE order_id IS NULL
    ) AS missing_order_ids,
    COUNT(*) FILTER (
        WHERE product_id IS NULL
    ) AS missing_product_ids,
    COUNT(*) FILTER (
        WHERE quantity IS NULL OR quantity <= 0
    ) AS invalid_quantities,
    COUNT(*) FILTER (
        WHERE gross_amount IS NULL OR gross_amount < 0
    ) AS invalid_gross_amounts,
    COUNT(*) FILTER (
        WHERE discount_amount IS NULL OR discount_amount < 0
    ) AS invalid_discounts,
    COUNT(*) FILTER (
        WHERE net_amount IS NULL OR net_amount < 0
    ) AS invalid_net_amounts
FROM retail.order_items;

--Verifying sales calculations and table relationships
SELECT
    COUNT(*) AS total_order_items,
    COUNT(*) FILTER (
        WHERE NOT EXISTS (
            SELECT 1
            FROM retail.orders o
            WHERE o.order_id = oi.order_id
        )
    ) AS orphan_order_ids,
    COUNT(*) FILTER (
        WHERE NOT EXISTS (
            SELECT 1
            FROM retail.products p
            WHERE p.product_id = oi.product_id
        )
    ) AS orphan_product_ids,
    COUNT(*) FILTER (
        WHERE ABS(
            gross_amount - discount_amount - net_amount
        ) > 0.01
    ) AS inconsistent_sales_amounts
FROM retail.order_items AS oi;