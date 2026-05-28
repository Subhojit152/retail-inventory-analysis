Use retail_inventory;
Select * from retail_store_inventory; 

/* The goal of this project is to study retail inventory and sales data to improve inventory management, 
reduce stock shortages and excess stock, and identify key factors that affect sales performance. */

/* Project Objectives
To analyze sales performance across products, categories, and regions
To identify stockout risks by comparing inventory levels with demand forecasts
To detect overstock situations where inventory exceeds demand
To evaluate demand forecast accuracy by comparing predicted and actual sales
To analyze the impact of pricing and discounts on sales
To study external factors such as weather, promotions, and seasonality on demand
To assess supply chain efficiency using ordering and demand data */
To assess supply chain efficiency using ordering and demand data */

-- Dataset Description

/* This dataset contains retail sales, inventory, and supply chain-related information across multiple stores, products, and regions.
 It includes key variables such as sales quantity, inventory levels, demand forecasts, pricing, and external factors like weather, promotions, and seasonality.

The dataset is designed to help analyze sales performance, inventory management, demand forecasting accuracy,
 and the impact of external and competitive factors on business operations. */
 
 /*Column Description 
Column Name	Description
Date - 	Transaction date
Store ID - Unique identifier for each store
Product ID - Unique identifier for each product
Category - Product category
Region - Store location/region
Inventory Level - Available stock
Units Sold- Quantity sold
Units Ordered- Quantity ordered from supplier
Demand Forecast	- Predicted demand
Price - Selling price
Discount- Discount applied
Weather Condition	- Weather during sales
Holiday/Promotion- Promotion or event indicator
Competitor Pricing- Competitor’s price
Seasonality	Seasonal - category  */
 
 -- Understanding Data. 
 
 -- Preview data. 
 Select * from retail_data
 limit 10;
 
 -- total rows. 
 Select count(*) as total_rows from retail_data;
 -- There are total 73,100 total rows avialable in the dataset. 
 
 -- unique products & stores
SELECT 
    COUNT(DISTINCT product_id) AS total_products,
    COUNT(DISTINCT store_id) AS total_stores
FROM retail_data;
/* Insight:
 The current product assortment is limited to 20 items across 5 stores, 
indicating a focused inventory strategy. Expanding the product range could help increase sales opportunities and attract a wider customer base.*/

-- Checking missing values. 
SELECT 
    COUNT(*) - COUNT(date) AS missing_date,
    COUNT(*) - COUNT(store_id) AS missing_store,
    COUNT(*) - COUNT(product_id) AS missing_product,
    COUNT(*) - COUNT(inventory_level) AS missing_inventory,
    COUNT(*) - COUNT(units_sold) AS missing_sales,
    COUNT(*) - COUNT(discount) AS missing_discount
FROM retail_data;
/* Insight:
The dataset shows no missing values across key fields, indicating high data quality and reliability for analysis. 
This ensures that insights derived from the data can be considered accurate without the need for additional data cleaning. */

-- Checking duplicates. 
SELECT 
    date, store_id, product_id, COUNT(*) AS count
FROM retail_data
GROUP BY date, store_id, product_id
HAVING COUNT(*) > 1;
/* Insight:
No duplicate records found at the (date, store, product) level, indicating good data consistency and reliability for analysis. */

-- Data Validation (negative values check)
SELECT *
FROM retail_data
WHERE units_sold < 0 
   OR inventory_level < 0 
   OR price < 0;
/* Insight:
No negative values detected in key numerical fields (sales, inventory, pricing), indicating consistent and valid transactional data. */
 
-- Key Business Questions. 

-- Which products generate the highest and lowest sales?
Select 
	Product_id, 
	Sum(Units_Sold) as total_sales,
	rank() over (order by Sum(Units_Sold) desc) as Product_rank
From retail_data
Group by Product_id;
/* Insight: Sales are evenly distributed across products, with minimal variation between top and bottom performers. This indicates a lack of strong product differentiation,
 suggesting an opportunity to identify high-potential products and focus on targeted marketing or assortment optimization.*/

-- Which categories and regions contribute the most to total sales?
SELECT 
    category, 
    SUM(units_sold) AS total_sales,
     round(SUM(units_sold) * 100.0 
        / SUM(SUM(units_sold)) OVER (),2) AS contribution_pct
FROM retail_data
GROUP BY category
ORDER BY total_sales DESC;

/* Insight: Category contributions are nearly equal, indicating a diversified revenue base. However, the absence of high-performing categories suggests limited growth drivers,
 highlighting an opportunity to strengthen specific categories through promotions or product expansion */

Select 
    Region, 
    Sum(Units_Sold) as Total_Sales,
    round(sum(units_Sold) * 100.0 / Sum(Sum(units_sold)) over (),2) as contribution_pct
