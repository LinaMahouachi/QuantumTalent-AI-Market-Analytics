
## Project Overview

This project designs and implements an **end-to-end ETL pipeline for HR Analytics** using a **Bronze–Silver–Gold data architecture**.  
The objective is to transform raw HR-related job market data into a **trusted, analytics-ready data warehouse** that supports **workforce planning, compensation analysis, and talent strategy**.

The project simulates a real-world **HR analytics use case**, where raw job posting data is ingested, cleaned, validated, and modeled for decision-making by HR managers and business stakeholders.

## Business Questions & Use Cases

The analytics model supports key HR and talent intelligence questions, including:

- Which AI and data roles are most in demand over time?
- How do salaries vary by role, experience level, and location?
- Which industries offer the most competitive compensation packages?
- How do benefits and job requirements differ across roles and regions?

These insights and more help HR teams optimize recruitment strategies, compensation benchmarking, and workforce planning.


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

## Power BI Analytics & Reporting

The Gold layer is directly connected to Power BI to enable:

- Interactive dashboards for HR stakeholders
- Trend analysis of job demand over time
- Salary benchmarking by role, location, and experience
- Skill demand visualization
- Executive-level KPI reporting

All metrics are implemented using optimized DAX measures on a star schema model.


## Tools Used
- **SQL Server (T-SQL)**
- **Jupyter Notebook** for ETL documentation
- **CSV data sources**
- **GitHub** for version control and collaboration
- **Power BI**Data modeling, DAX measures, and interactive dashboards for analytics and insights

## ETL process 

This project includes an ETL  pipeline that processes AI job listings data, to reproduce the ETL process follow toi step below:
**1 Download the Raw Dataset** : The raw dataset is included in this repository at datasets/ai_jobs_row.csv 
**2 Open the ETL Notebook** :The ETL pipeline is implemented in the Jupyter notebook etl.ipynb 
**3 Run the ipynb file**: 
- Launch Jupyter Notebook or JupyterLab in your environment
- Open etl.ipynb
- Execute each code cell sequentially to run the ETL process: extracting,transforming,loading and verifying


## Team

This project was developed collaboratively as a team-based data analytics project:
- Fatma Rahma Messai
- Lina Mahouachi
- Mohamed Omar Ben Dhaou
- Ibrahim Khalil Louhichi
