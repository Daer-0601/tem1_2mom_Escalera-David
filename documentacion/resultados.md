# Resultados (resumen)

Detalle por pregunta en `pregunta-01.md` … `pregunta-08.md`.  
Números cruzados con Beeline (`evidencia/shots/`).

## P1 — Modelo
Landing `stg_superstore` + analítica ORC `superstore_DEscalera`. 9994 filas. ZIP con LPAD.

## P2 — Calidad
Limpio en integridad (0 duplicados, 0 nulos clave, 0 fechas al revés). 1871 líneas con pérdida (negocio). 438 ZIP de 4 dígitos en el landing.

## P3 — Regiones
West mejor ganancia; Central peor margen.

## P4 — RFM
Fecha ref 2017-12-30. En riesgo = R bajo y F alto (se enfrió). Inactivo separado.

## P5 — Productos
Canon imageCLASS manda. Hay ventas altas con margen malo.

## P6 — Descuentos
Descuento alto (>50%): 100% líneas con pérdida.

## P7 — Mensual
Picos a fin de año (nov-2017, dic-2016, sep-2017).

## P8 — Pareto
~22% de productos → ~80% ventas/ganancias.
