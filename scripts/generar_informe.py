# -*- coding: utf-8 -*-
"""Informe del examen practico Superstore. Texto en tono de practica, no de brochure."""
import os
from docx import Document
from docx.shared import Inches, Pt, Cm, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.oxml.ns import qn, nsdecls
from docx.oxml import parse_xml, OxmlElement

BASE = r"d:\Tecnologias Emergentes\examenparcial2"
EV = os.path.join(BASE, "evidencia")
OUT = os.path.join(BASE, "documentacion", "Examen_Practico_Superstore_Escalera.docx")
LOGO = os.path.join(EV, "_cover", "image1.png")
T = "dbex_DEscalera.superstore_DEscalera"

doc = Document()
sec = doc.sections[0]
sec.top_margin = Cm(2.2)
sec.bottom_margin = Cm(2.0)
sec.left_margin = Cm(2.3)
sec.right_margin = Cm(2.3)
sec.different_first_page_header_footer = True
st = doc.styles["Normal"]
st.font.name = "Times New Roman"
st.font.size = Pt(12)
st._element.rPr.rFonts.set(qn("w:ascii"), "Times New Roman")
st._element.rPr.rFonts.set(qn("w:hAnsi"), "Times New Roman")
st.paragraph_format.space_after = Pt(8)
st.paragraph_format.line_spacing = 1.15
cab = sec.header.paragraphs[0]
cab.alignment = WD_ALIGN_PARAGRAPH.RIGHT
rc = cab.add_run("David Andres Escalera Rocha   ·   Examen 2do momento")
rc.font.name = "Times New Roman"
rc.font.size = Pt(10)
rc.font.color.rgb = RGBColor(90, 90, 90)
pie = sec.footer.paragraphs[0]
pie.alignment = WD_ALIGN_PARAGRAPH.CENTER
rp = pie.add_run("Tecnologías Emergentes I")
rp.font.name = "Times New Roman"
rp.font.size = Pt(10)


def titulo(texto):
    p = doc.add_paragraph()
    p.paragraph_format.space_before = Pt(16)
    p.paragraph_format.space_after = Pt(6)
    r = p.add_run(texto)
    r.bold = True
    r.font.name = "Times New Roman"
    r.font.size = Pt(14)
    pPr = p._p.get_or_add_pPr()
    pBdr = OxmlElement("w:pBdr")
    bottom = OxmlElement("w:bottom")
    bottom.set(qn("w:val"), "single")
    bottom.set(qn("w:sz"), "8")
    bottom.set(qn("w:space"), "1")
    bottom.set(qn("w:color"), "6B2D5B")
    pBdr.append(bottom)
    pPr.append(pBdr)


def cuerpo(texto):
    p = doc.add_paragraph(texto)
    p.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY
    p.paragraph_format.space_after = Pt(8)
    for run in p.runs:
        run.font.name = "Times New Roman"
        run.font.size = Pt(12)


def codigo(texto):
    tabla = doc.add_table(rows=1, cols=1)
    celda = tabla.cell(0, 0)
    celda.text = ""
    p = celda.paragraphs[0]
    p.paragraph_format.space_after = Pt(0)
    r = p.add_run(texto)
    r.font.name = "Courier New"
    r.font.size = Pt(8)
    celda._tc.get_or_add_tcPr().append(parse_xml(f'<w:shd {nsdecls("w")} w:val="clear" w:fill="F7F4F6"/>'))
    doc.add_paragraph().paragraph_format.space_after = Pt(2)


def evidencia(nombre, pie_txt):
    path = os.path.join(EV, nombre)
    if not os.path.exists(path):
        return
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.add_run().add_picture(path, width=Inches(6.15))
    cap = doc.add_paragraph(pie_txt)
    cap.alignment = WD_ALIGN_PARAGRAPH.CENTER
    cap.paragraph_format.space_before = Pt(2)
    cap.paragraph_format.space_after = Pt(8)
    for run in cap.runs:
        run.italic = True
        run.font.name = "Times New Roman"
        run.font.size = Pt(10)
        run.font.color.rgb = RGBColor(80, 80, 80)


