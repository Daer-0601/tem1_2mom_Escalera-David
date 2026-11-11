# Conclusiones

1. El dataset Superstore entra bien a Hive si se limpia el separador y el encoding. Con 9994 filas el cuello de botella no es tamaño, es armar bien tipos y fechas.

2. La calidad del sample es alta (casi sin nulos ni duplicados). El tema real son las líneas en pérdida, sobre todo cuando el descuento pasa del 50%.

3. West es la región más sólida. Central arrastra el margen más bajo; si hubiera que recortar descuentos agresivos, empezaría por ahí.

4. RFM ayuda a no mirar solo “quién compró más plata”. Hay clientes con buen monetary pero recency alta (medio dormidos) y otros frecuentes que conviene cuidar.

5. Pareto confirma concentración: ~22% de productos explican ~80% de ventas/ganancias. Conviene cuidar ese núcleo y revisar el resto que vende con descuento suicida.

6. En Hive 4 trabajé con Beeline (no con el CLI viejo `hive`). Las ventanas (`LAG`, `RANK`, `SUM OVER`, `NTILE`) resolvieron P3–P8 sin tablas intermedias de más.

7. Si el volumen creciera, el siguiente paso sería Parquet + partición por región/año. Para este examen no hizo falta.
