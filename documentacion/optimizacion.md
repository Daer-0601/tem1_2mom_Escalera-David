# Notas de optimización

Cosas que fui probando / dejando anotadas mientras armaba las consultas:

1. **Separador `|`**  
   Con coma, Hive partía mal los nombres de producto. Cambiar el delimitador evitó filas rotas y no tuve que pelear con `OpenCSVSerde`.

2. **Fechas como STRING**  
   Cargarlas ya como DATE fallaba con `11/8/2016` (mes/día de un dígito). Dejé string y usé `unix_timestamp(..., 'M/d/yyyy')` solo donde hacía falta.

3. **CTE + ventanas**  
   En P3/P7/P8 armé primero un agregado chico y después apliqué `LAG`/`SUM OVER`. Así Tez no arrastra las 9994 filas en cada ventana.

4. **RFM con NTILE(5)**  
   Evité umbrales fijos raros. Los quintiles se adaptan al dataset y se entienden fácil en la defensa.

5. **Pareto solo con profit > 0**  
   Si meto productos con pérdida en el acumulado de ganancias, el 80% se distorsiona. Para ventas sí uso todos.

6. **Entorno**  
   El stack vive en el repo (`docker-hadoop-hive-parquet/`): Hive 4 + Beeline. NameNode en 9870, HiveServer2 en 10000.

7. **Si se agranda el dataset**  
   Particionar por `region` o por año (`anio` derivado) y guardar en Parquet ayudaría. Con 10k filas no hace falta.
