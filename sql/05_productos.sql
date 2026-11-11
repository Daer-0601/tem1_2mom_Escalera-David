-- Pregunta 5 - Ranking de productos
USE dbex_DEscalera;

WITH prod AS (
  SELECT
    category,
    product_id,
    MAX(product_name) AS product_name,
    ROUND(SUM(sales), 2) AS ventas,
    ROUND(SUM(profit), 2) AS ganancia,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS margen_pct
  FROM superstore_DEscalera
  GROUP BY category, product_id
),
ranked AS (
  SELECT
    category,
    product_id,
    product_name,
    ventas,
    ganancia,
    margen_pct,
    RANK() OVER (PARTITION BY category ORDER BY ganancia DESC) AS rank_ganancia_cat,
    DENSE_RANK() OVER (ORDER BY ventas DESC) AS dense_rank_ventas_global,
    SUM(ganancia) OVER (
      PARTITION BY category ORDER BY ganancia DESC
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS ganancia_acum_cat
  FROM prod
)
SELECT *
FROM ranked
WHERE rank_ganancia_cat <= 5
ORDER BY category, rank_ganancia_cat;

SELECT
  category,
  product_id,
  product_name,
  ventas,
  ganancia,
  margen_pct,
  dense_rank_ventas_global
FROM (
  SELECT
    category,
    product_id,
    MAX(product_name) AS product_name,
    ROUND(SUM(sales), 2) AS ventas,
    ROUND(SUM(profit), 2) AS ganancia,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS margen_pct,
    DENSE_RANK() OVER (ORDER BY SUM(sales) DESC) AS dense_rank_ventas_global
  FROM superstore_DEscalera
  GROUP BY category, product_id
) t
WHERE dense_rank_ventas_global <= 5
ORDER BY dense_rank_ventas_global;

SELECT
  category,
  product_id,
  product_name,
  ventas,
  ganancia,
  margen_pct
FROM (
  SELECT
    category,
    product_id,
    MAX(product_name) AS product_name,
    ROUND(SUM(sales), 2) AS ventas,
    ROUND(SUM(profit), 2) AS ganancia,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS margen_pct
  FROM superstore_DEscalera
  GROUP BY category, product_id
  HAVING SUM(sales) > 0
) t
ORDER BY margen_pct ASC
LIMIT 5;
