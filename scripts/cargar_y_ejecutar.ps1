# Carga el CSV a HDFS y corre los SQL del examen contra Hive 4 (Beeline)
$ErrorActionPreference = "Stop"
$Root = Split-Path $PSScriptRoot -Parent
$Csv = Join-Path $Root "datos\superstore_DEscalera.csv"
$OutDir = Join-Path $Root "evidencia\shots"
$Hive = "docker-hadoop-hive-parquet-hive-server-1"
$Name = "docker-hadoop-hive-parquet-namenode-1"

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

Write-Host "== Subiendo CSV al namenode =="
docker cp $Csv "${Name}:/tmp/superstore_DEscalera.csv"
docker exec $Name bash -lc "hdfs dfs -put -f /tmp/superstore_DEscalera.csv /tmp/superstore_DEscalera.csv"
docker exec $Name bash -lc "hdfs dfs -ls /tmp/superstore_DEscalera.csv"

function Run-SqlFile([string]$RelPath, [string]$ShotName) {
  $sqlPath = Join-Path $Root $RelPath
  $dest = "/tmp/$ShotName.sql"
  Write-Host "== Ejecutando $RelPath =="
  docker cp $sqlPath "${Hive}:$dest"
  $raw = docker exec $Hive bash -lc "/opt/hive/bin/beeline -u 'jdbc:hive2://localhost:10000' -n hive --silent=true --showHeader=true --outputformat=tsv2 -f $dest 2>&1"
  $outFile = Join-Path $OutDir "$ShotName.txt"
  $raw | Out-File -FilePath $outFile -Encoding utf8
  Write-Host "  -> $outFile"
  return $raw
}

Run-SqlFile "sql\01_ddl_carga.sql" "p01_carga" | Out-Null
Run-SqlFile "sql\02_calidad.sql" "p02_calidad" | Out-Null
Run-SqlFile "sql\03_region.sql" "p03_region" | Out-Null
Run-SqlFile "sql\04_rfm.sql" "p04_rfm" | Out-Null
Run-SqlFile "sql\05_productos.sql" "p05_productos" | Out-Null
Run-SqlFile "sql\06_descuentos.sql" "p06_descuentos" | Out-Null
Run-SqlFile "sql\07_tendencias.sql" "p07_tendencias" | Out-Null
Run-SqlFile "sql\08_pareto.sql" "p08_pareto" | Out-Null
Run-SqlFile "sql\09_optimizacion.sql" "p09_optimizacion" | Out-Null

Write-Host "LISTO"