def centro(texto, size=12, bold=False, antes=0, despues=0):
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.paragraph_format.space_before = Pt(antes)
    p.paragraph_format.space_after = Pt(despues)
    if texto:
        r = p.add_run(texto)
        r.bold = bold
        r.font.size = Pt(size)
        r.font.name = "Times New Roman"


def etiqueta(label, valor):
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    a = p.add_run(label)
    a.bold = True
    a.font.size = Pt(14)
    a.font.name = "Times New Roman"
    b = p.add_run(valor)
    b.font.size = Pt(14)
    b.font.name = "Times New Roman"


def pregunta(num, enunciado):
    p = doc.add_paragraph()
    p.paragraph_format.space_before = Pt(14)
    p.paragraph_format.space_after = Pt(4)
    r = p.add_run(f"Pregunta {num}. {enunciado}")
    r.bold = True
    r.font.name = "Times New Roman"
    r.font.size = Pt(12)


# portada
p = doc.add_paragraph()
p.alignment = WD_ALIGN_PARAGRAPH.CENTER
if os.path.exists(LOGO):
    p.add_run().add_picture(LOGO, width=Inches(1.7))
centro("")
centro("Examen Práctico Individual — 2do Momento", size=20, bold=True, antes=12, despues=8)
centro("Sample Superstore Dataset", size=16, antes=0, despues=18)
centro("")
centro("David Andres Escalera Rocha", size=16, antes=6, despues=18)
centro("")
etiqueta("Universidad: ", "Universidad del Valle")
etiqueta("Carrera: ", "Ingeniería de Sistemas Informáticos")
etiqueta("Materia: ", "Tecnologías Emergentes I")
etiqueta("Docente: ", "Ing. Efrain Luna Mamani")
centro("")
centro("Tiquipaya – Cochabamba – 2026", size=14, bold=True, antes=18)
doc.add_page_break()

titulo("1. Entorno y dataset")
cuerpo(
    "El entorno Docker está dentro del propio repo, en docker-hadoop-hive-parquet: Hadoop 3.4.1 y Hive 4.0.1. "
    "En Hive 4 se consulta con Beeline, no con el CLI viejo. NameNode en 9870, HiveServer2 en 10000."
)
cuerpo(
    "El CSV viene de Kaggle (Sample Superstore). Product Name trae comas, así que el archivo de trabajo va con separador |. "
    "Base: dbex_DEscalera. Landing: stg_superstore (TEXTFILE). Analítica: superstore_DEscalera (ORC + Snappy). "
    "Cargaron 9994 filas. También armé superstore_part particionada por anio."
)
evidencia("ex-00-docker.png", "Figura. Contenedores del stack en ejecución.")

titulo("2. Diccionario de datos (resumen)")
cuerpo(
    "En el landing todo queda STRING. En la analítica pasé fechas a DATE, números a DOUBLE/INT y postal_code a STRING "
    "con LPAD a 5 dígitos (si fuera INT se pierde el cero de Nueva Inglaterra). "
    "Detalle en diccionario_datos.md."
)

tabla = doc.add_table(rows=1, cols=3)
tabla.style = "Table Grid"
for i, h in enumerate(["Campo", "Tipo Hive", "Nota"]):
    tabla.rows[0].cells[i].text = h
filas = [
    ("row_id", "INT", "Id de fila; sin duplicados"),
    ("order_id", "STRING", "Código de orden"),
    ("order_date / ship_date", "DATE", "Parseadas desde M/d/yyyy en la carga"),
    ("postal_code", "STRING", "LPAD a 5; no INT"),
    ("region", "STRING", "Central, East, South, West"),
    ("category / sub_category", "STRING", "Clasificación de producto"),
    ("product_name", "STRING", "Trae comas → separador |"),
    ("sales / quantity / discount / profit", "DOUBLE/INT", "Métricas de línea"),
]
for a, b, c in filas:
    row = tabla.add_row().cells
    row[0].text = a
    row[1].text = b
    row[2].text = c
