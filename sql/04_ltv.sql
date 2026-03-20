##4.1 LTV по клиентам
SELECT
    o.customer_id,
    ROUND(SUM(oi.price), 2) AS ltv
FROM portfolio.orders o
JOIN portfolio.order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY o.customer_id
ORDER BY ltv DESC;

##4.2 Средний LTV
SELECT
    ROUND(AVG(ltv), 2) AS avg_ltv
FROM (
    SELECT
        o.customer_id,
        SUM(oi.price) AS ltv
    FROM portfolio.orders o
    JOIN portfolio.order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status NOT IN ('canceled', 'unavailable')
    GROUP BY o.customer_id
) t;

##4.3 LTV по customer_unique_id + users / avg / median / max
WITH customer_ltv AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS orders_cnt,
        SUM(op.payment_value) AS total_revenue
    FROM portfolio.orders o
    JOIN portfolio.customers c
        ON o.customer_id = c.customer_id
    JOIN portfolio.order_payments op
        ON o.order_id = op.order_id
    WHERE o.order_status NOT IN ('canceled', 'unavailable')
    GROUP BY c.customer_unique_id
)

SELECT
    COUNT(*) AS users,
    ROUND(AVG(total_revenue), 2) AS avg_ltv,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_revenue)::numeric, 2) AS median_ltv,
    ROUND(MAX(total_revenue), 2) AS max_ltv
FROM customer_ltv;

##4.4 LTV-сегментация по квартилям
WITH customer_ltv AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS orders_cnt,
        SUM(op.payment_value) AS total_revenue
    FROM portfolio.orders o
    JOIN portfolio.customers c
        ON o.customer_id = c.customer_id
    JOIN portfolio.order_payments op
        ON o.order_id = op.order_id
    WHERE o.order_status NOT IN ('canceled', 'unavailable')
    GROUP BY c.customer_unique_id
)

SELECT
    COUNT(*) AS users,
    ROUND(AVG(total_revenue), 2) AS avg_ltv,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_revenue)::numeric, 2) AS median_ltv,
    ROUND(MAX(total_revenue), 2) AS max_ltv
FROM customer_ltv;

##4.5 Когортный LTV
WITH customer_ltv AS (
    SELECT
        c.customer_unique_id,
        SUM(op.payment_value) AS total_revenue
    FROM portfolio.orders o
    JOIN portfolio.customers c
        ON o.customer_id = c.customer_id
    JOIN portfolio.order_payments op
        ON o.order_id = op.order_id
    WHERE o.order_status NOT IN ('canceled', 'unavailable')
    GROUP BY c.customer_unique_id
),

segmented AS (
    SELECT
        customer_unique_id,
        total_revenue,
        NTILE(4) OVER (ORDER BY total_revenue) AS segment
    FROM customer_ltv
)

SELECT
    segment,
    COUNT(*) AS users,
    ROUND(AVG(total_revenue), 2) AS avg_ltv,
    ROUND(MIN(total_revenue), 2) AS min_ltv,
    ROUND(MAX(total_revenue), 2) AS max_ltv
FROM segmented
GROUP BY segment
ORDER BY segment;