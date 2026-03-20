##3.1 Общий AOV
WITH order_totals AS (
    SELECT
        oi.order_id,
        SUM(oi.price) AS order_total
    FROM portfolio.order_items oi
    GROUP BY oi.order_id
)
SELECT
    ROUND(AVG(order_total), 2) AS avg_order_value
FROM order_totals;

##3.2 AOV по месяцам
WITH order_totals AS (
    SELECT
        o.order_id,
        DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
        SUM(oi.price) AS order_total
    FROM portfolio.orders o
    JOIN portfolio.order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status NOT IN ('canceled', 'unavailable')
    GROUP BY o.order_id, DATE_TRUNC('month', o.order_purchase_timestamp)
)
SELECT
    order_month,
    ROUND(AVG(order_total), 2) AS avg_order_value
FROM order_totals
GROUP BY order_month
ORDER BY order_month;