# Notas de optimización

1. **Landing + ORC**  
   El CSV se lee una vez en `stg_superstore`. De P3 en adelante trabajo sobre `superstore_DEscalera` en ORC/Snappy, ya tipada.

2. **`postal_code` como STRING + LPAD**  
   Si lo dejo INT se come el cero de Massachusetts/NJ/etc. En el landing se ven 438 ZIP de 4 dígitos.

3. **Fechas a DATE en la carga**  
   Convierto `M/d/yyyy` una sola vez. Después uso `YEAR`/`MONTH`/`DATEDIFF` sin `unix_timestamp` en cada query.

4. **CTE + ventanas sobre agregados**  
   En P3/P7/P8 primero reduzco y después aplico `LAG`/`SUM OVER`.

5. **Estadísticas**  
   `ANALYZE TABLE superstore_DEscalera COMPUTE STATISTICS` para que el `DESCRIBE` no quede en `numRows=0`.

6. **Partición por año**  
   Armé `superstore_part` particionada por `anio`. Un `WHERE anio = 2017` no tiene por qué leer 2014-2016. Script: `sql/09_optimizacion.sql`.

7. **Entorno**  
   Stack en el repo: `docker-hadoop-hive-parquet/` (Hive 4 + Beeline).
