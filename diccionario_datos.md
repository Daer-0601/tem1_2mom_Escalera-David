# Diccionario de datos — Sample Superstore

Fuente: Kaggle (`vivek468/superstore-dataset-final`).  
Archivo: `datos/superstore_DEscalera.csv` (separador `|`).

Base: `dbex_DEscalera`  
Landing: `stg_superstore` (todo STRING)  
Analítica: `superstore_DEscalera` (ORC)

| Campo | Tipo analítica | Origen | Descripción | Notas |
|---|---|---|---|---|
| row_id | INT | Row ID | Id de fila | Sin duplicados en el sample |
| order_id | STRING | Order ID | Código de orden | CA/US-AAAA-###### |
| order_date | DATE | Order Date | Fecha pedido | Parseada desde `M/d/yyyy` |
| ship_date | DATE | Ship Date | Fecha envío | Parseada desde `M/d/yyyy` |
| ship_mode | STRING | Ship Mode | Modo de envío | First/Second/Standard/Same Day |
| customer_id | STRING | Customer ID | Cliente | |
| customer_name | STRING | Customer Name | Nombre | |
| segment | STRING | Segment | Segmento | Consumer, Corporate, Home Office |
| country | STRING | Country | País | United States en este sample |
| city | STRING | City | Ciudad | |
| state | STRING | State | Estado | |
| postal_code | STRING | Postal Code | ZIP | STRING + LPAD(5) para no perder el 0 |
| region | STRING | Region | Región | Central, East, South, West |
| product_id | STRING | Product ID | Producto | |
| category | STRING | Category | Categoría | Furniture, Office Supplies, Technology |
| sub_category | STRING | Sub-Category | Subcategoría | |
| product_name | STRING | Product Name | Nombre | Trae comas → separador `\|` |
| sales | DOUBLE | Sales | Venta de línea | Esperado > 0 |
| quantity | INT | Quantity | Unidades | |
| discount | DOUBLE | Discount | Descuento | Rango 0–1 |
| profit | DOUBLE | Profit | Ganancia | Puede ser negativa |

Observaciones previas a la carga:
- 9994 filas, 21 columnas.
- Encoding original problemático; el archivo de trabajo va en UTF-8.
- 438 ZIP venían con 4 dígitos en el CSV (Nueva Inglaterra).