for i, row in enumerate(tabla.rows):
    for cell in row.cells:
        for par in cell.paragraphs:
            for run in par.runs:
                run.font.name = "Times New Roman"
                run.font.size = Pt(9)
                if i == 0:
                    run.bold = True
                    run.font.color.rgb = RGBColor(255, 255, 255)
        if i == 0:
            cell._tc.get_or_add_tcPr().append(parse_xml(f'<w:shd {nsdecls("w")} w:val="clear" w:fill="6B2D5B"/>'))
doc.add_paragraph()

titulo("3. Desarrollo por pregunta")

pregunta(1, "Diseño e implementación del modelo de datos")
cuerpo(
    "Estrategia: landing STRING + analítica ORC tipada. LOAD DATA al staging y después INSERT con parseo de fechas y LPAD del ZIP."
)
codigo(
    "CREATE TABLE stg_superstore (... STRING ...)\n"
    "ROW FORMAT DELIMITED FIELDS TERMINATED BY '|'\nSTORED AS TEXTFILE;\n\n"
    "CREATE TABLE superstore_DEscalera (... order_date DATE, postal_code STRING, ...)\n"
    "STORED AS ORC TBLPROPERTIES ('orc.compress'='SNAPPY');\n\n"
    "LOAD DATA INPATH '/tmp/superstore_DEscalera.csv' OVERWRITE INTO TABLE stg_superstore;\n"
    "INSERT OVERWRITE TABLE superstore_DEscalera\n"
    "SELECT CAST(row_id AS INT), ..., TO_DATE(...), LPAD(postal_code,5,'0'), ...\n"
    "FROM stg_superstore;\n"
    "ANALYZE TABLE superstore_DEscalera COMPUTE STATISTICS;"
)
cuerpo(
    "Resultado: 9994 registros en ORC. En el landing hay 438 ZIP de 4 dígitos; en la analítica quedan a 5. "
    "Conclusión: tipar en la carga evita pelear con fechas y ZIP en cada consulta."
)
evidencia("ex-01-carga.png", "Figura. Carga, muestra y conteo en Beeline.")

pregunta(2, "Auditoría de calidad e integridad")
cuerpo(
    "Estrategia: resumen sobre la analítica tipada (duplicados, nulos, fechas, sales<=0, descuento fuera de 0-1, envío antes del pedido, pérdidas)."
)
codigo(
    "SELECT COUNT(*) total_registros,\n"
    "  COUNT(*)-COUNT(DISTINCT row_id) row_id_duplicados,\n"
    "  COUNT(DISTINCT order_id) ordenes_unicas,\n"
    "  COUNT(DISTINCT customer_id) clientes_unicos,\n"
    "  SUM(CASE WHEN sales<=0 THEN 1 ELSE 0 END) ventas_le_cero,\n"
    "  SUM(CASE WHEN discount<0 OR discount>1 THEN 1 ELSE 0 END) descuento_fuera_rango,\n"
    "  SUM(CASE WHEN ship_date<order_date THEN 1 ELSE 0 END) envio_antes_pedido,\n"
    "  SUM(CASE WHEN profit<0 THEN 1 ELSE 0 END) lineas_con_perdida\n"
    f"FROM {T};"
)
cuerpo(
    "Salió limpio: 0 duplicados, 5009 órdenes, 793 clientes, 0 nulos clave, 0 fechas al revés, 0 sales<=0. "
    "1871 líneas con pérdida (negocio, no basura). 438 ZIP cortados en el landing → LPAD. "
    "Tratamiento: no borro pérdidas; normalizo ZIP."
)
evidencia("ex-02-calidad.png", "Figura. Resumen de calidad.")

