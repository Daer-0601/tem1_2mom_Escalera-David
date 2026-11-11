-- Pregunta 7 - Tendencias mensuales
USE dbex_DEscalera;

WITH mensual AS (
  SELECT
    YEAR(order_date) AS anio,
    MONTH(order_date) AS mes,
    ROUND(SUM(sales), 2) AS ventas,
    ROUND(SUM(profit), 2) AS ganancia
  FROM superstore_DEscalera
  GROUP BY YEAR(order_date), MONTH(order_date)
),
ordenado AS (
  SELECT
    anio,
    mes,
    ventas,
    ganancia,
    LAG(ventas) OVER (ORDER BY anio, mes) AS ventas_mes_ant,
    LAG(ventas, 12) OVER (ORDER BY anio, mes) AS ventas_mismo_mes_ant,
    ROUND(AVG(ventas) OVER (
      ORDER BY anio, mes
      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS media_movil_3m
  FROM mensual
)
SELECT
  anio,
  mes,
  ventas,
  ganancia,
  ventas_mes_ant,
  ROUND((ventas - ventas_mes_ant) / NULLIF(ventas_mes_ant, 0) * 100, 2) AS var_mes_pct,
  ventas_mismo_mes_ant,
  ROUND((ventas - ventas_mismo_mes_ant) / NULLIF(ventas_mismo_mes_ant, 0) * 100, 2) AS var_yoy_pct,
  media_movil_3m
FROM ordenado
ORDER BY anio, mes;

WITH mensual AS (
  SELECT
    YEAR(order_date) AS anio,
    MONTH(order_date) AS mes,
    ROUND(SUM(sales), 2) AS ventas
  FROM superstore_DEscalera
  GROUP BY YEAR(order_date), MONTH(order_date)
),
ranked AS (
  SELECT
    *,
    RANK() OVER (ORDER BY ventas DESC) AS rank_mayor,
    RANK() OVER (ORDER BY ventas ASC) AS rank_menor
  FROM mensual
)
SELECT 'mayor' AS tipo, anio, mes, ventas, rank_mayor AS ranking
FROM ranked WHERE rank_mayor <= 3
UNION ALL
SELECT 'menor' AS tipo, anio, mes, ventas, rank_menor AS ranking
FROM ranked WHERE rank_menor <= 3
ORDER BY tipo, ranking;
