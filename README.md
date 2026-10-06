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
8. Presents key business trends through Databricks visualizations

---

## Architecture

```text
                    Walmart Retail Excel Data
                              |
                              v
                    +--------------------+
                    |   Bronze Layer     |
                    |   Raw Delta Table  |
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
