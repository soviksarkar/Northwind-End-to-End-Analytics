-- STEP 1: EXTRACT RAW DATA
-- Joining multiple raw tables to fetch the initial messy data.
-- (Note: This data was exported and cleaned externally to fix messy rows)
DROP TABLE IF EXISTS cleaned_fact_sales CASCADE;
CREATE TABLE cleaned_fact_sales AS
SELECT 
    od.orderID::text AS orderid,
    od.productID::text AS productid,
    p.categoryID::text AS categoryid,
    p.supplierID::text AS supplierid,
    o.customerID::text AS customerid,
    o.employeeID::text AS employeeid,
    o.shipVia::text AS shipperid,
    et.territoriId::text AS territoriid, 
    t.regionID::text AS regionid,
    o.orderDate::text AS orderdate,
    o.requiredDate::text AS requireddate,
    o.shippedDate::text AS shippeddate,
    o.shipCity::text AS city,
    o.shipCountry::text AS country,
    od.unitPrice::text AS unitprice,
    od.quantity::text AS quantity,
    (od.unitPrice::numeric * od.quantity::numeric)::text AS total_amount
FROM order_details od
JOIN orders o ON od.orderID::text = o.orderID::text
JOIN products p ON od.productID::text = p.productID::text
LEFT JOIN employee_territories et ON o.employeeID::text = et.employeeID::text
LEFT JOIN territories t ON et.territoriId::text = t.territoryID::text;
-- select * from cleaned_fact_sales;

-- STEP 2: LOAD CLEANED DATA
-- Creating the final schema to import the cleaned dataset
DROP TABLE IF EXISTS cleaned_fact_sales CASCADE;
CREATE TABLE cleaned_fact_sales (
    orderid TEXT,      
    productid TEXT,
    categoryid TEXT,
    supplierid TEXT,
    customerid TEXT,
    employeeid TEXT,
    shipperid TEXT,
    territoriid TEXT,
    regionid TEXT,
    orderdate TEXT,
    requireddate TEXT,
    shippeddate TEXT,
    unitprice TEXT,
    quantity TEXT,
    total_amount TEXT,
    city TEXT,
    country TEXT
);

-- STEP 3: CREATE VIEW FOR POWER BI
DROP VIEW IF EXISTS v_pbi_fact_sales;
CREATE VIEW v_pbi_fact_sales AS
SELECT * FROM cleaned_fact_sales;
======================================================
-- 1. CREATE TABLE 
DROP TABLE IF EXISTS pbi_dim_categories CASCADE;
CREATE TABLE pbi_dim_categories (
    categoryid INTEGER,
    category_name VARCHAR
);

-- 2. CREATE VIEW
CREATE OR REPLACE VIEW v_pbi_dim_categories AS
SELECT 
    categoryID AS categoryid,
    categoryName AS category_name
FROM categories;

====================================================
-- 1. CREATE TABLE
DROP TABLE IF EXISTS pbi_dim_shippers CASCADE;
CREATE TABLE pbi_dim_shippers (
    shipperid INTEGER,
    company_name VARCHAR
);

-- 2. CREATE VIEW
CREATE OR REPLACE VIEW v_pbi_dim_shippers AS
SELECT 
    shipperID AS shipperid,
    companyName AS company_name
FROM shippers;
===================================================
-- 1. CREATE TABLE
DROP TABLE IF EXISTS pbi_dim_regions CASCADE;
CREATE TABLE pbi_dim_regions (
    regionid INTEGER,
    region_description VARCHAR
);

-- 2. CREATE VIEW
CREATE OR REPLACE VIEW v_pbi_dim_regions AS
SELECT 
    regionID AS regionid,
    regionDescription AS region_description
FROM regions;
  
==================================================
-- 5. Employees 
DROP VIEW IF EXISTS v_pbi_dim_employees CASCADE;
DROP TABLE IF EXISTS cleaned_dim_employees CASCADE;

CREATE TABLE cleaned_dim_employees AS
SELECT 
    employeeid AS employee_id, 
    firstname || ' ' || lastname AS full_name,
    lastname AS last_name, 
    firstname AS first_name, 
    title, 
    city, 
    region, 
    country
FROM employees;

CREATE VIEW v_pbi_dim_employees AS
SELECT * FROM cleaned_dim_employees;
=========================================================
-- 6. Products 
DROP VIEW IF EXISTS v_pbi_dim_products CASCADE;
DROP TABLE IF EXISTS cleaned_dim_products CASCADE;

CREATE TABLE cleaned_dim_products AS
SELECT 
    productid AS product_id, 
    productname AS product_name, 
    supplierid AS supplier_id, 
    categoryid AS category_id, 
    unitprice AS unit_price,
    unitsinstock AS units_in_stock,
    discontinued
FROM products;

CREATE VIEW v_pbi_dim_products AS
SELECT * FROM cleaned_dim_products;
==========================================================
-- 7. Customers 
DROP VIEW IF EXISTS v_pbi_dim_customers CASCADE;
DROP TABLE IF EXISTS cleaned_dim_customers CASCADE;

CREATE TABLE cleaned_dim_customers AS
SELECT 
    customerid, 
    companyname AS company_name, 
    contactname AS contact_name, 
    contacttitle AS contact_title, 
    city, 
    region, 
    country
FROM customers;

CREATE VIEW v_pbi_dim_customers AS
SELECT * FROM cleaned_dim_customers;
=============================================================
-- STEP 1: EXTRACT RAW DATA
-- Fetching the raw suppliers data for external cleaning
DROP VIEW IF EXISTS v_pbi_dim_suppliers CASCADE;
DROP TABLE IF EXISTS cleaned_dim_suppliers CASCADE;
CREATE TABLE cleaned_dim_suppliers AS
SELECT 
    supplierid, 
    companyname AS company_name, 
    contactname AS contact_name, 
    contacttitle AS contact_title, 
    city, 
    region, 
    country
FROM suppliers;

-- STEP 2: LOAD CLEANED DATA
-- Schema to import the cleaned suppliers dataset
DROP TABLE IF EXISTS suppliers_import CASCADE;
CREATE TABLE suppliers_import (
    supplierid INT PRIMARY KEY,
    companyname VARCHAR(100),
    contactname VARCHAR(100),
    contacttitle VARCHAR(100),
    city VARCHAR(50),
    region VARCHAR(50),
    country VARCHAR(50)
);
-- select * from suppliers_import;

--  STEP 3: CHANGE COLUMN NAME FOR EASY TO UNDERSTAND
DROP VIEW IF EXISTS v_pbi_dim_suppliers CASCADE;
DROP TABLE IF EXISTS cleaned_dim_suppliers CASCADE;

CREATE TABLE cleaned_dim_suppliers AS
SELECT 
    supplierid AS supplier_id, 
    companyname AS company_name, 
    contactname AS contact_name, 
    city, 
    region, 
    country
FROM suppliers_import;

-- STEP 4: CREATE VIEW FOR POWER BI
DROP VIEW IF EXISTS v_pbi_dim_suppliers;
CREATE VIEW v_pbi_dim_suppliers AS
SELECT * FROM cleaned_dim_suppliers;
=================================================
-- 9. Ship_region
CREATE TABLE dim_ship_region (
    orderid INT PRIMARY KEY,
    customerid VARCHAR(10),
    shipvia INT,
    shipregion VARCHAR(100)
);

CREATE VIEW v_pbi_dim_ship_region AS
SELECT 
    orderid,
    customerid,
    shipvia,
    shipregion
FROM dim_ship_region;
