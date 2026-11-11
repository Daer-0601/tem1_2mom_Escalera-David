# Resultados e interpretación

Escribí esto después de correr las consultas en Beeline. Los números salieron de Hive; los crucé también con un script local (`scripts/calcular_resultados.py`) para no confiar a ciegas.

## P1 — Modelo y carga

Cargué 9994 filas en `dbex_DEscalera.superstore_DEscalera`.  
El CSV original venía con encoding raro y `Product Name` con comas, así que lo pasé a `|` y UTF-8. Las fechas las dejé en texto (`M/d/yyyy`) porque en la carga directa a DATE se me rompían los días/meses de un dígito.

## P2 — Calidad

| Chequeo | Resultado |
|---|---|
| Total registros | 9994 |
| row_id duplicados | 0 |
| Órdenes únicas | 5009 |
| Clientes únicos | 793 |
| Nulos en campos clave | 0 |
| Fechas inválidas | 0 |
| Envío antes del pedido | 0 |
| Sales <= 0 | 0 |
| Discount fuera de 0–1 | 0 |
| Líneas con profit < 0 | 1871 |

El sample está bastante limpio. Lo único “feo” de verdad son las **1871 líneas con pérdida**, pero eso no es basura: sirve para el análisis de descuentos.  
Criterio: no borro pérdidas; si aparecieran fechas imposibles o dto fuera de rango, las sacaría del análisis temporal / las marcaría.

## P3 — Regiones

West gana claro en ganancia acumulada (~108418, margen ~14.9%).  
Central es la más débil (~39706, margen ~7.9%), aunque en 2016 mejoró y en 2017 se cayó otra vez.  
East crece sostenido en ventas año a año. South es más chica y con saltos (2015 bajó fuerte).

## P4 — RFM

Fecha de referencia: 2017-12-30.  
Scores con NTILE(5): 5 = mejor (recency baja, más órdenes, más plata).

Segmentos que usé:
- **Alto valor**: R,F,M >= 4
- **Recurrente**: R,F >= 3
- **En riesgo**: R,F <= 2
- **Dormido valioso**: R <= 2 pero M >= 4
- resto: Regular

Sirve para priorizar retención (alto valor / recurrente) y campañas de reactivación (riesgo / dormido valioso).

## P5 — Productos

El Canon imageCLASS 2200 manda en ventas y también en ganancia.  
Hay productos con mucha venta pero margen malo (ej. el Cisco TelePresence queda con pérdida).  
Por categoría saqué top 5 de ganancia con `RANK()`; el volumen global con `DENSE_RANK()`.

## P6 — Descuentos

Acá se ve el golpe:

| Rango | Registros | Margen | % no rentable |
|---|---|---|---|
| Sin dto | 4798 | 29.51% | 0% |
| Bajo (≤20%) | 3803 | 11.91% | 13.75% |
| Medio (≤50%) | 537 | -19.7% | 91.62% |
| Alto (>50%) | 856 | -119.2% | **100%** |

Sí: descuento alto está asociado a operaciones no rentables. Binders, Furnishings, Appliances y Machines concentran el daño.

## P7 — Mensual

Picos: nov-2017 (~118k), dic-2016 (~97k), sep-2017 (~88k).  
Más flojos: feb-2014, feb-2015, ene-2014.  
Se nota temporada fuerte al final de año. La media móvil de 3 meses suaviza el ruido mes a mes.

## P8 — Pareto

- Ventas: **414 de 1862** productos (~22.2%) hacen el 80% de ventas.
- Ganancia (solo profit > 0): **340 de 1558** (~21.8%).

No es un 20% exacto, pero se acerca. La diferencia importa: un producto puede vender mucho y aportar poco (o perder). Por eso el ranking de ventas y el de ganancia no coinciden del todo.
