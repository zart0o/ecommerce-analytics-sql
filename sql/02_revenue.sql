##2.1 Дневная выручка
SELECT
    DATE(o.order_purchase_timestamp) AS order_date,
    ROUND(SUM(oi.price), 2) AS revenue
FROM portfolio.orders o
JOIN portfolio.order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY DATE(o.order_purchase_timestamp)
ORDER BY order_date;

##2.2 Аномальные пики по выручке
SELECT
    DATE(o.order_purchase_timestamp) AS order_date,
    ROUND(SUM(oi.price), 2) AS revenue
FROM portfolio.orders o
JOIN portfolio.order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY DATE(o.order_purchase_timestamp)
HAVING SUM(oi.price) > 100000
ORDER BY revenue DESC;

##2.3 Количество заказов по месяцам
SELECT
    DATE_TRUNC('month', order_purchase_timestamp) AS order_month,
    COUNT(*) AS orders_cnt
FROM portfolio.orders
WHERE order_status NOT IN ('canceled', 'unavailable')
GROUP BY DATE_TRUNC('month', order_purchase_timestamp)
ORDER BY order_month;

##2.4 Количество уникальных клиентов по месяцам
SELECT
    DATE_TRUNC('month', order_purchase_timestamp) AS order_month,
    COUNT(DISTINCT customer_id) AS customers_cnt
FROM portfolio.orders
WHERE order_status NOT IN ('canceled', 'unavailable')
GROUP BY DATE_TRUNC('month', order_purchase_timestamp)
ORDER BY order_month;