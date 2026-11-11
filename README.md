# tem1_2mom_Escalera-David

Examen práctico 2do momento — Tecnologías Emergentes I  
Universidad del Valle — David Andres Escalera Rocha

Análisis del dataset **Sample Superstore** con Apache Hive (HiveQL): modelado, calidad de datos, consultas analíticas (ventanas, RFM, Pareto) y documentación de resultados.

## Objetivo

Procesar el CSV de Superstore en Hive, armar un modelo usable y responder las 8 preguntas del examen con evidencia de ejecución.

## Requisitos

- Docker Desktop
- El stack Hadoop/Hive **ya viene en este repo**: `docker-hadoop-hive-parquet/`
  - Hadoop 3.4.1 + Hive 4.0.1 (Beeline)
  - NameNode: http://127.0.0.1:9870
  - HiveServer2: puerto 10000

## Dataset

- Origen: https://www.kaggle.com/datasets/vivek468/superstore-dataset-final
- Archivo cargado a Hive: `datos/superstore_DEscalera.csv` (separador `|`, UTF-8)

Para regenerar el CSV limpio:

```powershell
python scripts\preparar_csv.py
```

## Cómo ejecutar

1. Levantar el stack (incluido en el repo):

```powershell
cd docker-hadoop-hive-parquet
docker compose up -d
```

Esperar a que `hive-server` quede healthy:

```powershell
docker compose ps
```

2. Cargar y correr las consultas del examen (desde la raíz del repo):

```powershell
cd ..
.\scripts\cargar_y_ejecutar.ps1
```

3. Entrar a Beeline a mano (defensa):

```powershell
docker exec -it docker-hadoop-hive-parquet-hive-server-1 /opt/hive/bin/beeline -u jdbc:hive2://localhost:10000 -n hive
```

```sql
USE dbex_DEscalera;
SHOW TABLES;
SELECT COUNT(*) FROM superstore_DEscalera;
```

## Estructura del repo

```
docker-hadoop-hive-parquet/   stack Docker (Hadoop + Hive 4)
datos/                        CSV listo para Hive
sql/                          DDL/DML + consultas P1..P8
scripts/                      preparación y ejecución
evidencia/                    salidas Beeline + capturas
documentacion/                resultados, optimización, conclusiones, informe Word
diccionario_datos.md
README.md
```

## Base y tabla

- Base: `dbex_DEscalera`
- Tabla: `superstore_DEscalera`
- Registros cargados: **9994**

## Preguntas

| # | Tema | Script |
|---|---|---|
| 1 | Modelo + carga | `sql/01_ddl_carga.sql` |
| 2 | Calidad / integridad | `sql/02_calidad.sql` |
| 3 | Evolución por región | `sql/03_region.sql` |
| 4 | RFM clientes | `sql/04_rfm.sql` |
| 5 | Ranking productos | `sql/05_productos.sql` |
| 6 | Impacto descuentos | `sql/06_descuentos.sql` |
| 7 | Tendencias mensuales | `sql/07_tendencias.sql` |
| 8 | Pareto 80/20 | `sql/08_pareto.sql` |

## Resultados rápidos

- Mejor región por ganancia: **West** (~108k). Peor: **Central** (~39.7k).
- Descuento alto (>50%): **100%** de líneas con pérdida.
- Pareto ventas: ~**414 / 1862** productos (~22%) concentran el 80% de ventas.
- Pareto ganancia (profit > 0): ~**340 / 1558** (~22%).

Detalle e interpretación: `documentacion/resultados.md` y el informe Word `documentacion/Examen_Practico_Superstore_Escalera.docx`.
