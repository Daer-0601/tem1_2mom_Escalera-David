# -*- coding: utf-8 -*-
"""Pasa el Sample Superstore a pipe (|) porque product_name trae comas."""
import csv
from pathlib import Path

BASE = Path(__file__).resolve().parents[1]
# Busca el CSV original en la raiz o en datos/
CANDIDATES = [
    BASE / "Sample - Superstore.csv",
    BASE / "datos" / "Sample - Superstore.csv",
]
SRC = next((p for p in CANDIDATES if p.exists()), CANDIDATES[0])
OUT = BASE / "datos" / "superstore_DEscalera.csv"

MAPPING = [
    ("Row ID", "row_id"),
    ("Order ID", "order_id"),
    ("Order Date", "order_date"),
    ("Ship Date", "ship_date"),
    ("Ship Mode", "ship_mode"),
    ("Customer ID", "customer_id"),
    ("Customer Name", "customer_name"),
    ("Segment", "segment"),
    ("Country", "country"),
    ("City", "city"),
    ("State", "state"),
    ("Postal Code", "postal_code"),
    ("Region", "region"),
    ("Product ID", "product_id"),
    ("Category", "category"),
    ("Sub-Category", "sub_category"),
    ("Product Name", "product_name"),
    ("Sales", "sales"),
    ("Quantity", "quantity"),
    ("Discount", "discount"),
    ("Profit", "profit"),
]


def main():
    OUT.parent.mkdir(parents=True, exist_ok=True)
    with SRC.open(encoding="cp1252", newline="") as f, OUT.open("w", encoding="utf-8", newline="") as g:
        reader = csv.DictReader(f)
        g.write("|".join(new for _, new in MAPPING) + "\n")
        n = 0
        for row in reader:
            vals = []
            for old, _ in MAPPING:
                v = row.get(old) or ""
                v = v.replace("|", "/").replace("\n", " ").replace("\r", "")
                vals.append(v)
            g.write("|".join(vals) + "\n")
            n += 1
    print(f"OK {n} filas -> {OUT}")


if __name__ == "__main__":
    main()
