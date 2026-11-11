# Stack Hadoop + Hive (incluido en el examen)

Basado en el entorno de las prácticas (`tech4242/docker-hadoop-hive-parquet`).

## Servicios

| Servicio | Puerto |
|---|---|
| NameNode (web) | 9870 |
| HDFS | 8020 |
| DataNode | 9864 |
| Hive Metastore | 9083 |
| HiveServer2 | 10000 |
| Hive UI | 10002 |
| Hue (opcional) | 8888 |

## Uso

```powershell
docker compose up -d
docker compose ps
```

Beeline:

```powershell
docker exec -it docker-hadoop-hive-parquet-hive-server-1 /opt/hive/bin/beeline -u jdbc:hive2://localhost:10000 -n hive
```

Incluye el driver `jars/postgres-jdbc.jar` para el metastore.
