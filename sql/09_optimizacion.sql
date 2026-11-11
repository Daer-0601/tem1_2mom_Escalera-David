-- Optimizacion: stats + particion por anio
USE dbex_DEscalera;

ANALYZE TABLE superstore_DEscalera COMPUTE STATISTICS;
DESCRIBE FORMATTED superstore_DEscalera;

DROP TABLE IF EXISTS superstore_part;
CREATE TABLE superstore_part (
  row_id INT,
  order_id STRING,
  order_date DATE,
  ship_date DATE,
  customer_id STRING,
  region STRING,
  product_id STRING,
  category STRING,
  sales DOUBLE,
  profit DOUBLE,
  discount DOUBLE
)
PARTITIONED BY (anio INT)
STORED AS ORC
TBLPROPERTIES ('orc.compress'='SNAPPY');

SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;

INSERT OVERWRITE TABLE superstore_part PARTITION (anio)
SELECT
  row_id, order_id, order_date, ship_date, customer_id, region,
  product_id, category, sales, profit, discount,
  YEAR(order_date) AS anio
FROM superstore_DEscalera;

SHOW PARTITIONS superstore_part;

SELECT anio, COUNT(*) AS filas, ROUND(SUM(sales), 2) AS ventas
FROM superstore_part
GROUP BY anio
ORDER BY anio;

SELECT COUNT(*) AS filas_2017
FROM superstore_part
WHERE anio = 2017;
