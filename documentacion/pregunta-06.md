# Pregunta 6. Impacto de los descuentos

**Enunciado.** Rangos sin/bajo/medio/alto, ventas, margen, pérdidas, % no rentable, dto promedio, categorías afectadas.

## Estrategia

`CASE` sobre `discount` (fracción 0–1). “No rentable” = `profit < 0`. Segunda consulta solo con descuento alto por categoría/subcategoría.

## Consulta HiveQL

Ver `sql/06_descuentos.sql`.

## Evidencia

`evidencia/ex-06-descuentos.png` y `evidencia/shots/p06_descuentos.txt`.

## Resultado

| Rango | Registros | Margen | % no rentable |
|---|---|---|---|
| Sin dto | 4798 | ~29.5% | 0% |
| Bajo ≤20% | 3803 | ~11.9% | ~13.8% |
| Medio ≤50% | 537 | ~-19.7% | ~91.6% |
| Alto >50% | 856 | ~-119% | **100%** |

## Interpretación

A más descuento agresivo, más líneas en pérdida. Binders, Furnishings, Appliances y Machines concentran daño.

## Conclusión

Sí hay asociación clara: descuento alto ↔ operaciones no rentables.