pregunta(3, "Evolución comercial por región")
cuerpo(
    "Estrategia: agregar ventas/ganancia por región y YEAR(order_date), después LAG y RANK."
)
codigo(
    "WITH anual AS (\n"
    "  SELECT region, YEAR(order_date) anio,\n"
    "         ROUND(SUM(sales),2) ventas, ROUND(SUM(profit),2) ganancia\n"
    f"  FROM {T}\n"
    "  GROUP BY region, YEAR(order_date)\n"
    ")\nSELECT region, anio, ventas, ganancia,\n"
    "  ROUND(ganancia/NULLIF(ventas,0)*100,2) margen_pct,\n"
    "  ROUND((ventas-LAG(ventas) OVER (PARTITION BY region ORDER BY anio))\n"
    "    /NULLIF(LAG(ventas) OVER (PARTITION BY region ORDER BY anio),0)*100,2) var_ventas_pct\n"
    "FROM anual ORDER BY region, anio;"
)
cuerpo(
    "West termina como la región más sólida (~108k de ganancia acumulada, margen ~15%). "
    "Central es la más floja (~39.7k, margen ~8%). East crece casi todo el período. "
    "South es más chica y con altibajos (2015 bajó fuerte). Conclusión: el crecimiento no es parejo; West empuja la rentabilidad."
)
evidencia("ex-03-region.png", "Figura. Serie regional y ranking.")

pregunta(4, "Segmentación RFM de clientes")
cuerpo(
    "Estrategia: fecha_ref = MAX(order_date). Recency = días desde la última compra. "
    "Frequency = órdenes distintas. Monetary = SUM(sales). Scores con NTILE(5) y etiquetas simples."
)
codigo(
    "WITH rfm_raw AS (\n"
    "  SELECT customer_id, DATEDIFF(MAX(order_date) global, MAX(order_date)) recency,\n"
    "    COUNT(DISTINCT order_id) frequency, ROUND(SUM(sales),2) monetary\n"
    "  FROM superstore_DEscalera GROUP BY customer_id\n), scored AS (\n"
    "  SELECT *, NTILE(5) OVER (ORDER BY recency DESC) r_score,\n"
    "         NTILE(5) OVER (ORDER BY frequency ASC) f_score,\n"
    "         NTILE(5) OVER (ORDER BY monetary ASC) m_score FROM rfm_raw\n)\n"
    "-- Alto valor: R,F,M>=4 | En riesgo: R<=2 y F>=3 | Inactivo: R<=2 y F<=2"
)
cuerpo(
    "Fecha de referencia: 2017-12-30. En riesgo = compraba (F alto) y se enfrió (R malo). "
    "Inactivo va aparte. Conclusión: RFM separa retención vs reactivación mejor que mirar solo el total gastado."
)
evidencia("ex-04-rfm.png", "Figura. Clientes RFM y conteo por segmento.")

pregunta(5, "Ranking de productos según rentabilidad")
cuerpo(
    "Estrategia: agregar por product_id. RANK por ganancia dentro de categoría, DENSE_RANK por ventas globales, "
    "y un top de peor margen. También SUM OVER para ganancia acumulada por categoría."
)
codigo(
    "SELECT category, product_id, product_name, ventas, ganancia, margen_pct,\n"
    "  RANK() OVER (PARTITION BY category ORDER BY ganancia DESC) rank_ganancia_cat,\n"
    "  DENSE_RANK() OVER (ORDER BY ventas DESC) dense_rank_ventas_global\n"
    "FROM prod;"
)
cuerpo(
    "El Canon imageCLASS 2200 manda en ventas (~61600) y en ganancia (~25200). "
    "Ojo: el Cisco TelePresence vende mucho (~22600) pero pierde (~-1811). "
    "En Furniture ganan sobre todo sillas Hon/Global. Conclusión: volumen ≠ rentabilidad."
)
evidencia("ex-05-productos.png", "Figura. Rankings de productos.")

pregunta(6, "Impacto de los descuentos")
cuerpo(
    "Estrategia: clasificar discount en sin / bajo (<=20%) / medio (<=50%) / alto (>50%) y medir ventas, margen y % de pérdidas."
)
codigo(
    "CASE\n  WHEN discount = 0 THEN 'Sin descuento'\n"
    "  WHEN discount > 0 AND discount <= 0.20 THEN 'Descuento bajo'\n"
    "  WHEN discount > 0.20 AND discount <= 0.50 THEN 'Descuento medio'\n"
    "  WHEN discount > 0.50 THEN 'Descuento alto'\nEND AS rango_dto"
)
cuerpo(
    "Sin descuento: margen ~29.5% y 0% de líneas en pérdida. "
    "Bajo: margen ~11.9%, ~14% no rentable. Medio: margen negativo (~-20%) y ~92% con pérdida. "
    "Alto: margen ~-119% y 100% de líneas en pérdida. "
    "Sí hay relación clara: a más descuento agresivo, más operaciones que no rinden. Binders y Furnishings se ven mucho en el daño."
)
evidencia("ex-06-descuentos.png", "Figura. Rangos de descuento y categorías afectadas.")

