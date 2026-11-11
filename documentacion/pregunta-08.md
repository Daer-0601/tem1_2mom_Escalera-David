# Pregunta 8. Análisis Pareto de ventas y rentabilidad

**Enunciado.** Cuántos productos concentran el 80% de ventas y el 80% de ganancias; comparar.

## Estrategia

Ordeno por aporte, `%` acumulado con `SUM OVER`, corto al llegar al 80%. En ganancia solo productos con `profit > 0` para no mezclar pérdidas.

## Consulta HiveQL

Ver `sql/08_pareto.sql`.

## Evidencia

`evidencia/ex-08-pareto.png` y `evidencia/shots/p08_pareto.txt`.

## Resultado

- Ventas: ~414 de 1862 productos (~22%) → 80% ventas.
- Ganancia positiva: ~340 de 1558 (~22%) → 80% ganancia.

## Interpretación

No es exactamente 20/80, pero se acerca. Un producto puede vender mucho y aportar poco (o perder), por eso las dos curvas no son iguales.

## Conclusión

Cuidar el núcleo Pareto y revisar el resto con descuento agresivo.
