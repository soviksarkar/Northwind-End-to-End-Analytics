# Northwind End-to-End Analytics Pipeline & Power BI Dashboard

## 📌 Project Overview
This project is a complete end-to-end data analytics solution based on the Northwind database. It demonstrates a full ETL (Extract, Transform, Load) workflow, transitioning raw, messy data into a highly optimized, interactive Power BI dashboard designed for business intelligence and operational tracking.

## ⚠️ Important Execution Note for SQL Scripts
The SQL script (`northwind SQL project.sql`) is structured to showcase a real-world ETL pipeline. **Please execute the script block-by-block rather than using "Run All".** 
Between Step 1 (Extract) and Step 2 (Load), data was exported and manual data cleaning was performed externally to resolve messy rows, missing geographic regions, and data inconsistencies before importing the finalized, clean data back into pgAdmin.

## 🛠️ Tech Stack & Workflow
* **PostgreSQL:** Extracted data using complex `JOIN` operations across multiple raw tables (Orders, Order Details, Products, Territories, Employees). Built optimized staging tables and dynamic `VIEWs` to connect directly to Power BI.
* **Power BI:** Developed a multi-page interactive dashboard with advanced data modeling, DAX measures, and bookmark-driven navigation.

## 📊 Dashboard Highlights
1. **Sales & Product Insights:** Tracks MoM Growth, total revenue by category, top active customers, and a detailed breakdown of top-selling versus discontinued products within the portfolio.
2. **Operations & Logistics Overview:** Focuses on supply chain efficiency, tracking late deliveries by third-party Shippers, order volume handled by internal employees, and current stock valuation. 

**Technical Problem-Solving & UI/UX:**
* **Optimized Data Modeling:** Corrected default relationship models by routing geographic filtering (City, Country, Region) through the `Orders` table rather than the `Shippers` table to ensure accurate delivery tracking.
* **Slicer Panel Engineering:** Built custom hidden slicer panels using Power BI bookmarks, resolving default sorting errors to ensure dynamic, accurate filtering.
* **Professional UI Design:** Implemented transparent shapes for clean structural alignment, eliminated heavy visual borders for a modern interface, and standardized naming conventions across all metrics.

## 📸 Dashboard Screenshots

### Sales & Product Insights
![Sales Dashboard]([Insert your first screenshot file name here, e.g., sales_dashboard.jpg])

### Operations & Logistics Overview
![Operations Dashboard]([Insert your second screenshot file name here, e.g., operations_dashboard.jpg])
