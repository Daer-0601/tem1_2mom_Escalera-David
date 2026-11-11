# Pregunta 2. Auditoría de calidad e integridad

**Enunciado.** Total de registros, Row ID duplicados, órdenes/clientes únicos, nulos, fechas inválidas, ventas ≤ 0, descuentos fuera de rango, envío antes del pedido, y criterios de tratamiento.

## Estrategia

El resumen lo corrí sobre la tabla analítica (ya tipada). Los ZIP de 4 dígitos los miré en el landing, porque en la analítica ya van con `LPAD`.

## Consulta HiveQL

Ver `sql/02_calidad.sql`.

## Evidencia

`evidencia/ex-02-calidad.png` y `evidencia/shots/p02_calidad.txt`.

## Resultado

| Métrica | Valor |
|---|---|
| Total | 9994 |
| row_id duplicados | 0 |
| Órdenes únicas | 5009 |
| Clientes únicos | 793 |
| Fechas inválidas / envío antes | 0 |
| Sales ≤ 0 | 0 |
| Discount fuera de 0–1 | 0 |
| Líneas con profit < 0 | 1871 |
| ZIP 4 dígitos (landing) | 438 |

## Tratamiento

| Problema | Qué hice |
|---|---|
| ZIP 4 dígitos | `LPAD` a 5; no borro la fila |
| profit < 0 | No es basura; las dejo para P6 |
| Fechas imposibles / dto fuera de rango | Si aparecieran, las sacaría del análisis temporal |

## Interpretación

El sample está limpio a nivel integridad. Lo “feo” de negocio son las pérdidas y los descuentos altos.

## Conclusión

Puedo trabajar las 9994 líneas sin depurar por borrado.
