# 
# Juel Antonio Teixeira Baptista
# Basil Ecommerce data cleaned.
#

import pandas as pd
import matplotlib.pyplot as plt
from sqlalchemy import create_engine
import os

# Generating graphs to show of the findings.
#
# 1. Connect to your database
engine = create_engine("postgresql+psycopg2://postgres:postgres@localhost:5432/olist")

os.makedirs("charts", exist_ok=True)

print("Generating charts...")

# =====================================
# Chart 1: Late Delivery vs Review Score
# =====================================
df1 = pd.read_sql("""
    SELECT
        CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date + INTERVAL '1 day'
             THEN 'Late' ELSE 'On-time' END AS delivery_status,
        ROUND(AVG(r.score)::numeric, 2) AS avg_score
    FROM clean.orders o
    JOIN clean.order_reviews r ON o.order_id = r.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
    GROUP BY delivery_status
""", engine)

plt.figure(figsize=(6, 4))
plt.bar(df1['delivery_status'], df1['avg_score'], color=['#e74c3c', '#2ecc71'])
plt.title('Late delivery hurts review scores')
plt.ylabel('Average Review Score (1-5)')
plt.ylim(0, 5)
for i, v in enumerate(df1['avg_score']):
    plt.text(i, v + 0.1, str(v), ha='center', fontweight='bold')
plt.savefig("charts/late_vs_ontime.png", dpi=150, bbox_inches="tight")
plt.close()
print(" - Chart 1 saved.")

# ======================================
# Chart 2: Revenue by Category (Top 10)
# ======================================
df2 = pd.read_sql("""
    SELECT
        COALESCE(t.product_category_name_english, p.product_category_name) AS category,
        ROUND(SUM(oi.price)::numeric, 2) AS total_revenue
    FROM clean.order_items oi
    JOIN clean.products p ON oi.product_id = p.product_id
    LEFT JOIN clean.product_translated_to_english t ON p.product_category_name = t.product_category_name
    GROUP BY COALESCE(t.product_category_name_english, p.product_category_name)
    ORDER BY total_revenue DESC
    LIMIT 10
""", engine)

plt.figure(figsize=(8, 5))
plt.barh(df2['category'], df2['total_revenue'], color='#2ecc71')
plt.title('Top 10 categories by revenue')
plt.xlabel('Total Revenue (R$)')
plt.gca().invert_yaxis() # largest at the top

for i , v in enumerate(df2['total_revenue']):
    plt.text(v+50000, i, f'R${v:,.0f}', va='center', fontsize=10)

plt.savefig("charts/revenue_by_category.png", dpi=150, bbox_inches="tight")
plt.close()
print(" - Chart 2 saved.")

# ============================
# Chart 3: Monthly Order Trend
# =============================
df3 = pd.read_sql("""
    SELECT
        DATE_TRUNC('month', order_purchase_timestamp)::date AS month,
        COUNT(*) AS n_orders
    FROM clean.orders
    GROUP BY DATE_TRUNC('month', order_purchase_timestamp)
    ORDER BY month
""", engine)

plt.figure(figsize=(10, 4))
plt.plot(df3['month'], df3['n_orders'], marker='o', color='#2ecc71')
plt.title('Monthly order volume')
plt.ylabel('Number of Orders')
plt.grid(axis='y', alpha=0.3)
plt.savefig("charts/monthly_trend.png", dpi=150, bbox_inches="tight")
plt.close()

print(" - Chart 3 saved.")
print("Done! Check your 'charts/' folder.")
