-- Examen 2do momento - Pregunta 1
-- Modelo y carga Superstore
-- Base/tabla: dbex_DEscalera.superstore_DEscalera

CREATE DATABASE IF NOT EXISTS dbex_DEscalera;

DROP TABLE IF EXISTS dbex_DEscalera.superstore_DEscalera;

CREATE TABLE dbex_DEscalera.superstore_DEscalera (
  row_id         INT     COMMENT 'Identificador de fila del CSV original',
  order_id       STRING  COMMENT 'Codigo de orden, ej. CA-2016-152156',
  order_date     STRING  COMMENT 'Fecha pedido M/d/yyyy; se parsea en consultas',
  ship_date      STRING  COMMENT 'Fecha envio M/d/yyyy',
  ship_mode      STRING  COMMENT 'First Class, Second Class, Standard Class, Same Day',
  customer_id    STRING  COMMENT 'Codigo cliente, ej. CG-12520',
  customer_name  STRING  COMMENT 'Nombre completo del cliente',
  segment        STRING  COMMENT 'Consumer, Corporate, Home Office',
  country        STRING  COMMENT 'En este sample casi todo United States',
  city           STRING  COMMENT 'Ciudad de envio',
  state          STRING  COMMENT 'Estado de EE.UU.',
  postal_code    INT     COMMENT 'Codigo postal',
  region         STRING  COMMENT 'Central, East, South, West',
  product_id     STRING  COMMENT 'Codigo producto, ej. FUR-BO-10001798',
  category       STRING  COMMENT 'Furniture, Office Supplies, Technology',
  sub_category   STRING  COMMENT 'Subcategoria dentro de category',
  product_name   STRING  COMMENT 'Nombre; trae comas, por eso el archivo va con |',
  sales          DOUBLE  COMMENT 'Importe de la linea',
  quantity       INT     COMMENT 'Unidades vendidas',
  discount       DOUBLE  COMMENT 'Descuento entre 0 y 1 (0% a 100%)',
  profit         DOUBLE  COMMENT 'Ganancia de la linea; puede ser negativa'
)
COMMENT 'Sample Superstore (Kaggle). Separador | por product_name con comas'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
TBLPROPERTIES ('skip.header.line.count'='1');

-- El CSV se sube antes a HDFS:
-- docker cp datos/superstore_DEscalera.csv docker-hadoop-hive-parquet-namenode-1:/tmp/
-- docker exec docker-hadoop-hive-parquet-namenode-1 hdfs dfs -put -f /tmp/superstore_DEscalera.csv /tmp/

LOAD DATA INPATH '/tmp/superstore_DEscalera.csv' OVERWRITE INTO TABLE dbex_DEscalera.superstore_DEscalera;

DESCRIBE FORMATTED dbex_DEscalera.superstore_DEscalera;

SELECT * FROM dbex_DEscalera.superstore_DEscalera LIMIT 10;

SELECT COUNT(*) AS total_registros FROM dbex_DEscalera.superstore_DEscalera;
