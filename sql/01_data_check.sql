SELECT 'customers' AS table_name, COUNT(*) AS cnt FROM portfolio.customers
UNION ALL
SELECT 'orders', COUNT(*) FROM portfolio.orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM portfolio.order_items
UNION ALL
SELECT 'order_payments', COUNT(*) FROM portfolio.order_payments
UNION ALL
SELECT 'products', COUNT(*) FROM portfolio.products
UNION ALL
SELECT 'category_translation', COUNT(*) FROM portfolio.category_translation;