##8.1 Доля заказов по статусам
SELECT
    order_status,
    COUNT(*) AS orders_cnt,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS share_pct
FROM portfolio.orders
GROUP BY order_status
ORDER BY orders_cnt DESC;