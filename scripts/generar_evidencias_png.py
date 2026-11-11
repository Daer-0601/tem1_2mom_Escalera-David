# -*- coding: utf-8 -*-
"""Arma capturas tipo terminal a partir de las salidas de Beeline."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

BASE = Path(__file__).resolve().parents[1]
SHOTS = BASE / "evidencia" / "shots"
PNG = BASE / "evidencia"
PNG.mkdir(parents=True, exist_ok=True)


def font(size=15):
    for name in (
        r"C:\Windows\Fonts\consola.ttf",
        r"C:\Windows\Fonts\cour.ttf",
        r"C:\Windows\Fonts\lucon.ttf",
    ):
        p = Path(name)
        if p.exists():
            return ImageFont.truetype(str(p), size)
    return ImageFont.load_default()


def clean_lines(text, keep=45):
    out = []
    for line in text.splitlines():
        # quitar secuencias ANSI y ruido de Tez
        if "\x1b[" in line or "VERTICES" in line or "ELAPSED TIME" in line:
            continue
        if line.startswith("INFO  :") or line.startswith("SLF4J:"):
            continue
        if "Compiling command" in line or "Executing command" in line:
            continue
        if "Launching Job" in line or "Starting task" in line:
            continue
        if "Tez session" in line or "Dag name" in line or "HS2 Host" in line:
            continue
        if "Status: Running" in line or "Subscribed to counters" in line:
            continue
        if "Completed compiling" in line or "Completed executing" in line:
            continue
        if "Semantic Analysis" in line or "Created Hive schema" in line:
            continue
        if "Concurrency mode" in line or "Query ID" in line or "Total jobs" in line:
            continue
        if line.strip() == "Closing: 0: jdbc:hive2://localhost:10000":
            continue
        if "Failed to create directory" in line or "No such file or directory" in line:
            continue
        out.append(line.rstrip())
    # quedarse con pedazos utiles: headers/resultados/selected
    useful = []
    for line in out:
        if not line.strip():
            if useful and useful[-1] != "":
                useful.append("")
            continue
        useful.append(line)
    if len(useful) > keep:
        # preferir el final (resultados)
        useful = useful[-keep:]
    return useful


def render(name, title, lines, width=1400):
    f = font(15)
    ftitle = font(18)
    pad = 28
    line_h = 22
    rows = [title, ""] + lines
    height = pad * 2 + line_h * (len(rows) + 1)
    img = Image.new("RGB", (width, max(height, 420)), (12, 16, 22))
    draw = ImageDraw.Draw(img)
    draw.rectangle([0, 0, width, 46], fill=(22, 30, 42))
    y = pad
    for i, line in enumerate(rows):
        color = (120, 200, 255) if i == 0 else (230, 236, 226)
        draw.text((pad, y), line[:180], font=ftitle if i == 0 else f, fill=color)
        y += line_h if i else 28
    path = PNG / name
    img.save(path)
    print("PNG", path)


def from_file(shot_name, png_name, title, keep=40):
    path = SHOTS / shot_name
    text = path.read_text(encoding="utf-8", errors="ignore") if path.exists() else "(sin archivo)"
    lines = clean_lines(text, keep=keep)
    if not lines:
        lines = ["(sin salida limpia)"]
    render(png_name, title, lines, width=1500 if keep > 35 else 1300)


def main():
    # docker
    dpath = SHOTS / "p00_docker.txt"
    if dpath.exists():
        render(
            "ex-00-docker.png",
            "Examen - Docker (stack Hive)",
            dpath.read_text(encoding="utf-8", errors="ignore").splitlines()[:20],
        )
    from_file("p01_carga.txt", "ex-01-carga.png", "P1 - Carga / DESCRIBE / COUNT", keep=50)
    from_file("p02_calidad.txt", "ex-02-calidad.png", "P2 - Auditoria de calidad", keep=35)
    from_file("p03_region.txt", "ex-03-region.png", "P3 - Evolucion por region", keep=40)
    from_file("p04_rfm.txt", "ex-04-rfm.png", "P4 - Segmentacion RFM", keep=40)
    from_file("p05_productos.txt", "ex-05-productos.png", "P5 - Ranking de productos", keep=40)
    from_file("p06_descuentos.txt", "ex-06-descuentos.png", "P6 - Impacto de descuentos", keep=35)
    from_file("p07_tendencias.txt", "ex-07-tendencias.png", "P7 - Tendencias mensuales", keep=40)
    from_file("p08_pareto.txt", "ex-08-pareto.png", "P8 - Pareto 80/20", keep=35)
    from_file("p09_optimizacion.txt", "ex-09-optimizacion.png", "Optimizacion - ORC / particiones", keep=35)
    print("OK")


if __name__ == "__main__":
    main()
