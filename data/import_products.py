"""
数码商城商品数据导入脚本
读取 data/products.xlsx，写入 digital_device_store 数据库的 category/product/product_image 三张表
可重复执行（每次先清空再插入）
"""

import sys
import os
import openpyxl
import pymysql

# ── 配置（与 application.yml 保持一致）──────────────────────────
DB_CONFIG = dict(
    host="localhost",
    port=3306,
    db="digital_device_store",
    user="root",
    password="root",
    charset="utf8mb4",
)

XLSX_PATH  = os.path.join(os.path.dirname(__file__), "products.xlsx")
DEFAULT_STOCK = 100

# ── 读取 xlsx ─────────────────────────────────────────────────
def load_xlsx(path):
    wb = openpyxl.load_workbook(path)
    ws = wb.active
    rows = list(ws.iter_rows(values_only=True))
    headers = rows[0]
    records = []
    for row in rows[1:]:
        item = dict(zip(headers, row))
        records.append(item)
    return records

# ── 主流程 ────────────────────────────────────────────────────
def main():
    print("[1] 读取 xlsx ...")
    records = load_xlsx(XLSX_PATH)
    print(f"    共 {len(records)} 条商品")

    conn = pymysql.connect(**DB_CONFIG, autocommit=False)
    try:
        with conn.cursor() as cur:
            # 1. 清空（按外键顺序：product_image -> product -> category）
            print("[2] 清空旧数据 ...")
            cur.execute("DELETE FROM product_image")
            cur.execute("DELETE FROM product")
            cur.execute("DELETE FROM category")

            # 2. 插入分类
            print("[3] 插入分类 ...")
            category_names = sorted({r["分类"] for r in records if r["分类"]})
            category_id_map = {}
            for name in category_names:
                cur.execute(
                    "INSERT INTO category (name, parent_id) VALUES (%s, NULL)",
                    (name,)
                )
                category_id_map[name] = cur.lastrowid
            print(f"    插入 {len(category_id_map)} 个分类")

            # 3. 插入商品 + 图片
            print("[4] 插入商品与图片 ...")
            inserted_products = 0
            inserted_images   = 0
            for r in records:
                cat_id = category_id_map.get(r["分类"])
                cur.execute(
                    """INSERT INTO product (name, price, stock, category_id, brand, description)
                       VALUES (%s, %s, %s, %s, %s, %s)""",
                    (
                        r["商品名称"],
                        r["价格"],
                        DEFAULT_STOCK,
                        cat_id,
                        r["品牌"],
                        r["商品描述"],
                    )
                )
                product_id = cur.lastrowid
                inserted_products += 1

                # 图片：逗号分隔，每张插一行
                images_raw = r.get("图片") or ""
                for img_file in [f.strip() for f in images_raw.split(",") if f.strip()]:
                    url = f"/images/{img_file}"
                    cur.execute(
                        "INSERT INTO product_image (product_id, url) VALUES (%s, %s)",
                        (product_id, url)
                    )
                    inserted_images += 1

        conn.commit()
        print(f"[OK] 完成: {inserted_products} 个商品, {inserted_images} 张图片")

    except Exception as e:
        conn.rollback()
        print(f"[ERROR] 出错，已回滚: {e}", file=sys.stderr)
        sys.exit(1)
    finally:
        conn.close()

if __name__ == "__main__":
    main()
