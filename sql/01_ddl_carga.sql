-- Pregunta 1 - Modelo y carga
-- Landing STRING + tabla analitica ORC tipada
-- Base: dbex_DEscalera

CREATE DATABASE IF NOT EXISTS dbex_DEscalera;
USE dbex_DEscalera;

-- 1) Aterrizaje: todo texto, separador | (product_name trae comas)
DROP TABLE IF EXISTS stg_superstore;
CREATE TABLE stg_superstore (
  row_id STRING,
  order_id STRING,
  order_date STRING,
  ship_date STRING,
  ship_mode STRING,
  customer_id STRING,
  customer_name STRING,
  segment STRING,
  country STRING,
  city STRING,
  state STRING,
  postal_code STRING,
  region STRING,
  product_id STRING,
  category STRING,
  sub_category STRING,
  product_name STRING,
  sales STRING,
  quantity STRING,
  discount STRING,
  profit STRING
)
COMMENT 'Landing Superstore. STRING para revisar el CSV crudo'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
TBLPROPERTIES ('skip.header.line.count'='1');

-- 2) Analitica: tipos nativos + ORC
DROP TABLE IF EXISTS superstore_DEscalera;
CREATE TABLE superstore_DEscalera (
  row_id INT COMMENT 'Id de fila del CSV',
  order_id STRING,
  order_date DATE COMMENT 'Pedido ya parseado',
  ship_date DATE COMMENT 'Envio ya parseado',
  ship_mode STRING,
  customer_id STRING,
  customer_name STRING,
  segment STRING,
  country STRING,
  city STRING,
  state STRING,
  postal_code STRING COMMENT 'STRING para no perder el 0 de ZIP NE',
  region STRING,
  product_id STRING,
  category STRING,
  sub_category STRING,
  product_name STRING,
  sales DOUBLE,
  quantity INT,
  discount DOUBLE COMMENT 'Fraccion 0-1',
  profit DOUBLE
)
COMMENT 'Tabla analitica Superstore ORC'
STORED AS ORC
TBLPROPERTIES ('orc.compress'='SNAPPY');

-- Subir antes el CSV a HDFS /tmp/superstore_DEscalera.csv
LOAD DATA INPATH '/tmp/superstore_DEscalera.csv' OVERWRITE INTO TABLE stg_superstore;

INSERT OVERWRITE TABLE superstore_DEscalera
SELECT
  CAST(row_id AS INT),
  order_id,
  TO_DATE(FROM_UNIXTIME(UNIX_TIMESTAMP(order_date, 'M/d/yyyy'))),
  TO_DATE(FROM_UNIXTIME(UNIX_TIMESTAMP(ship_date, 'M/d/yyyy'))),
  ship_mode,
  customer_id,
  customer_name,
  segment,
  country,
  city,
  state,
  LPAD(postal_code, 5, '0'),
  region,
  product_id,
  category,
  sub_category,
  product_name,
  CAST(sales AS DOUBLE),
  CAST(quantity AS INT),
  CAST(discount AS DOUBLE),
  CAST(profit AS DOUBLE)
FROM stg_superstore
WHERE row_id IS NOT NULL AND TRIM(row_id) <> '' AND TRIM(row_id) <> 'row_id';

ANALYZE TABLE superstore_DEscalera COMPUTE STATISTICS;

DESCRIBE FORMATTED superstore_DEscalera;

SELECT * FROM superstore_DEscalera LIMIT 10;

SELECT COUNT(*) AS total_registros FROM superstore_DEscalera;

-- ZIP que venian con 4 digitos en el landing (antes del LPAD)
SELECT state, COUNT(*) AS zip_4_digitos
FROM stg_superstore
WHERE LENGTH(TRIM(postal_code)) = 4
GROUP BY state
ORDER BY zip_4_digitos DESC;
