--- data exploration
SELECT *
FROM retail.customers
LIMIT 10;

SELECT *
FROM retail.orders
LIMIT 10;

SELECT
    o.order_id,
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_date,
    o.order_status
FROM retail.orders AS o
INNER JOIN retail.customers AS c
    ON o.customer_id = c.customer_id
ORDER BY o.order_id
LIMIT 10;

SELECT *
FROM retail.order_items
LIMIT 10;


SELECT
    SUM(gross_amount) AS total_gross_sales,
    SUM(discount_amount) AS total_discounts,
    SUM(net_amount) AS total_net_sales
FROM retail.order_items;