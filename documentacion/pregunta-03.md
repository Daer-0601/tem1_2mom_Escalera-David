# Pregunta 3. Evolución comercial por región

**Enunciado.** Ventas y ganancia por región/año, margen, variación % vs año anterior, mejor y peor región. Usar CTE y ventanas.

## Estrategia

Agrego por región y `YEAR(order_date)`, después `LAG` para la variación y `RANK` para marcar mejor/peor por ganancia acumulada.

## Consulta HiveQL

Ver `sql/03_region.sql`.

## Evidencia

`evidencia/ex-03-region.png` y `evidencia/shots/p03_region.txt`.

## Resultado

West es la más sólida en ganancia (~108k, margen ~15%). Central es la más floja (~39.7k, margen ~8%). East crece casi todo el período. South es más chica y con altibajos.

## Interpretación

El crecimiento no es parejo: West empuja la rentabilidad; Central arrastra margen bajo.

## Conclusión

Si hubiera que cuidar descuentos agresivos, empezaría por Central.
