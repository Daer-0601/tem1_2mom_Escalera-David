-- Pregunta 8 - Pareto 80/20 ventas y ganancias

USE dbex_DEscalera;

-- a) Productos que concentran el 80% de ventas
WITH por_prod AS (
  SELECT
    product_id,
    MAX(product_name) AS product_name,
    ROUND(SUM(sales), 2) AS ventas
  FROM superstore_DEscalera
  GROUP BY product_id
),
ord AS (
  SELECT
    product_id,
    product_name,
    ventas,
    ROUND(ventas * 100.0 / SUM(ventas) OVER (), 4) AS pct_individual,
    ROUND(SUM(ventas) OVER (ORDER BY ventas DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
      * 100.0 / SUM(ventas) OVER (), 4) AS pct_acum,
    ROW_NUMBER() OVER (ORDER BY ventas DESC) AS n_prod
  FROM por_prod
)
SELECT
  product_id,
  product_name,
  ventas,
  pct_individual,
  pct_acum,
  n_prod
FROM ord
WHERE pct_acum <= 80 OR n_prod = (
  SELECT MIN(n_prod) FROM ord WHERE pct_acum > 80
)
ORDER BY n_prod;

-- Resumen ventas: cuantos productos llegan al 80%
WITH por_prod AS (
  SELECT product_id, SUM(sales) AS ventas
  FROM superstore_DEscalera
  GROUP BY product_id
),
ord AS (
  SELECT
    product_id,
    ventas,
    SUM(ventas) OVER (ORDER BY ventas DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
      * 100.0 / SUM(ventas) OVER () AS pct_acum,
    ROW_NUMBER() OVER (ORDER BY ventas DESC) AS n_prod,
    COUNT(*) OVER () AS total_prod
  FROM por_prod
)
SELECT
  MIN(CASE WHEN pct_acum >= 80 THEN n_prod END) AS productos_para_80pct_ventas,
  MAX(total_prod) AS total_productos,
  ROUND(MIN(CASE WHEN pct_acum >= 80 THEN n_prod END) * 100.0 / MAX(total_prod), 2) AS pct_productos
FROM ord;

-- b) Productos que concentran el 80% de ganancias (solo profit > 0 para no mezclar perdidas)
WITH por_prod AS (
  SELECT
    product_id,
    MAX(product_name) AS product_name,
    ROUND(SUM(profit), 2) AS ganancia
  FROM superstore_DEscalera
  GROUP BY product_id
  HAVING SUM(profit) > 0
),
ord AS (
  SELECT
    product_id,
    product_name,
    ganancia,
    ROUND(ganancia * 100.0 / SUM(ganancia) OVER (), 4) AS pct_individual,
    ROUND(SUM(ganancia) OVER (ORDER BY ganancia DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
      * 100.0 / SUM(ganancia) OVER (), 4) AS pct_acum,
    ROW_NUMBER() OVER (ORDER BY ganancia DESC) AS n_prod
  FROM por_prod
)
SELECT
  product_id,
  product_name,
  ganancia,
  pct_individual,
  pct_acum,
  n_prod
FROM ord
WHERE pct_acum <= 80 OR n_prod = (
  SELECT MIN(n_prod) FROM ord WHERE pct_acum > 80
)
ORDER BY n_prod;

-- Resumen ganancias
WITH por_prod AS (
  SELECT product_id, SUM(profit) AS ganancia
  FROM superstore_DEscalera
  GROUP BY product_id
  HAVING SUM(profit) > 0
),
ord AS (
  SELECT
    product_id,
    ganancia,
    SUM(ganancia) OVER (ORDER BY ganancia DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
      * 100.0 / SUM(ganancia) OVER () AS pct_acum,
    ROW_NUMBER() OVER (ORDER BY ganancia DESC) AS n_prod,
    COUNT(*) OVER () AS total_prod
  FROM por_prod
)
SELECT
  MIN(CASE WHEN pct_acum >= 80 THEN n_prod END) AS productos_para_80pct_ganancia,
  MAX(total_prod) AS total_productos_positivos,
  ROUND(MIN(CASE WHEN pct_acum >= 80 THEN n_prod END) * 100.0 / MAX(total_prod), 2) AS pct_productos
FROM ord;
