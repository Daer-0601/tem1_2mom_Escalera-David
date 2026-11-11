# Diccionario de datos — Sample Superstore

Fuente: Kaggle (`vivek468/superstore-dataset-final`). Archivo de trabajo: `datos/superstore_DEscalera.csv` (separador `|`).

Base Hive: `dbex_DEscalera`  
Tabla: `superstore_DEscalera`

| Campo Hive | Tipo | Origen CSV | Descripción | Restricciones / notas |
|---|---|---|---|---|
| row_id | INT | Row ID | Id de fila del archivo | En el sample no hay duplicados |
| order_id | STRING | Order ID | Código de la orden | Formato CA/US-AAAA-###### |
| order_date | STRING | Order Date | Fecha del pedido | Texto `M/d/yyyy`; se parsea en SQL |
| ship_date | STRING | Ship Date | Fecha de envío | Texto `M/d/yyyy` |
| ship_mode | STRING | Ship Mode | Modo de envío | First/Second/Standard Class, Same Day |
| customer_id | STRING | Customer ID | Cliente | Clave lógica del cliente |
| customer_name | STRING | Customer Name | Nombre | Texto libre |
| segment | STRING | Segment | Segmento comercial | Consumer, Corporate, Home Office |
| country | STRING | Country | País | En este sample: United States |
| city | STRING | City | Ciudad | |
| state | STRING | State | Estado | |
| postal_code | INT | Postal Code | Código postal | |
| region | STRING | Region | Región | Central, East, South, West |
| product_id | STRING | Product ID | Producto | |
| category | STRING | Category | Categoría | Furniture, Office Supplies, Technology |
| sub_category | STRING | Sub-Category | Subcategoría | |
| product_name | STRING | Product Name | Nombre del producto | Trae comas → por eso `|` |
| sales | DOUBLE | Sales | Venta de la línea | Esperado > 0 |
| quantity | INT | Quantity | Unidades | Entero positivo |
| discount | DOUBLE | Discount | Descuento | Rango esperado 0–1 |
| profit | DOUBLE | Profit | Ganancia | Puede ser negativa |

Observaciones de la revisión previa a la carga:
- 9994 filas, 21 columnas.
- Encoding original raro (cp1252); lo pasé a UTF-8.
- `product_name` tiene comas, así que no dejé el CSV con coma como separador.
- Fechas vienen como texto; no las convertí en la carga para no pelear con el parseo.