pregunta(7, "Análisis de tendencias temporales")
cuerpo(
    "Estrategia: agregar por año-mes, LAG del mes anterior, LAG 12 para YoY y AVG de 3 meses como media móvil."
)
codigo(
    "SELECT anio, mes, ventas, ganancia,\n"
    "  ROUND((ventas-LAG(ventas) OVER (ORDER BY anio,mes))\n"
    "    /NULLIF(LAG(ventas) OVER (ORDER BY anio,mes),0)*100,2) var_mes_pct,\n"
    "  ROUND((ventas-LAG(ventas,12) OVER (ORDER BY anio,mes))\n"
    "    /NULLIF(LAG(ventas,12) OVER (ORDER BY anio,mes),0)*100,2) var_yoy_pct,\n"
    "  ROUND(AVG(ventas) OVER (ORDER BY anio,mes ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) media_movil_3m\n"
    "FROM mensual;"
)
cuerpo(
    "Picos: nov-2017 (~118k), dic-2016 (~97k), sep-2017 (~88k). "
    "Más flojos: feb-2014, feb-2015, ene-2014. Se nota temporada fuerte a fin de año. "
    "La media móvil suaviza el ruido. Conclusión: el negocio es estacional; planificar stock/promos con eso en mente."
)
evidencia("ex-07-tendencias.png", "Figura. Serie mensual y extremos.")

pregunta(8, "Análisis Pareto de ventas y rentabilidad")
cuerpo(
    "Estrategia: ordenar productos por aporte, calcular % acumulado con SUM OVER y cortar al llegar al 80%. "
    "En ganancia solo conté profit > 0 para no mezclar pérdidas en el acumulado."
)
codigo(
    "SELECT product_id, ventas,\n"
    "  ROUND(SUM(ventas) OVER (ORDER BY ventas DESC\n"
    "    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)*100.0/SUM(ventas) OVER(),4) pct_acum,\n"
    "  ROW_NUMBER() OVER (ORDER BY ventas DESC) n_prod\n"
    "FROM por_prod;"
)
cuerpo(
    "Ventas: 414 de 1862 productos (~22%) concentran el 80%. "
    "Ganancia positiva: 340 de 1558 (~22%). No es exactamente 20/80, pero se acerca. "
    "La diferencia importa: hay productos que venden mucho y aportan poco (o pierden). "
    "Conclusión: cuidar el núcleo Pareto y revisar el resto con descuento agresivo."
)
evidencia("ex-08-pareto.png", "Figura. Corte 80% ventas/ganancias.")

titulo("4. Optimización")
cuerpo(
    "Landing + ORC/Snappy, ANALYZE TABLE para estadísticas, postal_code STRING + LPAD, fechas a DATE en la carga. "
    "Particioné superstore_part por anio (sql/09_optimizacion.sql). En P3/P7/P8 agrego primero y después aplico ventanas."
)
evidencia("ex-09-optimizacion.png", "Figura. Stats ORC y partición por año.")

titulo("5. Conclusiones")
cuerpo(
    "1) Landing + ORC deja el modelo usable sin casteos en cada pregunta. "
    "2) La calidad es alta; el tema real son pérdidas y descuentos altos. "
    "3) West es la región más rentable; Central arrastra el margen más bajo. "
    "4) RFM separa alto valor, en riesgo e inactivos. "
    "5) Pareto (~22% de productos → ~80% del valor) confirma concentración. "
    "6) Stack Docker va en el repo; consultas con Beeline."
)

cuerpo(
    "Repositorio: https://github.com/Daer-0601/tem1_2mom_Escalera-David.git"
)

doc.save(OUT)
print(OUT)
