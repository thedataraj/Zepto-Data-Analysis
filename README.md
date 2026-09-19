# Zepto Data Analysis | MySQL | SQL Business Analytics

![SQL](https://img.shields.io/badge/SQL-MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Data Analytics](https://img.shields.io/badge/Data-Analytics-E72380?style=for-the-badge)

## Project Overview

An end-to-end **Zepto product data analysis project using MySQL**, transforming product-level data into business insights across pricing, customer value, inventory, availability, and category strategy.

**Workflow:** Raw Data → Data Quality → Standardization → SQL Analysis → Insights → Recommendations

## Objectives

- Analyze product and category assortment.
- Understand pricing and discount patterns.
- Measure customer savings.
- Compare product value using **₹/100g**.
- Analyze inventory exposure and out-of-stock patterns.
- Benchmark categories against overall averages.
- Combine multiple metrics for strategic category review.

## Why I Chose This Dataset

I chose the Zepto dataset because it provides a realistic quick-commerce context with product, category, pricing, discount, inventory, availability, weight, and quantity fields. This allows SQL to be applied to multiple practical business questions instead of only basic data retrieval.

## Dataset Snapshot

| Metric | Value |
|---|---:|
| Final records | **3,723** |
| Categories | **14** |
| Core columns | **9** |
| Exact duplicate rows detected | **2** |
| Average MRP | **₹156.90** |
| Average selling price | **₹142.01** |
| Average discount | **7.63%** |
| Average customer savings | **₹14.89** |
| Overall out-of-stock rate | **12.17%** |

> **Note:** Inventory value in this project represents discounted selling price × available quantity. It is not actual sales revenue.

## Data Quality & Preparation

- NULL / completeness checks
- Duplicate detection
- Price validity checks
- Weight and quantity validation
- Stock-status validation
- Discount-field validation
- Price standardization from **paise → ₹**

## Analysis Areas

### Product & Category
Assortment depth, category distribution, and product-level analysis.

### Pricing & Discounts
Discount bands, average pricing, customer savings, and category discount benchmarking.

### Customer Value
Normalized **₹/100g** analysis for more meaningful comparison across different pack sizes.

### Inventory & Availability
Overall OOS rate, category OOS rates, high-value out-of-stock products, inventory value, inventory weight, and weight segmentation.

### Advanced SQL
CTEs, subqueries, conditional aggregation, ranking, window functions, and multi-metric analysis.

### Strategic Analysis
Combined pricing, discount, inventory, and availability metrics to create focused category-review conditions.

## Key Insights

- The **40%+ discount band** recorded average customer savings of **₹148.97**.
- The **0–10% discount band** contained **2,443 products**.
- **Fruits & Vegetables** recorded **₹25.34 per 100g** as the lowest category-level average shown.
- **Biscuits** recorded a **28.57%** out-of-stock rate.
- **Dairy, Bread & Batter** and **Beverages** each showed **21.71%** OOS.
- **Cooking Essentials** and **Munchies** each showed **₹337,131** in inventory value.
- **Fruits & Vegetables** was **7.83 percentage points above** the overall average discount of **7.63%**.
- The cross-metric analysis returned **Meats, Fish & Eggs, Biscuits, and Health & Hygiene** for the defined above-average discount and above-average OOS conditions.

## Recommendations

1. Review categories with elevated stockout rates and investigate replenishment patterns.
2. Monitor discount intensity alongside inventory and availability metrics.
3. Track categories with higher inventory-value exposure.
4. Use **₹/100g** when comparing products with different pack sizes.
5. Combine pricing, discount, inventory, customer savings, and OOS metrics for category review.

## SQL Techniques Demonstrated

**MySQL • CASE WHEN • GROUP BY • CTEs • Subqueries • Window Functions • Conditional Aggregation • Ranking • Data Cleaning • KPI Analysis • Category Benchmarking**

## Project Structure

```text
Zepto-Data-Analysis/
│
├── README.md
├── zepto_v2.csv
├── zepto_data_analysis_project.sql
└── Zepto_Dynamic_Premium_Light_Raj_Singh.pptx
 
```

Rename the SQL/PPT filenames above to match the exact files uploaded to your repository.

## How to Run

1. Open MySQL Workbench or another MySQL 8+ client.
2. Import `zepto_v2.csv` into your database/table.
3. Open the SQL project file.
4. Execute the queries section by section.
5. Review the outputs and business insights.

## Project Outcome

The project demonstrates a complete analytical flow:

**Data → Validation → SQL → Metrics → Insights → Business Recommendations**

The focus was on understanding the business question behind each query and communicating what the results mean.

## Author

**Raj Singh**  
**Data Analyst**

Built and developed as a portfolio project to demonstrate practical SQL and business analytics skills.

## Connect With Me

**Raj Singh — Data Analyst**

- LinkedIn: [linkedin.com/in/rajsingh1801](https://www.linkedin.com/in/rajsingh1801/)
- Email: [sraj10278@gmail.com](mailto:sraj10278@gmail.com)
