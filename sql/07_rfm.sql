##7.1 RFM-анализ
WITH rfm_base AS (
    SELECT
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp) AS last_order_date,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(op.payment_value) AS monetary
    FROM portfolio.orders o
    JOIN portfolio.customers c
        ON o.customer_id = c.customer_id
    JOIN portfolio.order_payments op
        ON o.order_id = op.order_id
    WHERE o.order_status NOT IN ('canceled', 'unavailable')
    GROUP BY c.customer_unique_id
),

rfm AS (
    SELECT
        *,
        (SELECT MAX(order_purchase_timestamp) FROM portfolio.orders) - last_order_date AS recency
    FROM rfm_base
),

rfm_scores AS (
    SELECT
        customer_unique_id,
        NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency) AS f_score,
        NTILE(5) OVER (ORDER BY monetary) AS m_score
    FROM rfm
)

SELECT
    r_score,
    f_score,
    m_score,
    COUNT(*) AS users
FROM rfm_scores
GROUP BY r_score, f_score, m_score
ORDER BY users DESC;


