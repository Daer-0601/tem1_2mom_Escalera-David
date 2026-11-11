# -*- coding: utf-8 -*-
"""Calculo local de las metricas del examen (para cruzar con Hive)."""
import csv
import json
from collections import defaultdict
from datetime import datetime
from pathlib import Path

BASE = Path(__file__).resolve().parents[1]
CSV = BASE / "datos" / "superstore_DEscalera.csv"
OUT = BASE / "evidencia" / "resultados.json"


def parse_date(s):
    return datetime.strptime(s, "%m/%d/%Y")


def main():
    rows = list(csv.DictReader(CSV.open(encoding="utf-8"), delimiter="|"))
    for r in rows:
        r["_od"] = parse_date(r["order_date"])
        r["_sd"] = parse_date(r["ship_date"])
        r["sales"] = float(r["sales"])
        r["profit"] = float(r["profit"])
        r["discount"] = float(r["discount"])
        r["quantity"] = int(r["quantity"])

    fecha_ref = max(r["_od"] for r in rows)
    out = {
        "total": len(rows),
        "ordenes": len({r["order_id"] for r in rows}),
        "clientes": len({r["customer_id"] for r in rows}),
        "productos": len({r["product_id"] for r in rows}),
        "fecha_min": min(r["_od"] for r in rows).date().isoformat(),
        "fecha_max": fecha_ref.date().isoformat(),
        "ventas_tot": round(sum(r["sales"] for r in rows), 2),
        "ganancia_tot": round(sum(r["profit"] for r in rows), 2),
        "perdidas": sum(1 for r in rows if r["profit"] < 0),
        "dup_row": len(rows) - len({r["row_id"] for r in rows}),
        "ventas_le0": sum(1 for r in rows if r["sales"] <= 0),
        "dto_fuera": sum(1 for r in rows if not (0 <= r["discount"] <= 1)),
        "envio_antes": sum(1 for r in rows if r["_sd"] < r["_od"]),
    }

    # region x anio
    reg = defaultdict(lambda: {"ventas": 0.0, "ganancia": 0.0})
    for r in rows:
        key = (r["region"], r["_od"].year)
        reg[key]["ventas"] += r["sales"]
        reg[key]["ganancia"] += r["profit"]
    out["region_anio"] = [
        {
            "region": k[0],
            "anio": k[1],
            "ventas": round(v["ventas"], 2),
            "ganancia": round(v["ganancia"], 2),
            "margen": round(v["ganancia"] / v["ventas"] * 100, 2) if v["ventas"] else None,
        }
        for k, v in sorted(reg.items())
    ]
    reg_tot = defaultdict(float)
    for r in rows:
        reg_tot[r["region"]] += r["profit"]
    out["mejor_region"] = max(reg_tot, key=reg_tot.get)
    out["peor_region"] = min(reg_tot, key=reg_tot.get)

    # RFM
    cust = {}
    for r in rows:
        c = cust.setdefault(r["customer_id"], {"name": r["customer_name"], "orders": set(), "sales": 0.0, "last": r["_od"]})
        c["orders"].add(r["order_id"])
        c["sales"] += r["sales"]
        if r["_od"] > c["last"]:
            c["last"] = r["_od"]
    rfm = []
    for cid, c in cust.items():
        rfm.append({
            "id": cid,
            "name": c["name"],
            "recency": (fecha_ref - c["last"]).days,
            "frequency": len(c["orders"]),
            "monetary": round(c["sales"], 2),
        })
    rfm.sort(key=lambda x: x["monetary"], reverse=True)
    out["top_rfm"] = rfm[:10]

    # descuentos
    def rango(d):
        if d == 0:
            return "Sin descuento"
        if d <= 0.2:
            return "Descuento bajo"
        if d <= 0.5:
            return "Descuento medio"
        return "Descuento alto"

    dto = defaultdict(lambda: {"n": 0, "ventas": 0.0, "ganancia": 0.0, "perd": 0, "sum_d": 0.0})
    for r in rows:
        k = rango(r["discount"])
        dto[k]["n"] += 1
        dto[k]["ventas"] += r["sales"]
        dto[k]["ganancia"] += r["profit"]
        dto[k]["sum_d"] += r["discount"]
        if r["profit"] < 0:
            dto[k]["perd"] += 1
    out["descuentos"] = {
        k: {
            "n": v["n"],
            "ventas": round(v["ventas"], 2),
            "ganancia": round(v["ganancia"], 2),
            "margen": round(v["ganancia"] / v["ventas"] * 100, 2) if v["ventas"] else None,
            "pct_perd": round(v["perd"] * 100 / v["n"], 2),
            "dto_prom": round(v["sum_d"] / v["n"] * 100, 2),
        }
        for k, v in dto.items()
    }

    # mensual
    mes = defaultdict(lambda: {"ventas": 0.0, "ganancia": 0.0})
    for r in rows:
        key = (r["_od"].year, r["_od"].month)
        mes[key]["ventas"] += r["sales"]
        mes[key]["ganancia"] += r["profit"]
    meses = [{"anio": k[0], "mes": k[1], "ventas": round(v["ventas"], 2), "ganancia": round(v["ganancia"], 2)} for k, v in sorted(mes.items())]
    out["meses"] = meses
    by_v = sorted(meses, key=lambda x: x["ventas"], reverse=True)
    out["top3_meses"] = by_v[:3]
    out["bottom3_meses"] = sorted(meses, key=lambda x: x["ventas"])[:3]

    # pareto ventas
    prod_v = defaultdict(float)
    prod_g = defaultdict(float)
    names = {}
    for r in rows:
        prod_v[r["product_id"]] += r["sales"]
        prod_g[r["product_id"]] += r["profit"]
        names[r["product_id"]] = r["product_name"]
    tot_v = sum(prod_v.values())
    acum = 0
    n80v = 0
    for pid, v in sorted(prod_v.items(), key=lambda x: -x[1]):
        acum += v
        n80v += 1
        if acum / tot_v >= 0.8:
            break
    pos = [(pid, g) for pid, g in prod_g.items() if g > 0]
    tot_g = sum(g for _, g in pos)
    acum = 0
    n80g = 0
    for pid, g in sorted(pos, key=lambda x: -x[1]):
        acum += g
        n80g += 1
        if acum / tot_g >= 0.8:
            break
    out["pareto_ventas"] = {"n": n80v, "total": len(prod_v), "pct": round(n80v * 100 / len(prod_v), 2)}
    out["pareto_ganancia"] = {"n": n80g, "total": len(pos), "pct": round(n80g * 100 / len(pos), 2)}

    # top productos
    by_cat = defaultdict(list)
    for pid, v in prod_v.items():
        # need category - get from rows
        pass
    cat_of = {}
    for r in rows:
        cat_of[r["product_id"]] = r["category"]
    prods = []
    for pid in prod_v:
        prods.append({
            "id": pid,
            "name": names[pid],
            "cat": cat_of[pid],
            "ventas": round(prod_v[pid], 2),
            "ganancia": round(prod_g[pid], 2),
            "margen": round(prod_g[pid] / prod_v[pid] * 100, 2) if prod_v[pid] else None,
        })
    out["top5_ventas"] = sorted(prods, key=lambda x: -x["ventas"])[:5]
    out["peor5_margen"] = sorted([p for p in prods if p["ventas"] > 0], key=lambda x: x["margen"])[:5]
    top_cat = {}
    for p in sorted(prods, key=lambda x: -x["ganancia"]):
        top_cat.setdefault(p["cat"], [])
        if len(top_cat[p["cat"]]) < 5:
            top_cat[p["cat"]].append(p)
    out["top5_ganancia_cat"] = top_cat

    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(out, ensure_ascii=False, indent=2), encoding="utf-8")
    print("OK", OUT)


if __name__ == "__main__":
    main()
