##9.1 Топ клиентов по LTV
SELECT
    c.customer_unique_id,
    ROUND(SUM(op.payment_value), 2) AS ltv
FROM portfolio.orders o
JOIN portfolio.customers c
    ON o.customer_id = c.customer_id
JOIN portfolio.order_payments op
    ON o.order_id = op.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY c.customer_unique_id
ORDER BY ltv DESC
LIMIT 20;