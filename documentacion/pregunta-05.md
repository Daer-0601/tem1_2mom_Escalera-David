# Pregunta 5. Ranking de productos según rentabilidad

**Enunciado.** Top 5 por ganancia dentro de cada categoría, top 5 por ventas, peores márgenes, margen individual y posición. Usar `RANK`, `DENSE_RANK` y acumulados.

## Estrategia

Agrego por `product_id`. `RANK` por ganancia dentro de categoría, `DENSE_RANK` por ventas globales, y un top de peor margen. `SUM OVER` para ganancia acumulada por categoría.

## Consulta HiveQL

Ver `sql/05_productos.sql`.

## Evidencia

`evidencia/ex-05-productos.png` y `evidencia/shots/p05_productos.txt`.

## Resultado

El Canon imageCLASS 2200 manda en ventas y ganancia. Hay casos como el Cisco TelePresence que venden mucho y pierden. En Furniture ganan sobre todo sillas.

## Interpretación

Volumen ≠ rentabilidad. Por eso el ranking de ventas y el de ganancia no coinciden.

## Conclusión

Conviene mirar margen además del top de ventas.
