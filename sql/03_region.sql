-- Pregunta 3 - Evolucion comercial por region (CTE + ventanas)

USE dbex_DEscalera;

WITH anual AS (
  SELECT
    region,
    YEAR(from_unixtime(unix_timestamp(order_date, 'M/d/yyyy'))) AS anio,
    ROUND(SUM(sales), 2) AS ventas,
    ROUND(SUM(profit), 2) AS ganancia
  FROM superstore_DEscalera
  GROUP BY region, YEAR(from_unixtime(unix_timestamp(order_date, 'M/d/yyyy')))
),
calc AS (
  SELECT
    region,
    anio,
    ventas,
    ganancia,
    ROUND(ganancia / NULLIF(ventas, 0) * 100, 2) AS margen_pct,
    LAG(ventas) OVER (PARTITION BY region ORDER BY anio) AS ventas_ant,
    ROUND(
      (ventas - LAG(ventas) OVER (PARTITION BY region ORDER BY anio))
      / NULLIF(LAG(ventas) OVER (PARTITION BY region ORDER BY anio), 0) * 100, 2
    ) AS var_ventas_pct,
    ROUND(
      (ganancia - LAG(ganancia) OVER (PARTITION BY region ORDER BY anio))
      / NULLIF(LAG(ganancia) OVER (PARTITION BY region ORDER BY anio), 0) * 100, 2
    ) AS var_ganancia_pct
  FROM anual
)
SELECT * FROM calc
ORDER BY region, anio;

-- Mejor y peor region por ganancia acumulada
WITH tot AS (
  SELECT
    region,
    ROUND(SUM(sales), 2) AS ventas_tot,
    ROUND(SUM(profit), 2) AS ganancia_tot,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS margen_pct
  FROM superstore_DEscalera
  GROUP BY region
)
SELECT
  region,
  ventas_tot,
  ganancia_tot,
  margen_pct,
  RANK() OVER (ORDER BY ganancia_tot DESC) AS rank_mejor_ganancia,
  RANK() OVER (ORDER BY ganancia_tot ASC) AS rank_peor_ganancia
FROM tot
ORDER BY ganancia_tot DESC;
