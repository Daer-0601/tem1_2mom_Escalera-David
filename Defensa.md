# Defensa — comandos rápidos

## Antes

1. Docker Desktop prendido.
2. Stack (está dentro del repo):

```powershell
cd docker-hadoop-hive-parquet
docker compose ps
```

Si no está arriba:

```powershell
docker compose up -d
```

3. Beeline:

```powershell
docker exec -it docker-hadoop-hive-parquet-hive-server-1 /opt/hive/bin/beeline -u jdbc:hive2://localhost:10000 -n hive
```

## Preguntas vivas

```sql
USE dbex_DEscalera;
SHOW TABLES;
DESCRIBE FORMATTED superstore_DEscalera;
SELECT COUNT(*) FROM superstore_DEscalera;
SELECT * FROM superstore_DEscalera LIMIT 5;
```

Calidad (resumen):

```sql
-- pegar bloque principal de sql/02_calidad.sql
```

Región / RFM / descuentos / Pareto: los scripts están en `sql/03` … `sql/08`.

## Qué decir

- Base `dbex_DEscalera`, tabla `superstore_DEscalera`, 9994 filas.
- Separador `|` porque `product_name` trae comas.
- Fechas en texto + `unix_timestamp(..., 'M/d/yyyy')`.
- West mejor en ganancia; Central peor margen.
- Descuento > 50% → 100% líneas con pérdida.
- Pareto ~22% de productos → 80% ventas.

## Si preguntan del entorno

El stack va en `docker-hadoop-hive-parquet/` (Hadoop 3.4.1 + Hive 4.0.1).  
Hive 4 se consulta con Beeline. NameNode web: 9870. HiveServer2: 10000.
