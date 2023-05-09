# ===================================================================================
# How to Integrate a Dimension table. In other words, how to look-up Foreign Key
# values FROM a dimension table and add them to new Fact table columns.
#
# First, go to Edit -> Preferences -> SQL Editor and disable 'Safe Edits'.
# Close SQL Workbench and Reconnect to the Server Instance.
# ===================================================================================

USE sakila_dw;

# ==============================================================
# Step 1: Add New Column(s)
# ==============================================================
ALTER TABLE sakila_dw.rental_fact
ADD COLUMN rental_date_key int NOT NULL AFTER rental_date, #order
ADD COLUMN return_date_key int NOT NULL AFTER return_date; #, #shipped
#ADD COLUMN paid_date_key int NOT NULL AFTER paid_date;

# ==============================================================
# Step 2: Update New Column(s) with value from Dimension table
#         WHERE Business Keys in both tables match.
# ==============================================================
UPDATE sakila_dw.rental_fact AS fo
JOIN sakila_dw.dim_date AS dd
ON DATE(fo.rental_date) = dd.full_date
SET fo.rental_date_key = dd.date_key;

UPDATE sakila_dw.rental_fact AS fo
JOIN sakila_dw.dim_date AS dd
ON DATE(fo.return_date) = dd.full_date
SET fo.return_date_key = dd.date_key;

#UPDATE sakila_dw.rental_fact AS fo
#JOIN sakila_dw.dim_date AS dd
#ON DATE(fo.paid_date) = dd.full_date
#SET fo.paid_date_key = dd.date_key;

# ==============================================================
# Step 3: Validate that newly updated columns contain valid data
# ==============================================================
SELECT * FROM sakila_dw.rental_fact
LIMIT 10;

# =============================================================
# Step 4: If values are correct then drop old column(s)
# =============================================================
#ALTER TABLE northwind_dw.fact_orders
#DROP COLUMN order_date,
#DROP COLUMN shipped_date,
#DROP COLUMN paid_date;

# =============================================================
# Step 5: Validate Finished Fact Table.
# =============================================================
#SELECT * FROM northwind_dw.fact_orders
#LIMIT 10;

