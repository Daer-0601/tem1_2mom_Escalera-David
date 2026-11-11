-- Pregunta 2 - Auditoria de calidad

USE dbex_DEscalera;

-- Resumen de calidad en una sola consulta
WITH base AS (
  SELECT
    row_id,
    order_id,
    customer_id,
    order_date,
    ship_date,
    sales,
    discount,
    profit,
    quantity,
    postal_code,
    product_name,
    from_unixtime(unix_timestamp(order_date, 'M/d/yyyy'), 'yyyy-MM-dd') AS od,
    from_unixtime(unix_timestamp(ship_date, 'M/d/yyyy'), 'yyyy-MM-dd') AS sd
  FROM superstore_DEscalera
)
SELECT
  COUNT(*) AS total_registros,
  COUNT(*) - COUNT(DISTINCT row_id) AS row_id_duplicados,
  COUNT(DISTINCT order_id) AS ordenes_unicas,
  COUNT(DISTINCT customer_id) AS clientes_unicos,
  SUM(CASE WHEN row_id IS NULL THEN 1 ELSE 0 END) AS null_row_id,
  SUM(CASE WHEN order_id IS NULL OR order_id = '' THEN 1 ELSE 0 END) AS null_order_id,
  SUM(CASE WHEN customer_id IS NULL OR customer_id = '' THEN 1 ELSE 0 END) AS null_customer_id,
  SUM(CASE WHEN order_date IS NULL OR order_date = '' THEN 1 ELSE 0 END) AS null_order_date,
  SUM(CASE WHEN ship_date IS NULL OR ship_date = '' THEN 1 ELSE 0 END) AS null_ship_date,
  SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END) AS null_sales,
  SUM(CASE WHEN discount IS NULL THEN 1 ELSE 0 END) AS null_discount,
  SUM(CASE WHEN profit IS NULL THEN 1 ELSE 0 END) AS null_profit,
  SUM(CASE WHEN product_name IS NULL OR product_name = '' THEN 1 ELSE 0 END) AS null_product_name,
  SUM(CASE WHEN od IS NULL OR sd IS NULL THEN 1 ELSE 0 END) AS fechas_invalidas,
  SUM(CASE WHEN sales <= 0 THEN 1 ELSE 0 END) AS ventas_le_cero,
  SUM(CASE WHEN discount < 0 OR discount > 1 THEN 1 ELSE 0 END) AS descuento_fuera_rango,
  SUM(CASE WHEN sd < od THEN 1 ELSE 0 END) AS envio_antes_pedido,
  SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END) AS lineas_con_perdida
FROM base;

-- Detalle de nulos por columna (por si hace falta mostrar mas fino)
SELECT
  'order_id' AS campo, SUM(CASE WHEN order_id IS NULL OR order_id = '' THEN 1 ELSE 0 END) AS nulos FROM superstore_DEscalera
UNION ALL
SELECT 'customer_name', SUM(CASE WHEN customer_name IS NULL OR customer_name = '' THEN 1 ELSE 0 END) FROM superstore_DEscalera
UNION ALL
SELECT 'postal_code', SUM(CASE WHEN postal_code IS NULL THEN 1 ELSE 0 END) FROM superstore_DEscalera
UNION ALL
SELECT 'product_name', SUM(CASE WHEN product_name IS NULL OR product_name = '' THEN 1 ELSE 0 END) FROM superstore_DEscalera
UNION ALL
SELECT 'sales', SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END) FROM superstore_DEscalera
UNION ALL
SELECT 'discount', SUM(CASE WHEN discount IS NULL THEN 1 ELSE 0 END) FROM superstore_DEscalera
UNION ALL
SELECT 'profit', SUM(CASE WHEN profit IS NULL THEN 1 ELSE 0 END) FROM superstore_DEscalera;

-- Criterios de tratamiento (comentario para el informe):
-- - row_id duplicado: quedarse con una fila (MIN/MAX) o rechazar carga
-- - fechas invalidas o envio < pedido: excluir de analisis temporal o corregir
-- - sales <= 0: revisar; en este sample no aparecen
-- - discount fuera de 0-1: recortar o excluir
-- - profit < 0: NO borrar; son perdidas reales y sirven para P6
