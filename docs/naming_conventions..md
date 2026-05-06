# 🏷️ Naming Conventions

> **Overview**
> Establishing strict, universal naming conventions ensures that the data warehouse remains intuitive, predictable, and manageable as it scales. This document outlines the standard taxonomy for schemas, tables, views, columns, and programmatic objects across all data layers.

---

## 🏗️ 1. General Principles

* **Format:** All objects must exclusively use `snake_case` (lowercase letters with underscores separating words).
* **Language:** English is the mandatory language for all object naming.
* **Safety:** The use of SQL reserved keywords (e.g., `select`, `table`, `date`, `user`) as object names is strictly prohibited.

---

## 🗄️ 2. Table Naming Conventions

Table naming strategies shift from source-aligned in the raw layers to business-aligned in the analytical layers.

### 🥉 Bronze & 🥈 Silver Layers
* **Rule:** Maintain absolute fidelity to the source system. Do not apply business renaming at this stage.
* **Pattern:** `<source_system>_<entity_name>`
    * `<source_system>`: The abbreviated origin system (e.g., `crm`, `erp`, `hris`).
    * `<entity_name>`: The exact, unedited table name extracted from the source.
* **Example:** `crm_customer_info` (Data extracted directly from the CRM's 'customer_info' table).

### 🥇 Gold Layer
* **Rule:** Transition to semantic, business-friendly names categorized by their dimensional modeling role.
* **Pattern:** `<category_prefix>_<business_entity>`
    * `<category_prefix>`: The architectural role of the table (`dim`, `fact`, `report`).
    * `<business_entity>`: A clear, descriptive noun aligned with business terminology.
* **Examples:**
    * `dim_customers` (A dimension table holding customer profiles).
    * `fact_sales` (A fact table holding sales transaction metrics).

#### **Category Prefix Glossary**

| Prefix | Architectural Meaning | Example Implementation |
| :--- | :--- | :--- |
| `dim_` | **Dimension Table:** Descriptive, contextual attributes (the "who, what, where"). | `dim_products`, `dim_stores` |
| `fact_` | **Fact Table:** Quantitative, measurable events (the "how much, how many"). | `fact_inventory`, `fact_sales` |
| `report_` | **Report/View:** Pre-aggregated datasets built specifically for downstream BI tools. | `report_monthly_revenue` |

---

## 📋 3. Column Naming Conventions

### 🔑 Surrogate Keys
* **Rule:** Dimension tables must use auto-incrementing/hashed surrogate primary keys, independent of source system IDs.
* **Pattern:** `<entity_name>_key`
* **Example:** `customer_key` (The surrogate primary key for `dim_customers`).

### ⚙️ Technical/Metadata Columns
* **Rule:** System-generated audit columns must be distinctly identifiable to separate them from business data.
* **Pattern:** `dwh_<metadata_purpose>`
* **Example:** `dwh_create_date` (Timestamp indicating when the pipeline inserted the row).

---

## 📜 4. Stored Procedure Naming Conventions

* **Rule:** Procedures responsible for orchestrating data pipelines must clearly indicate their target destination layer.
* **Pattern:** `load_<target_layer>`
* **Examples:**
    * `load_bronze` (Procedure executing the extraction into the Bronze schema).
    * `load_silver` (Procedure executing the cleaning and insertion into the Silver schema).
