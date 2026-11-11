-- Pregunta 6 - Impacto de descuentos

USE dbex_DEscalera;

WITH clasif AS (
  SELECT
    *,
    CASE
      WHEN discount = 0 THEN 'Sin descuento'
      WHEN discount > 0 AND discount <= 0.20 THEN 'Descuento bajo'
      WHEN discount > 0.20 AND discount <= 0.50 THEN 'Descuento medio'
      WHEN discount > 0.50 THEN 'Descuento alto'
      ELSE 'Otro'
    END AS rango_dto
  FROM superstore_DEscalera
)
SELECT
  rango_dto,
  COUNT(*) AS registros,
  ROUND(SUM(sales), 2) AS ventas,
  ROUND(SUM(profit), 2) AS ganancia,
  ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS margen_pct,
  SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END) AS con_perdida,
  ROUND(SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_no_rentable,
  ROUND(AVG(discount) * 100, 2) AS descuento_promedio_pct
FROM clasif
GROUP BY rango_dto
ORDER BY
  CASE rango_dto
    WHEN 'Sin descuento' THEN 1
    WHEN 'Descuento bajo' THEN 2
    WHEN 'Descuento medio' THEN 3
    WHEN 'Descuento alto' THEN 4
    ELSE 5
  END;

-- Categorias / subcategorias mas afectadas (solo descuento alto)
WITH clasif AS (
  SELECT
    category,
    sub_category,
    discount,
    sales,
    profit,
    CASE
      WHEN discount > 0.50 THEN 'Descuento alto'
      ELSE 'Otro'
    END AS rango_dto
  FROM superstore_DEscalera
)
SELECT
  category,
  sub_category,
  COUNT(*) AS registros,
  ROUND(SUM(sales), 2) AS ventas,
  ROUND(SUM(profit), 2) AS ganancia,
  SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END) AS con_perdida,
  ROUND(SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_no_rentable
FROM clasif
WHERE rango_dto = 'Descuento alto'
GROUP BY category, sub_category
ORDER BY pct_no_rentable DESC, con_perdida DESC
LIMIT 15;
