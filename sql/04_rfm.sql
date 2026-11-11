-- Pregunta 4 - Segmentacion RFM de clientes

USE dbex_DEscalera;

WITH params AS (
  SELECT MAX(from_unixtime(unix_timestamp(order_date, 'M/d/yyyy'), 'yyyy-MM-dd')) AS fecha_ref
  FROM superstore_DEscalera
),
rfm_raw AS (
  SELECT
    s.customer_id,
    MAX(s.customer_name) AS customer_name,
    MAX(s.segment) AS segment,
    DATEDIFF(
      (SELECT fecha_ref FROM params),
      MAX(from_unixtime(unix_timestamp(s.order_date, 'M/d/yyyy'), 'yyyy-MM-dd'))
    ) AS recency,
    COUNT(DISTINCT s.order_id) AS frequency,
    ROUND(SUM(s.sales), 2) AS monetary
  FROM superstore_DEscalera s
  GROUP BY s.customer_id
),
scored AS (
  SELECT
    customer_id,
    customer_name,
    segment,
    recency,
    frequency,
    monetary,
    -- NTILE deja 1 en el primer bloque del ORDER BY.
    -- Para que 5 sea lo mejor: recency alto primero (malo=1), freq/monto bajos primero (malo=1).
    NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
    NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
    NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
  FROM rfm_raw
),
labeled AS (
  SELECT
    *,
    CONCAT(CAST(r_score AS STRING), CAST(f_score AS STRING), CAST(m_score AS STRING)) AS rfm_code,
    CASE
      WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Alto valor'
      WHEN r_score >= 3 AND f_score >= 3 THEN 'Recurrente'
      WHEN r_score <= 2 AND f_score <= 2 THEN 'En riesgo'
      WHEN r_score <= 2 AND m_score >= 4 THEN 'Dormido valioso'
      ELSE 'Regular'
    END AS segmento_rfm
  FROM scored
)
SELECT
  customer_id,
  customer_name,
  segment,
  recency,
  frequency,
  monetary,
  r_score,
  f_score,
  m_score,
  rfm_code,
  segmento_rfm
FROM labeled
ORDER BY monetary DESC
LIMIT 30;

-- Conteo por segmento
WITH params AS (
  SELECT MAX(from_unixtime(unix_timestamp(order_date, 'M/d/yyyy'), 'yyyy-MM-dd')) AS fecha_ref
  FROM superstore_DEscalera
),
rfm_raw AS (
  SELECT
    s.customer_id,
    DATEDIFF(
      (SELECT fecha_ref FROM params),
      MAX(from_unixtime(unix_timestamp(s.order_date, 'M/d/yyyy'), 'yyyy-MM-dd'))
    ) AS recency,
    COUNT(DISTINCT s.order_id) AS frequency,
    ROUND(SUM(s.sales), 2) AS monetary
  FROM superstore_DEscalera s
  GROUP BY s.customer_id
),
scored AS (
  SELECT
    *,
    NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
    NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
    NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
  FROM rfm_raw
),
labeled AS (
  SELECT
    CASE
      WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Alto valor'
      WHEN r_score >= 3 AND f_score >= 3 THEN 'Recurrente'
      WHEN r_score <= 2 AND f_score <= 2 THEN 'En riesgo'
      WHEN r_score <= 2 AND m_score >= 4 THEN 'Dormido valioso'
      ELSE 'Regular'
    END AS segmento_rfm,
    monetary
  FROM scored
)
SELECT
  segmento_rfm,
  COUNT(*) AS clientes,
  ROUND(AVG(monetary), 2) AS ticket_medio,
  ROUND(SUM(monetary), 2) AS ventas_segmento
FROM labeled
GROUP BY segmento_rfm
ORDER BY ventas_segmento DESC;
