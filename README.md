
## Project Overview

This project designs and implements an **end-to-end ETL pipeline for HR Analytics** using a **Bronze–Silver–Gold data architecture**.  
The objective is to transform raw HR-related job market data into a **trusted, analytics-ready data warehouse** that supports **workforce planning, compensation analysis, and talent strategy**.

The project simulates a real-world **HR analytics use case**, where raw job posting data is ingested, cleaned, validated, and modeled for decision-making by HR managers and business stakeholders.

---

## Data Architecture: Bronze – Silver – Gold

###  Bronze Layer – Raw HR Data
- Stores raw job posting data exactly as received from CSV files.
- No transformations applied.
- Ensures data traceability and auditability.

**Purpose:** Preserve original HR data for reproducibility and reprocessing.


###  Silver Layer – Cleaned & Standardized HR Data
- Cleans and standardizes HR job data.
- Fixes data types, formatting issues, and missing values.
- Ensures primary key uniqueness and data consistency.
- Categorizes HR metrics 
- Prepares data for analytical modeling.


###  Gold Layer – HR Analytics Model
- Implements **fact and dimension tables** optimized for analytics.
- Designed for reporting, KPIs, and dashboards.


## Tools Used
- **SQL Server (T-SQL)**
- **Jupyter Notebook** for ETL documentation
- **CSV data sources**
- **GitHub** for version control and collaboration


