# Retail Inventory & Supply Chain Analysis

A SQL-based retail analytics project focused on understanding sales performance, inventory management, demand forecasting accuracy, and supply chain efficiency across multiple stores and products.

---

# Project Overview

In this project, I analyzed retail inventory and sales data to identify operational inefficiencies and business trends. The main focus was to understand how inventory is being managed, how accurate the demand forecasts are, and what factors influence sales performance.

The project explores areas such as overstocking, inventory utilization, sales trends, pricing impact, and forecasting bias using SQL queries and business analysis techniques.

---

# Tech Stack

• SQL (MySQL) – Used for data cleaning, transformation, and analysis
• CSV Dataset – Retail inventory and sales dataset
• Window Functions & CTEs – Used for advanced SQL analysis

---

# Dataset Information

The dataset contains retail sales, inventory, and supply chain-related information from multiple stores and products.

It includes important business fields such as:

* Product ID
* Store ID
* Category
* Region
* Inventory Level
* Units Sold
* Units Ordered
* Demand Forecast
* Price & Discount
* Competitor Pricing
* Weather Conditions
* Promotions & Seasonality

The dataset was used to analyze inventory efficiency, sales behavior, forecasting performance, and operational trends.

---

# Business Problem

Retail businesses often face challenges such as excess inventory, inaccurate forecasting, and inefficient stock management. These problems can increase operational costs and reduce overall efficiency.

Some key business questions explored in this project:

* Are products being overstocked?
* How accurate are the demand forecasts?
* Which products and regions contribute the most sales?
* Do pricing and discounts actually affect demand?
* Are promotions and seasonal factors influencing sales?

---

# Project Goal

The goal of this project was to use SQL to analyze retail operations and generate insights that could help improve inventory planning and business decision-making.

The analysis focused on:

* Sales performance analysis
* Inventory efficiency analysis
* Forecast accuracy evaluation
* Pricing and discount analysis
* Regional and category-level trends
* Supply chain and ordering behavior

---

# Key Analysis Performed

## Data Cleaning & Validation

Before starting the analysis, I checked the dataset for:

* Missing values
* Duplicate records
* Negative values in sales, inventory, and pricing columns
* Product and store consistency

The dataset was clean and reliable for analysis.

---

## Sales Analysis

I analyzed:

* Product-wise sales performance
* Category contribution to total sales
* Regional sales trends
* Monthly and yearly sales patterns

The results showed that sales were relatively stable across products and regions, with only small variations.

---

## Inventory Analysis

Inventory analysis included:

* Overstock detection
* Stockout risk analysis
* Inventory vs sales comparison
* Sell-through ratio calculation

The analysis revealed that inventory levels were consistently much higher than actual sales, indicating a clear overstocking issue.

---

## Forecasting Analysis

To evaluate forecasting performance, I compared forecasted demand with actual sales using:

* Forecast error analysis
* Demand bias analysis
* Forecast vs actual sales comparison

The results showed that demand forecasts consistently overestimated customer demand.

---

## Pricing & Promotion Analysis

I also studied the impact of:

* Product pricing
* Discounts
* Competitor pricing
* Promotions

The findings suggested that pricing and discount strategies had very little impact on sales performance in this dataset.

---

## External Factors Analysis

External factors such as weather conditions and seasonality were also analyzed.

These factors showed only minimal influence on overall sales trends.

---

# Key Insights

* Inventory levels were significantly higher than actual sales across all products.
* Demand forecasts consistently overestimated customer demand.
* Sell-through ratios remained around 50%, indicating inefficient inventory utilization.
* Pricing and discounts had minimal impact on customer demand.
* Sales remained relatively stable across products, categories, and regions.
* Promotions and external factors showed limited influence on sales performance.

---

# Final Conclusion

The analysis suggests that the main business issue is not low demand, but inefficient inventory planning caused by inaccurate forecasting.

The company appears to maintain excess inventory due to consistently overestimated demand forecasts, which leads to low inventory efficiency and unnecessary stock accumulation.

Improving forecasting accuracy and aligning inventory levels more closely with actual sales could help reduce costs and improve operational performance.

---

# Recommendations

* Improve demand forecasting methods
* Reduce excess inventory levels
* Optimize ordering decisions using actual sales trends
* Continuously monitor forecast accuracy and inventory efficiency
* Focus more on operational improvements rather than pricing strategies

---

# Project Outcome

This project helped me strengthen my SQL skills and improve my understanding of retail business analysis, inventory management, and supply chain operations.

It also gave me practical experience in turning raw business data into meaningful insights and recommendations.
