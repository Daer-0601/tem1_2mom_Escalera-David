# Pregunta 1. Diseño e implementación del modelo de datos

**Enunciado.** Construir el modelo en Hive: campos, diccionario, tabla analítica con tipos apropiados y procedimiento de carga.

## Estrategia

No dejé el CSV directo en una sola tabla tipada. Armé dos capas:

1. **Landing** `stg_superstore`: todo `STRING`, separador `|` (los nombres de producto traen comas).
2. **Analítica** `superstore_DEscalera`: ORC + Snappy, con `DATE`, `DOUBLE`, `INT` y `postal_code` en `STRING` para no perder el cero de los ZIP de Nueva Inglaterra.

La carga es `LOAD DATA` al landing y después `INSERT OVERWRITE ... SELECT` con `unix_timestamp(..., 'M/d/yyyy')` y `LPAD(postal_code, 5, '0')`.

## Consulta HiveQL

Ver `sql/01_ddl_carga.sql`.

## Evidencia

`evidencia/ex-01-carga.png` y `evidencia/shots/p01_carga.txt`.

## Resultado

- 9994 registros en la analítica.
- Fechas ya en `yyyy-MM-dd`.
- En el landing se ven 438 ZIP de 4 dígitos; en la analítica quedan a 5 con `LPAD`.

## Interpretación

La capa cruda sirve para auditar (P2). La ORC es la que uso en el resto: tipos listos y archivo más chico.

## Conclusión

El Superstore quedó usable en Hive sin pelear con comas ni fechas en cada consulta.