From retail_data
Group by  Region
Order by Total_Sales desc;

/* Insights : Sales distribution across regions is highly uniform, indicating consistent market penetration. 
However, the lack of regional variation suggests missed opportunities for localized strategies or region-specific demand optimization */

-- How does sales vary over time?
WITH monthly_sales AS (
    SELECT 
        DATE_FORMAT(date, '%Y-%m') AS month_date,
        SUM(units_sold) AS total_sales
    FROM retail_data
    GROUP BY month_date
)
SELECT 
    month_date,
    total_sales,
    LAG(total_sales) OVER (ORDER BY month_date) AS prev_month_sales,
    (total_sales - LAG(total_sales) OVER (ORDER BY month_date)) * 100.0 
        / LAG(total_sales) OVER (ORDER BY month_date) AS mom_growth_pct
FROM monthly_sales;

/* Insights:“Sales remain stable across months with recurring fluctuations,
 indicating demand is influenced by short-term factors such as seasonality or promotions rather than sustained growth.
 The repeating pattern across years confirms predictable seasonal behavior, which can be leveraged for better inventory planning */ 

-- Yearly Sales trend.
Select 
	Year(Date) as Year,
    Sum(Units_sold) as Total_Sales 
From retail_data
Group by Year;

/* Insights: Sales remain stable between 2022 and 2023, indicating a mature business with consistent demand but limited growth.
 This highlights the need for strategic initiatives such as product expansion or pricing optimization to drive future growth*/ 

-- Daily Sales Trends.
SELECT 
    date,
    SUM(units_sold) AS daily_sales
FROM retail_data
GROUP BY date
ORDER BY date;

-- Stockout Risk Analysis
SELECT 
    product_id,
    SUM(inventory_level) AS total_inventory,
    SUM(demand_forecast) AS total_demand
FROM retail_data
GROUP BY product_id
HAVING total_inventory < total_demand;
-- Insight: No products were identified where total inventory is less than demand forecast, indicating that there is no immediate stockout risk across the product portfolio.

-- Overstock Analysis
SELECT 
    product_id,
    SUM(inventory_level) AS total_inventory,
    SUM(units_sold) AS total_sales
FROM retail_data
GROUP BY product_id
HAVING total_inventory > total_sales;

/* Insights: Across all products, inventory levels are consistently much higher than sales.
 In most cases, inventory is close to 1 million units, while sales are around 490K–510K units.
This means that, on average, inventory is roughly twice the level of actual sales, indicating a clear overstock situation across the entire product range. */

-- Inventory Efficiency (Sell-Through Ratio)
SELECT 
    product_id,
    (SUM(units_sold) * 1.0 / SUM(inventory_level) * 100) AS sell_through_ratio
FROM retail_data
GROUP BY product_id
ORDER BY sell_through_ratio ASC;

/* Insights: The sell-through ratio for all products lies in a very narrow range of 49% to 50%, indicating a highly consistent pattern across the product portfolio.
This means that, on average, only about half of the available inventory is being sold, while the remaining stock remains unsold. */

-- Inventory Distribution by Category
SELECT 
    category,
    SUM(inventory_level) AS total_inventory
FROM retail_data
GROUP BY category
ORDER BY total_inventory DESC;

-- Insights: Inventory is almost equally distributed across all categories, indicating a uniform but potentially inefficient stocking strategy.

-- Inventory vs Sales Comparison
SELECT 
    product_id,
    SUM(inventory_level) AS inventory,
    SUM(units_sold) AS sales
FROM retail_data
GROUP BY product_id;

-- Insights: All products show a similar pattern of inventory being nearly double the sales, indicating consistent but inefficient inventory management.

/* Summary Insights: 
Overall, the inventory system appears to prioritize availability over efficiency, resulting in consistent overstock across all products.
 The lack of variation suggests a uniform but suboptimal inventory strategy rather than product-level issues. */
 
 -- How accurate is the demand forecast?
 SELECT 
    product_id,
    round(AVG(ABS(demand_forecast - units_sold)),2) AS forecast_error
FROM retail_data
GROUP BY product_id;

/* Forecast error remains consistently high across products, indicating that predicted demand does not closely match actual sales.
 This suggests inefficiencies in demand forecasting accuracy. */
 
 -- Is demand overestimated or underestimated?
 SELECT 
    product_id,
    round(SUM(demand_forecast),2) AS forecasted_demand,
    SUM(units_sold) AS actual_sales
FROM retail_data
GROUP BY product_id;

