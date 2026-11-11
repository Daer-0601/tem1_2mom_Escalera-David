# Stack Hadoop + Hive (incluido en el examen)

## Servicios

| Servicio | Puerto |
|---|---|
| NameNode (web) | 9870 |
| HDFS | 8020 |
| DataNode | 9864 |
| Hive Metastore | 9083 |
| HiveServer2 | 10000 |
| Hive UI | 10002 |

Solo hace falta Docker Desktop. No depende de otra carpeta externa.

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
