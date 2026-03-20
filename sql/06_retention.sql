##6.1 Проверка повторных покупок по customer_unique_id
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS orders_cnt
FROM portfolio.orders o
JOIN portfolio.customers c
    ON o.customer_id = c.customer_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY orders_cnt DESC
LIMIT 20;

##6.2 Доля повторных клиентов
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS orders_cnt
FROM portfolio.orders o
JOIN portfolio.customers c
    ON o.customer_id = c.customer_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY orders_cnt DESC
LIMIT 20;

##6.3 Retention rate по когортам
WITH first_orders AS (
    SELECT
        c.customer_unique_id,
        DATE_TRUNC('month', MIN(o.order_purchase_timestamp)) AS cohort_month
    FROM portfolio.orders o
    JOIN portfolio.customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_status NOT IN ('canceled', 'unavailable')
    GROUP BY c.customer_unique_id
),

activity AS (
    SELECT
        c.customer_unique_id,
        DATE_TRUNC('month', o.order_purchase_timestamp) AS activity_month
    FROM portfolio.orders o
    JOIN portfolio.customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_status NOT IN ('canceled', 'unavailable')
),

cohort_table AS (
    SELECT
        f.cohort_month,
        a.activity_month,
        (
            EXTRACT(YEAR FROM a.activity_month) * 12 + EXTRACT(MONTH FROM a.activity_month)
        ) - (
            EXTRACT(YEAR FROM f.cohort_month) * 12 + EXTRACT(MONTH FROM f.cohort_month)
        ) AS month_number,
        COUNT(DISTINCT a.customer_unique_id) AS users_cnt
    FROM first_orders f
    JOIN activity a
        ON f.customer_unique_id = a.customer_unique_id
    GROUP BY f.cohort_month, a.activity_month
),

retention_table AS (
    SELECT
        cohort_month,
        month_number,
        users_cnt,
        FIRST_VALUE(users_cnt) OVER (
            PARTITION BY cohort_month
            ORDER BY month_number
        ) AS cohort_size
    FROM cohort_table
)

SELECT
    cohort_month,
    month_number,
    users_cnt,
    cohort_size,
    ROUND(users_cnt * 100.0 / cohort_size, 2) AS retention_pct
FROM retention_table
ORDER BY cohort_month, month_number;


