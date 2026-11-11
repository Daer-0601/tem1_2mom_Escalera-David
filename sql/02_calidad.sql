-- Pregunta 2 - Auditoria de calidad
USE dbex_DEscalera;

SELECT
  COUNT(*) AS total_registros,
  COUNT(*) - COUNT(DISTINCT row_id) AS row_id_duplicados,
  COUNT(DISTINCT order_id) AS ordenes_unicas,
  COUNT(DISTINCT customer_id) AS clientes_unicos,
  SUM(CASE WHEN order_id IS NULL OR order_id = '' THEN 1 ELSE 0 END) AS null_order_id,
  SUM(CASE WHEN customer_id IS NULL OR customer_id = '' THEN 1 ELSE 0 END) AS null_customer_id,
  SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS fechas_pedido_invalidas,
  SUM(CASE WHEN ship_date IS NULL THEN 1 ELSE 0 END) AS fechas_envio_invalidas,
  SUM(CASE WHEN ship_date < order_date THEN 1 ELSE 0 END) AS envio_antes_pedido,
  SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END) AS null_sales,
  SUM(CASE WHEN sales <= 0 THEN 1 ELSE 0 END) AS ventas_le_cero,
  SUM(CASE WHEN discount < 0 OR discount > 1 THEN 1 ELSE 0 END) AS descuento_fuera_rango,
  SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END) AS lineas_con_perdida
FROM superstore_DEscalera;

SELECT campo, nulos FROM (
  SELECT 'customer_name' AS campo, SUM(CASE WHEN customer_name IS NULL OR customer_name = '' THEN 1 ELSE 0 END) AS nulos FROM superstore_DEscalera
  UNION ALL SELECT 'postal_code', SUM(CASE WHEN postal_code IS NULL OR postal_code = '' THEN 1 ELSE 0 END) FROM superstore_DEscalera
  UNION ALL SELECT 'product_name', SUM(CASE WHEN product_name IS NULL OR product_name = '' THEN 1 ELSE 0 END) FROM superstore_DEscalera
  UNION ALL SELECT 'sales', SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END) FROM superstore_DEscalera
  UNION ALL SELECT 'discount', SUM(CASE WHEN discount IS NULL THEN 1 ELSE 0 END) FROM superstore_DEscalera
  UNION ALL SELECT 'profit', SUM(CASE WHEN profit IS NULL THEN 1 ELSE 0 END) FROM superstore_DEscalera
) t
ORDER BY campo;
