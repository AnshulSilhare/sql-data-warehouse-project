# 🏛️ SQL Data Warehouse Project

![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![ETL](https://img.shields.io/badge/ETL%20Pipeline-005C84?style=for-the-badge&logo=apacheairflow&logoColor=white)
![Data Modeling](https://img.shields.io/badge/Star%20Schema-FF6F00?style=for-the-badge&logo=databricks&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen?style=for-the-badge)

> **A production-grade data warehouse built on SQL Server**, implementing Medallion Architecture with full ETL pipelines, dimensional modeling, and business analytics — end to end.

---

## 📌 Table of Contents

- [Overview](#-overview)
- [Architecture](#️-architecture)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Data Flow](#-data-flow)
- [Layers Breakdown](#-layers-breakdown)
- [Analytics & Reporting](#-analytics--reporting)
- [Getting Started](#-getting-started)
- [Documentation](#-documentation)
- [License](#-license)
- [Author](#-author)

---

## 🧠 Overview

This project simulates a **real-world enterprise data warehouse** — ingesting raw data from two source systems (ERP + CRM), cleaning and transforming it through layered pipelines, and serving business-ready models for analytical reporting.

**Core problem it solves:**
> Siloed, messy source data → Unified, query-optimized analytical layer

**What's covered:**
- Designing scalable warehouse architecture from scratch
- Writing production-quality ETL scripts in pure SQL
- Building a clean star schema for BI consumption
- Delivering insight-driven reports on sales, customers, and products

---

## 🏗️ Architecture

The warehouse follows the **Medallion Architecture** pattern — a layered approach that progressively refines raw data into analytical gold.

```
┌─────────────────────────────────────────────────────────┐
│                    SOURCE SYSTEMS                        │
│              ERP (CSV)        CRM (CSV)                  │
└────────────────────┬────────────────────────────────────┘
                     │  Ingest
                     ▼
┌─────────────────────────────────────────────────────────┐
│  🟤  BRONZE LAYER  — Raw, unmodified source data         │
│       Land as-is. No transformations. Audit trail.       │
└────────────────────┬────────────────────────────────────┘
                     │  Cleanse & Standardize
                     ▼
┌─────────────────────────────────────────────────────────┐
│  ⚪  SILVER LAYER  — Cleaned, normalized, validated      │
│       Deduplication, type casting, null handling.        │
└────────────────────┬────────────────────────────────────┘
                     │  Model & Aggregate
                     ▼
┌─────────────────────────────────────────────────────────┐
│  🟡  GOLD LAYER   — Star schema, business-ready          │
│       Fact + Dimension tables for reporting & BI.        │
└─────────────────────────────────────────────────────────┘
```

---

## ⚙️ Tech Stack

| Tool | Purpose |
|------|---------|
| **SQL Server Express** | Database engine hosting all warehouse layers |
| **SSMS** | Query execution, schema management, debugging |
| **T-SQL** | ETL scripting, transformations, and reporting |
| **Draw.io** | Architecture diagrams, data flow, ERDs |
| **Git + GitHub** | Version control and collaboration |
| **CSV Files** | Source data (ERP + CRM systems) |

---

## 📂 Project Structure

```
sql-data-warehouse-project/
│
├── 📁 datasets/               # Raw source CSVs — ERP and CRM data
│
├── 📁 docs/
│   ├── data_architecture.drawio   # Full warehouse architecture diagram
│   ├── data_flow.drawio           # ETL data flow visualization
│   ├── data_models.drawio         # Star schema ERD
│   ├── etl.drawio                 # ETL techniques and methods
│   ├── data_catalog.md            # Field-level metadata for all tables
│   └── naming-conventions.md     # Naming standards for tables/columns
│
├── 📁 scripts/
│   ├── bronze/                # Raw ingestion scripts
│   ├── silver/                # Cleaning & transformation scripts
│   └── gold/                  # Dimensional model creation scripts
│
├── 📁 tests/                  # Data quality checks and validation scripts
│
├── README.md
├── LICENSE
├── .gitignore
└── requirements.txt
```

---

## 🔄 Data Flow

```
CSV Files (ERP + CRM)
        │
        ▼
  [BULK INSERT] ──────────► Bronze Tables  (raw_crm_*, raw_erp_*)
                                  │
                          [CLEANSE + JOIN]
                                  │
                                  ▼
                          Silver Tables  (crm_*, erp_*)
                                  │
                      [AGGREGATE + MODEL]
                                  │
                                  ▼
                    Gold Layer  ┌──────────────┐
                                │  Fact Tables │
                                │  Dim Tables  │
                                └──────────────┘
                                       │
                                  SQL Reports
                                  & Dashboards
```

---

## 🔬 Layers Breakdown

### 🟤 Bronze — Raw Ingestion
- Direct load from CSV using `BULK INSERT`
- Zero transformations — preserves source fidelity
- Tracks ingestion timestamps for auditability

### ⚪ Silver — Transformation Zone
- Data type normalization and standardization
- Null handling, deduplication, trimming
- Business rule application and cross-source joins

### 🟡 Gold — Analytical Layer
Dimensional model built as a **Star Schema**:

| Table Type | Tables |
|-----------|--------|
| **Fact** | `fact_sales` |
| **Dimensions** | `dim_customer`, `dim_product`, `dim_date` |

Optimized for aggregation-heavy analytical queries.

---

## 📊 Analytics & Reporting

SQL-based reports delivering insights across three domains:

#### 👤 Customer Behavior
- Purchase frequency and recency
- Customer segmentation by revenue contribution
- Retention and churn indicators

#### 📦 Product Performance
- Top/bottom performing SKUs
- Category-level revenue breakdown
- Sales velocity and stock movement patterns

#### 📈 Sales Trends
- Monthly and yearly revenue trends
- Period-over-period growth analysis
- Regional and channel-based breakdowns

---

## 🚀 Getting Started

### Prerequisites
- [SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) — free, lightweight
- [SSMS](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms) — management GUI

### Setup

```sql
-- 1. Clone the repo
git clone https://github.com/AnshulSilhare/sql-data-warehouse-project.git

-- 2. Open SSMS and connect to your SQL Server instance

-- 3. Run scripts in order:
--    scripts/bronze/   → load raw data
--    scripts/silver/   → clean and transform
--    scripts/gold/     → build dimensional model
```

> ⚠️ Run scripts in sequence — each layer depends on the previous one.

---

## 📖 Documentation

| Document | Description |
|----------|-------------|
| [`data_catalog.md`](docs/data_catalog.md) | Field-level descriptions and metadata |
| [`naming-conventions.md`](docs/naming-conventions.md) | Naming standards across all objects |
| [`data_architecture.drawio`](docs/data_architecture.drawio) | Full architecture visual |
| [`data_models.drawio`](docs/data_models.drawio) | Star schema ERD |
| [`data_flow.drawio`](docs/data_flow.drawio) | End-to-end data flow diagram |

---

## 📄 License

This project is licensed under the **MIT License** — feel free to use, fork, and build on it with attribution.

See [`LICENSE`](LICENSE) for full terms.

---

## 👤 Author

**Anshul Silhare**

[![GitHub](https://img.shields.io/badge/GitHub-AnshulSilhare-181717?style=for-the-badge&logo=github)](https://github.com/AnshulSilhare)

---

<p align="center">
  <i>Built with SQL, structured thinking, and a lot of <code>GROUP BY</code>.</i>
</p>
