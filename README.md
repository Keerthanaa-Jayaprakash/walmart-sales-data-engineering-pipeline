# Walmart Retail Sales Data Engineering Pipeline

An end-to-end **data engineering pipeline built using Databricks, PySpark, Delta Lake, Unity Catalog, and SQL** to transform raw Walmart retail sales data into analytics-ready dimensional data and business insights.

The project implements a **Bronze → Silver → Gold architecture**, automated data-quality validation, Databricks Workflow orchestration, and SQL-based analytics with a Databricks dashboard.

---

## Project Overview

This project demonstrates how raw retail sales data can be processed through a modern lakehouse architecture.

The pipeline:

1. Ingests raw Walmart retail sales data from Excel
2. Stores the raw data as a Bronze Delta table
3. Cleans and standardizes the data in the Silver layer
4. Builds a Gold dimensional model using fact and dimension tables
5. Performs automated data-quality checks
6. Orchestrates the pipeline using Databricks Workflows
7. Runs SQL analytics on the Gold layer
8. Presents key business trends through a Databricks dashboard

---

## Architecture

```text
                    Walmart Retail Excel Data
                              |
                              v
                    +--------------------+
                    |   Bronze Layer     |
                    | Raw Delta Table    |
                    +--------------------+
                              |
                              v
                    +--------------------+
                    |   Silver Layer     |
                    | Cleaned & Standard |
                    +--------------------+
                              |
                              v
                    +--------------------+
                    |    Gold Layer      |
                    | Fact + Dimensions  |
                    +--------------------+
                              |
                 +------------+-------------+
                 |                          |
                 v                          v
        Data Quality Checks          SQL Analytics
                 |                          |
                 +------------+-------------+
                              |
                              v
                    Databricks Dashboard
```

---

## Technologies Used

* **Databricks**
* **Apache Spark / PySpark**
* **Delta Lake**
* **Unity Catalog**
* **Python**
* **SQL**
* **Databricks Workflows**
* **Pandas**
* **OpenPyXL**
* **Excel**

---

## Dataset

The project uses a Walmart retail sales dataset containing **8,399 sales transactions** and **25 source columns**.

The dataset contains information related to:

* Orders
* Customers
* Products
* Sales
* Profit
* Discounts
* Shipping
* Locations
* Order and shipping dates

Raw data is uploaded to a Unity Catalog Volume before ingestion.

---

# Medallion Architecture

## Bronze Layer

The Bronze layer stores the ingested source data with minimal transformation.

### Table

```text
walmart_retail.sales.bronze_sales
```

### Characteristics

* 8,399 rows
* 25 columns
* Raw source data
* Column names standardized to lowercase snake_case
* Stored as Delta
* Source data loaded from Excel using Pandas/OpenPyXL

Example column transformations:

```text
Customer Name       → customer_name
Order Date          → order_date
Order Quantity      → order_quantity
Product Category    → product_category
```

---

## Silver Layer

The Silver layer applies data cleaning and type standardization.

### Table

```text
walmart_retail.sales.silver_sales
```

### Transformations

* Converted order and shipping dates to date types
* Standardized numeric data types
* Converted identifiers and quantities to appropriate types
* Converted ZIP codes to string
* Trimmed string values
* Preserved expected source-level null values
* Validated business rules

### Silver Data Quality Checks

The pipeline validates:

* Invalid order quantities
* Negative sales
* Invalid discounts
* Discounts greater than 100%
* Shipping dates earlier than order dates
* Duplicate records

---

# Gold Layer

The Gold layer provides analytics-ready dimensional data.

The model follows a **star-schema approach** with one fact table and four dimension tables.

## Fact Table

```text
walmart_retail.sales.gold_fact_sales
```

### Records

**8,399 rows**

The fact table contains transaction-level sales information along with surrogate keys to the dimensions.

### Derived Metrics

The pipeline calculates:

```text
gross_sales
discount_amount
profit_margin_pct
shipping_days
```

For example:

```text
gross_sales = unit_price × order_quantity

discount_amount =
unit_price × order_quantity × discount

profit_margin_pct =
profit / sales × 100

shipping_days =
ship_date - order_date
```

---

## Dimension Tables

### Customer Dimension

```text
walmart_retail.sales.gold_dim_customer
```

**989 customers**

Contains customer-related attributes such as:

* Customer name
* Customer segment

---

### Product Dimension

```text
walmart_retail.sales.gold_dim_product
```

**1,264 products**

Contains:

* Product name
* Product category
* Product sub-category
* Product container
* Product base margin

---

### Date Dimension

```text
walmart_retail.sales.gold_dim_date
```

**1,418 dates**

Contains calendar attributes including:

* Date key
* Year
* Quarter
* Month
* Month name
* Week of year
* Day of month
* Day of week
* Day name

