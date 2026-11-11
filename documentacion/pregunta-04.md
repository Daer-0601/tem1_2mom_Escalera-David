# Pregunta 4. Segmentación RFM de clientes

**Enunciado.** Recency, Frequency, Monetary, puntuaciones e identificación de alto valor, recurrentes y en riesgo. Justificar criterios.

## Estrategia

Fecha de referencia: `MAX(order_date)` = 2017-12-30.

- Recency: días desde la última compra.
- Frequency: órdenes distintas.
- Monetary: `SUM(sales)`.
- Scores 1–5 con `NTILE(5)` (5 = mejor).

Segmentos:

| Segmento | Regla | Por qué |
|---|---|---|
| Alto valor | R,F,M ≥ 4 | Reciente, frecuente y gasta |
| Recurrente | R≥3, F≥4, M≥3 | Vuelve seguido |
| En riesgo | R≤2 y F≥3 | Compraba y se enfrió |
| Dormido valioso | R≤2 y M≥4 | Ticket alto, hace rato sin comprar |
| Inactivo | R≤2 y F≤2 | Poca historia y lejos |
| Regular | resto | |

## Consulta HiveQL

Ver `sql/04_rfm.sql`.

## Evidencia

`evidencia/ex-04-rfm.png` y `evidencia/shots/p04_rfm.txt`.

## Resultado

793 clientes. La cartera se parte entre alto valor / recurrentes (a cuidar) y riesgo / dormidos / inactivos (a reactivar o no gastar igual).

## Interpretación

RFM evita mirar solo “quién gastó más”. Alguien con monetary alto pero recency malo no es el mismo caso que un cliente reciente frecuente.

## Conclusión

Priorizar retención del alto valor y campañas sobre los que están en riesgo (ya conocen el canal).
