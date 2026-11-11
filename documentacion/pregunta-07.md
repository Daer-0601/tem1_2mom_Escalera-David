# Pregunta 7. Análisis de tendencias temporales

**Enunciado.** Ventas/ganancias mensuales, variación vs mes anterior, YoY, media móvil 3 meses, 3 mejores y 3 peores meses.

## Estrategia

Agrego por año-mes. `LAG` (1) para mes anterior, `LAG` (12) para YoY, `AVG` con frame de 3 meses, y `RANK` para extremos.

## Consulta HiveQL

Ver `sql/07_tendencias.sql`.

## Evidencia

`evidencia/ex-07-tendencias.png` y `evidencia/shots/p07_tendencias.txt`.

## Resultado

Picos: nov-2017, dic-2016, sep-2017. Más flojos: feb-2014, feb-2015, ene-2014. Se nota temporada fuerte a fin de año.

## Interpretación

La media móvil suaviza el ruido. El negocio es estacional.

## Conclusión

Planificar stock/promos con el cierre de año en mente.
