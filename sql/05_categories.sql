##5.1 Топ-10 категорий по выручке
SELECT
    COALESCE(ct.product_category_name_english, p.product_category_name, 'unknown') AS category,
    ROUND(SUM(oi.price), 2) AS revenue
FROM portfolio.order_items oi
JOIN portfolio.products p
    ON oi.product_id = p.product_id
LEFT JOIN portfolio.category_translation ct
    ON p.product_category_name = ct.product_category_name
JOIN portfolio.orders o
    ON oi.order_id = o.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY COALESCE(ct.product_category_name_english, p.product_category_name, 'unknown')
ORDER BY revenue DESC
LIMIT 10;

##5.2 Топ-10 категорий с долей в выручке
SELECT
    COALESCE(ct.product_category_name_english, p.product_category_name, 'unknown') AS category,
    ROUND(SUM(oi.price), 2) AS revenue
FROM portfolio.order_items oi
JOIN portfolio.products p
    ON oi.product_id = p.product_id
LEFT JOIN portfolio.category_translation ct
    ON p.product_category_name = ct.product_category_name
JOIN portfolio.orders o
    ON oi.order_id = o.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY COALESCE(ct.product_category_name_english, p.product_category_name, 'unknown')
ORDER BY revenue DESC
LIMIT 10;

##5.3 Выручка по штатам
SELECT
    c.customer_state,
    ROUND(SUM(oi.price), 2) AS revenue
FROM portfolio.orders o
JOIN portfolio.order_items oi
    ON o.order_id = oi.order_id
JOIN portfolio.customers c
    ON o.customer_id = c.customer_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY c.customer_state
ORDER BY revenue DESC;

##5.4 Средняя стоимость доставки по категориям
SELECT
    COALESCE(ct.product_category_name_english, p.product_category_name, 'unknown') AS category,
    ROUND(AVG(oi.freight_value), 2) AS avg_freight
FROM portfolio.order_items oi
JOIN portfolio.products p
    ON oi.product_id = p.product_id
LEFT JOIN portfolio.category_translation ct
    ON p.product_category_name = ct.product_category_name
JOIN portfolio.orders o
    ON oi.order_id = o.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY COALESCE(ct.product_category_name_english, p.product_category_name, 'unknown')
ORDER BY avg_freight DESC
LIMIT 10;