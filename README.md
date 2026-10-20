# Retail Sales & Customer Analytics SQL

## Project Overview

This project uses SQL and PostgreSQL to analyze retail sales performance and customer purchasing behavior. It explores sales revenue, product performance, category performance, order trends, discounts, and customer activity.

The goal is to turn raw retail data into useful insights that can support business decisions.

## Tools Used

- PostgreSQL
- SQL
- DBeaver
- Git and GitHub (for version control and project sharing)

## Database Structure

The project uses a PostgreSQL schema named `retail`, containing five tables:

- `categories`
- `customers`
- `products`
- `orders`
- `order_items`

## Project Workflow

1. Create the database schema and tables.
2. Load sample retail data.
3. Check data quality and consistency.
4. Analyze sales, products, categories, orders, and customers.

## Key Analysis Areas

- Overall sales revenue and discounts
- Completed, cancelled, and processing orders
- Average order value
- Top- and bottom-performing products by net sales
- Sales performance by product category
- Monthly sales trends
- Top customers by completed sales
- Customer order frequency
- Data quality and sales amount consistency

## Key Findings

- Total net sales from completed orders were **KSh 3,405,010**.
- There were **764 completed orders**.
- Average order value was approximately **KSh 4,456.82**.
- Electronics generated the highest completed net sales, at **KSh 1,112,460**.
- The Bluetooth Speaker was the highest-performing product by net sales, generating **KSh 417,495**.
- Data quality checks found no missing key values, invalid quantities, orphaned order-item references, or inconsistent sales amounts in the checks performed.

## SQL Scripts

| File | Purpose |
|---|---|
| `01_create_tables.sql` | Creates the schema and tables |
| `02_load_sample_data.sql` | Loads the sample data |
| `03_data_quality_checks.sql` | Checks data quality and consistency |
| `04_sales_analysis.sql` | Calculates sales and supports sales analysis |

## How to Use This Project

1. Install PostgreSQL and DBeaver.
2. Create or select a development database.
3. Run the table-creation script first, then load the sample data.
4. Run the data quality checks.
5. Run the sales analysis queries.

**Warning:** The table-creation script may drop and recreate the `retail` schema. Review the script and use a disposable development database before running it, because existing data in that schema may be deleted.

## Conclusion

This project demonstrates the use of SQL for relational data analysis, data quality validation, and business reporting. It provides a foundation for further work in customer segmentation, sales dashboards, and business intelligence.