---

### Location Dimension

```text
walmart_retail.sales.gold_dim_location
```

**1,636 locations**

Contains:

* City
* State
* ZIP code
* Region

---

# Data Quality Framework

A dedicated data-quality notebook validates the pipeline before downstream analytics.

Notebook:

```text
04_Data_Quality_Checks
```

The framework performs:

* Row-count validation
* Null checks
* Duplicate checks
* Business-rule validation
* Gold surrogate-key validation

The pipeline validates **24 data-quality checks**.

Final validation:

```text
Total checks : 24
Passed       : 24
Failed       : 0
Overall status: PASS
```

The notebook also acts as a **workflow quality gate** by raising an exception when validation fails.

---

# Databricks Workflow

The pipeline is orchestrated using **Databricks Workflows**.

### Workflow

```text
Bronze Ingestion
       |
       v
Silver Transformation
       |
       v
Gold Transformation
       |
       v
Data Quality Checks
```

### Workflow Tasks

| Task                  | Notebook                   | Dependency |
| --------------------- | -------------------------- | ---------- |
| Bronze Ingestion      | `01_Bronze_Ingestion`      | None       |
| Silver Transformation | `02_Silver_Transformation` | Bronze     |
| Gold Transformation   | `03_Gold_Transformation`   | Silver     |
| Data Quality Checks   | `04_Data_Quality_Checks`   | Gold       |

The complete workflow was successfully executed after validation issues were resolved.

---

# SQL Analytics

The Gold layer is queried using Databricks SQL to answer business questions such as:

### 1. Overall Sales Performance

* Total orders
* Total sales
* Total profit
* Average profit margin
* Total units sold

### 2. Product Category Performance

* Sales by category
* Profit by category
* Units sold
* Profit margin

### 3. Regional Performance

* Sales by region
* Profit by region
* Units sold
* Regional profit margin

### 4. Monthly Sales Trends

* Monthly sales
* Monthly profit
* Units sold
* Monthly profit margin

### 5. Top Products

Identifies the top 10 products based on total sales and evaluates their profitability.

### Additional Analysis

The SQL analytics notebook also examines:

* Customer segment performance
* State-level sales
* Shipping-mode performance
* Loss-making products

---

# Databricks Dashboard

A Databricks dashboard was created from the SQL analytics results.

### Dashboard

**Walmart Retail Sales Dashboard**

The dashboard contains three visualizations:

### Sales by Product Category

A bar chart comparing sales performance across product categories.

### Sales by Region

A bar chart showing sales distribution across geographic regions.

### Monthly Sales Trend

A line chart showing how sales change over time.

The remaining SQL queries are retained as analytical tables rather than dashboard visualizations.

---

# Key Results

The Gold fact table contains:

```text
8,399 transactions
```

Overall dataset metrics include approximately:

```text
Total Sales   : $14.92M
Total Profit  : $1.52M
```

The pipeline also calculates transaction-level and aggregated profitability metrics for deeper analysis.

---

# Project Structure

```text
walmart-sales-data-engineering-pipeline/
│
├── 01_Bronze_Ingestion
│   └── Bronze ingestion notebook
│
├── 02_Silver_Transformation
│   └── Silver transformation notebook
│
├── 03_Gold_Transformation
│   └── Gold dimensional modeling notebook
│
├── 04_Data_Quality_Checks
│   └── Data quality validation notebook
│
├── 06_Gold_Analytics
│   └── SQL business analytics notebook
│
└── README.md
```

---

# Data Pipeline Flow

```text
Raw Excel
   |
   v
Unity Catalog Volume
   |
   v
Bronze Delta Table
   |
   v
Silver Delta Table
   |
   v
Gold Fact + Dimensions
   |
   +----> Data Quality Validation
   |
   +----> SQL Analytics
              |
              v
       Databricks Dashboard
```

---

# What This Project Demonstrates

This project demonstrates practical experience with:

* Building a Medallion architecture
* Developing PySpark ETL pipelines
* Working with Delta tables
* Using Unity Catalog
* Designing dimensional models
* Creating fact and dimension tables
* Generating surrogate keys
* Implementing data-quality checks
* Building reusable validation logic
* Orchestrating dependent notebooks with Databricks Workflows
* Writing analytical SQL queries
* Creating business dashboards
* Working with structured retail data

---

# Future Improvements

Potential extensions include:

* Incremental data ingestion
* Parameterized pipeline execution
* Automated scheduling
* Additional performance optimization
* More advanced dashboard filtering
* Integration with cloud object storage
* Monitoring and alerting for production workloads

---

## Author

**Keerthanaa Jayaprakash**

Data Engineering | Databricks | PySpark | SQL | Delta Lake