/* Demand forecasts are consistently higher than actual sales, indicating systematic overestimation of demand.
 This overestimation is a key driver of excess inventory. */
 
 -- Are we ordering more than needed?
 SELECT 
    product_id,
    round(SUM(demand_forecast),0) AS demand,
    SUM(units_ordered) AS supply
FROM retail_data
GROUP BY product_id;
/* Insights: 
The issue is not insufficient supply, but inefficient utilization of existing inventory.
 Despite ordering less than forecasted demand, excess inventory continues to accumulate due to overestimated demand and slow inventory movement. */
 
 -- Is forecast driving overstock?
 SELECT 
    product_id,
    AVG(demand_forecast - units_sold) AS avg_bias
FROM retail_data
GROUP BY product_id;
/* The demand forecast shows a consistently positive bias across all products,indicating that predicted demand is systematically higher than actual sales.
 This confirms that the forecasting model is not random but consistently overestimates demand,which directly contributes to excess inventory and low sell-through ratios. */
 
 -- Does price affect demand?
 SELECT 
    price,
    AVG(units_sold) AS avg_sales
FROM retail_data
GROUP BY price
ORDER BY 2;

/* sales fluctuate noticeably across different price points. As prices change, sales volumes also vary, indicating that pricing does have an impact on demand.
However, the relationship is not perfectly linear — some price levels show higher sales, while others do not follow a consistent pattern. */ 

-- Discount impact on sales.
SELECT 
    discount,
    AVG(units_sold) AS avg_sales
FROM retail_data
GROUP BY discount
ORDER BY discount;

/* sales remain almost unchanged across different discount levels.
From 0% to 20% discount, average sales only increase slightly from 135.7 to 136.7 units, which is a very small difference.
This shows that even when discounts are increased, sales do not improve significantly. */

-- Are we price-sensitive or not?
SELECT 
(
    AVG(price * units_sold) 
    - AVG(price) * AVG(units_sold)
) 
/
(
    STDDEV(price) * STDDEV(units_sold)
) AS price_sales_correlation
FROM retail_data;

/* Sales do not show any meaningful change with variations in price.
 The correlation between price and sales is extremely close to zero, indicating that pricing has little to no influence on customer demand. */ 
 
 -- Is competitor pricing impacting us?
 SELECT 
    product_id,
    Round(AVG(price),2) AS our_price,
    Round(AVG(competitor_pricing),2) AS competitor_price,
    Round(AVG(units_sold),2) AS avg_sales
FROM retail_data
GROUP BY product_id;

SELECT 
(
    AVG(competitor_pricing * units_sold) 
    - AVG(competitor_pricing) * AVG(units_sold)
) 
/
(
    STDDEV(competitor_pricing) * STDDEV(units_sold)
) AS competitor_price_sales_corr
FROM retail_data;

/* Sales do not show any significant change based on competitor pricing.
 The correlation between competitor price and sales is extremely close to zero, indicating that competitor pricing has little to no influence on demand. */ 


/* Summarry Insight: Demand in this dataset is not driven by pricing strategies (price, discount, or competitor pricing), but rather by other external or structural factors.
 The primary issue lies in demand overestimation, which leads to overstocking and inefficient inventory management. */
 
 -- Weather impact on sales.
 SELECT 
    weathercondition,
    AVG(units_sold) AS avg_sales
FROM retail_data
GROUP BY weathercondition;
-- Insights: Weather has minimal impact on sales, with only slight increases observed during sunny conditions. 

-- Do Promotion increase demand. 
SELECT 
    holiday_promotion,
    AVG(units_sold) AS avg_sales
FROM retail_data
GROUP BY holiday_promotion;
-- Promotions show no measurable impact on demand, indicating ineffective marketing strategies

-- Seasonality impact on sales. 
SELECT 
    seasonality,
    AVG(units_sold) AS avg_sales
FROM retail_data
GROUP BY seasonality;
-- Seasonality has minimal impact on sales, with only slight increases observed during Autumn

-- FINAL BUSINESS SUMMARY
/* The analysis reveals that the business operates in a stable demand environment where sales are evenly distributed across products, categories, and regions.
 External factors, pricing, and promotions have limited influence on demand.
The primary issue lies in internal planning inefficiencies—specifically, the consistent overestimation of demand forecasts.
This leads to excessive inventory, low sell-through ratios, and inefficient capital utilization.
Addressing forecasting accuracy and aligning inventory planning with actual demand presents the biggest opportunity for operational improvement */ 

-- RECOMENDATION 
/* Improve demand forecasting accuracy to eliminate consistent overestimation
Align inventory levels with actual sales to reduce excess stock
Optimize ordering strategy based on real demand, not inflated forecasts
Shift focus from pricing strategies to operational planning improvements
Implement continuous monitoring of key metrics like forecast error, sell-through, and inventory-to-sales ratio */



