-- Zepto Data Analysis Project

/*---------DATABASE SETUP---------*/

create database zepto;

use zepto;

/*---------DATA EXPLORATION---------*/

/*How many rows are present in the dataset*/

select count(*) as total_records
from zepto;

/*How many unique products and catagories are present?*/

select
count(distinct `name`) as unique_products,
count(distinct category) as unique_category
from zepto;

/*What are the different product categories?*/

select distinct category
from zepto
order by category;

/*How are products distributed between in-stock and out-of-stock status?*/

select 
	case when outOfStock = 'TRUE' then 'Out of Stock' 
		 else 'In Stock' 
	end as stock_status, 
    count(*) as product_count 
from zepto 
group by stock_status;

/*Whick products name appears under multiple SKUs?*/

select `name`, count(*) as sku_count
from zepto
group by `name`
having count(*) > 1
order by sku_count desc;

/*what is the overall price and discount profile?*/

select
	round(min(mrp),2) as min_mrp,
    round(max(mrp),2) as max_mrp,
    round(avg(mrp),2) as avg_mrp,
    round(min(discountedSellingPrice),2) as min_selling_price,
    round(max(discountedSellingPrice),2) as max_selling_price,
    round(avg(discountedSellingPrice),2) as avg_selling_price,
    round(avg(discountPercent),2) as avg_discountpercent
from zepto;

/*What is the distribution of products weights?*/

select
	min(weightInGms) as min_wgt_g,
    max(weightInGms) as max_wgt_g,
    round(avg(weightInGms),2) as avg_wgt_g
from zepto;

/*Which categories cantains the largest number of products?*/

select category, count(*) as product_count
from zepto
group by category
order by product_count desc;

/*---------DATA QUALITY CHECK---------*/

/*Are there any NULL values ?*/

select 
	sum(category is null) as null_category,
    sum(`name` is null) as null_name,
    sum(mrp is null) as null_mrp,
    sum(discountPercent is null) as null_discountPercent,
    sum(availableQuantity is null) as null_availableQuantity,
    sum(discountedSellingPrice is null) as null_discountedSellingPrice,
    sum(weightInGms is null) as null_weightInGms,
    sum(outOfStock is null) as null_outOfStock,
    sum(quantity is null) as null_quantity
from zepto;

/*Are there any exact duplicates record?*/

select Category,`name`,mrp,discountPercent,availableQuantity,
discountedSellingPrice,weightInGms,outOfStock,quantity,
count(*) as duplicate_count
from zepto
group by Category,`name`,mrp,discountPercent,availableQuantity,
discountedSellingPrice,weightInGms,outOfStock,quantity
having count(*) > 1
order by duplicate_count;

/*Are there products zero or negative price or quantities?*/

select * 
from zepto
where mrp <= 0 or discountedSellingPrice <=0
	or availableQuantity < 0 or quantity < 0;
    
/*Are there product with invalid weights?*/

select * 
from zepto
where weightInGms <= 0;

/*Are there products with invalid discount percentage?*/

select * 
from zepto
where discountPercent < 0 or discountPercent > 100;

/*Are there product where selling price is greater than MRP*/

select * 
from zepto
where discountedSellingPrice > mrp;

/*Does the recorded discount match the calculated discount?*/

select `name`, mrp, discountedsellingprice, discountpercent,
    round(((mrp - discountedsellingprice) * 100.0) / nullif(mrp, 0), 2) as calculated_discount
from zepto
where abs(discountpercent - (((mrp - discountedsellingprice) * 100.0) / nullif(mrp, 0))) > 1;

/*Are there inconsistencies between stock status and available quantity?*/

select `name`, category, availableQuantity, outOfStock
from zepto
where (outOfStock = 'TRUE' and availableQuantity > 0) or
(outOfStock = FALSE and availableQuantity = 0);

/*----------DATA CLEANING---------*/

set sql_safe_updates = 0;

/*Remove products with zero MRP*/

delete from zepto
where mrp <= 0;

/*Remove products with zero selling price*/

delete from zepto
where discountedSellingPrice <= 0;

/*Remove products with invalid weights*/

delete from zepto
where weightInGms <= 0;

/*Remove products with negative inventory*/

delete from zepto
where availableQuantity < 0;

/*Remove products with negetive quantity*/

delete from zepto
where quantity < 0;

/*---------PRICE STANDARDIZATION---------*/

/*The dataset stores price values in paise,
convert paise into Indian rupees*/

update zepto
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

/*Verify price conversion*/

select `name`, mrp, discountedSellingPrice
from zepto;

/*---------POST-CLEANING VALIDATION---------*/

/*Check remaining invalid records*/

select * 
from zepto
where mrp <= 0 
or discountedSellingPrice <= 0
or weightInGms <=0
or availableQuantity < 0
or quantity < 0;

/*Recheck pricing logic after cleaning*/

select * 
from zepto
where discountedSellingPrice > mrp;

/*---------BUSINESS KPI OVERVIEW---------*/

/*What are the key business KPIs?*/

select count(*) as total_skus,
count(distinct `name`) as unique_products,
count(distinct category) as total_category,
round(avg(mrp),2) as average_mrp,
round(avg(discountedSellingPrice),2) as average_selling_price,
round(avg(discountPercent),2) as average_discount,
round(avg(mrp - discountedSellingPrice),2) as average_customer_savings,
sum(outOfstock = 'TRUE') as out_of_stock_products,
round(sum(case when outOfStock = 'TRUE' then 1 else 0 end) * 100.0 / count(*),2) as out_of_stock_rate
from zepto;

/*----------PRODUCT & ASSORTMENT ANALYSIS---------*/

/*which categories dominate the product assortment,
and what percentage of the total catalog does each category contribute*/

select category,
count(*) as total_products,
round(count(*) * 100.0 / (select count(*) from zepto),2) as assortment_percentage
from zepto
group by category
order by total_products desc;

/*Which catgeories combine a large product assortment with
relatively high average selling price?*/

select category, count(*) as total_products,
round(avg(discountedSellingprice),2) as avg_selling_price
from zepto
group by category
order by total_products desc, avg_selling_price desc;

/*Which category have the highest average of MRP and
 how does their average selling price compare*/
 
 select category, 
	round(avg(mrp),2) as avg_mrp,
    round(avg(discountedSellingPrice),2) as avg_selling_price,
    round(avg(mrp - discountedSellingPrice),2) as avg_customer_savings
from zepto
group by category
order by avg_mrp desc;

/*---------PRICING & DISCOUNT ANALYSIS---------*/

/*Which product have the highest dicount percentage?*/

select `name`, category, discountedSellingPrice, discountPercent
from zepto
order by discountPercent desc
limit 20;

/*Which products provide the highest
 customer savings in absolute ₹ terms?*/

select `name`, category, mrp, discountedSellingPrice, discountPercent,
	round(mrp - discountedSellingPrice,2) as customer_savings
from zepto
order by customer_savings desc;

/*Which categories offer the deepest average discounts?*/

select category, round(avg(discountPercent),2) as avg_discount
from zepto
group by category
order by avg_discount desc;

/*Which categories offer discounts above the overall platform average?*/

select category,
	round(avg(discountPercent),2) as category_average_discount,
    round((select avg(discountPercent) from zepto),2) as overall_avg_discount,
    round(avg(discountPercent) - (select avg(discountPercent) from zepto),2) as differene_from_overall
from zepto
group by category
having category_average_discount > overall_avg_discount
order by differene_from_overall desc;

/*Which high-MRP products receive relatively
 low discounts and could represent pricing opportunities?*/
 
 select `name`, category, discountedSellingPrice, discountPercent,
	round(mrp - discountedSellingPrice,2) as customer_savings
from zepto
where mrp > 500 and discountPercent < 10
order by mrp desc;

/*How does selling price change across different discount bands?*/

select case
			when discountPercent < 10 then "0-10%"
            when discountPercent < 20 then "10-20%"
            when discountPercent < 30 then "20-30%"
            when discountPercent < 40 then "30-40%"
            else "40%+"
		end as discount_band,
        count(*) as total_products,
        round(avg(mrp),2) as avg_mrp,
        round(avg(discountedSellingPrice),2) as avg_selling_price,
        round(avg(mrp - discountedSellingPrice),2) as avg_customer_savings
from zepto
group by discount_band
order by min(discountPercent);

/*Which categories generate the greatest total customer savings?*/

select category, round(sum(mrp - discountedSellingPrice),2) as total_customer_savings
from zepto
group by category
order by total_customer_savings desc;

/*---------VALUE-FOR-MONEY ANALYSIS---------*/

/*Which products provide the best value based on price per 100g?*/

select `name`, category, weightInGms, discountedSellingPrice,
	round(discountedSellingPrice / nullif(weightInGms,0)*100,2) as price_per_100gm
from zepto
where weightInGms > 0
order by price_per_100gm asc
limit 20;

/*Which categories offer the most competitive average price per 100g?*/

select category,
	round(avg(discountedSellingPrice / nullif(weightInGms,0)*100),2) as avg_price_per_100gm
from zepto
where weightInGms > 0
group by category
order by avg_price_per_100gm asc;

/*Which products combine high discounts with attractive price-per-100g value?*/

select `name`, category, weightInGms, mrp, discountedSellingPrice, discountPercent,
	round(discountedSellingPrice / nullif(weightInGms,0)*100,2) as price_per_100gm
from zepto
where discountPercent >= 20 and 
	  weightInGms > 0
order by price_per_100gm asc, discountPercent desc
limit 15;

/*---------INVENTORY & AVAILABILITY ANALYSIS---------*/

/*What is the overall out-of-stock rate?*/

select count(*) as total_products,
	sum(case when outOfStock = 'TRUE' then 1 else 0 end) as out_of_stock_products,
    round(sum( case when outOfStock = 'TRUE' then 1 else 0 end)*100/count(*),2) as out_of_stock_rate
from zepto;

/*Which categories have the highest out-of-stock rates?*/

select category,count(*) as total_products,
	sum(case when outOfStock = 'TRUE' then 1 else 0 end) as out_of_stock_products,
    round(sum(case when outOfStock = 'TRUE' then 1 else 0 end)*100/count(*),2) as out_of_stock_rate
from zepto
group by category
having count(*) >= 10
order by out_of_stock_rate desc;

/*Which high-value products are currently out of stock?*/

select `name`,category,mrp,discountedSellingPrice,discountPercent,
	round(mrp - discountedSellingPrice,2) as customer_savings
from zepto
where outOfStock = 'TRUE'
order by discountedSellingPrice desc
limit 15;

/*Which products have high inventory but relatively low discounts?*/

select `name`,category,availableQuantity,mrp,discountedSellingPrice,discountPercent
from zepto
where availableQuantity > 100 and discountPercent <10
order by availableQuantity desc;

/*---------INVENTORY VALUE ANALYSIS---------*/

/*Which categories have the highest inventory value?*/

select category, 
	round(sum(discountedSellingPrice * availableQuantity),2) as inventory_value
from zepto
group by category
order by inventory_value desc;

/*Which products have the highest inventory value?*/

select `name`, category, availableQuantity, discountedsellingPrice,
	round(discountedSellingPrice * availableQuantity) as inventory_value
from zepto
order by inventory_value desc
limit 15;

/* Which products have high stock and high prices?*/

select `name`, category, availableQuantity, discountedsellingPrice,
	round(discountedSellingPrice * availableQuantity) as inventory_value
from zepto
where availableQuantity > 100 and
	discountedSellingPrice > 500
order by inventory_value desc;

/*---------INVENTORY WEIGHT ANALYSIS---------*/

/*What is the total inventory weight for each category?*/

select category, 
	sum(weightInGms * availableQuantity) as total_inventory_weight_gms
from zepto
group by category
order by total_inventory_weight_gms desc;

/*---------WEIGHT SEGMENTATION---------*/

/*How can products be segmented based on their weight?*/

select `name`, category, weightIngms,
	case
		when weightIngms < 1000 then "low"
        when weightIngms < 5000 then "medium"
        else "bulk"
	end as weight_category
from zepto;

/*What is the distribution of weight segments across categories?*/

select category,
	sum(case 
			when weightInGms < 1000 then 1 
            else 0 
		end) as low_weight_products,
	sum(case 
			when weightInGms >= 1000 and weightInGms < 5000 then 1 
            else 0 
		end) as medium_weight_products,
	sum(case 
			when weightInGms >= 5000 then 1 
            else 0 
		end) as bulk_products
from zepto
group by category
order by category;

/*---------DISCOUNT VS INVENTORY ANALYSIS---------*/

/*Is discount intensity associated with out-of-stock rates?*/

select 
	case
		when discountPercent < 10 then "0-10%"
        when discountPercent < 20 then "10-20%"
        when discountPercent < 30 then "20-30%"
        when discountPercent < 40 then "30-40%"
        else "40%+"
	end as discount_band,
    count(*) as total_products,
    sum(outOfStock = 'TRUE') as out_of_stock_products,
    round(sum(outOfStock = 'TRUE')*100/count(*),2) as out_of_stock_rate
from zepto
group by discount_band
order by min(discountPercent);

/*---------WINDOW FUNCTION ANALYSIS---------*/

/*Rank products within each category based on discount percentage.*/

select category, `name`, discountPercent,
	dense_rank() over(partition by category order by discountPercent desc) as discount_rank
from zepto;

/*What are the top 3 most-discounted products within each category?*/

with ranked_products as (
select category, `name`, mrp, discountedSellingPrice, discountPercent,
	dense_rank() over(partition by category order by discountPercent desc) as discount_rank
    from zepto
)
select category, `name`, mrp, discountedSellingPrice, discountPercent, discount_rank
from ranked_products
where discount_rank <=3
order by category, discount_rank;

/*---------ADVANCED CATEGORY ANALYSIS---------*/

/*Which categories have BOTH above-average discounts and above-average out-of-stock rates?*/

with category_metrics as (
select category,
	avg(discountPercent) as avg_discount,
    sum(outOfStock = 'TRUE')*100/count(*) as out_of_stock_rate
from zepto
group by category
)
select category,
	round(avg_discount,2) as avg_discount,
    round(out_of_stock_rate,2) as out_of_stock_rate
from category_metrics
where avg_discount > (
		select avg(discountpercent) 
        from zepto
		)
        and out_of_stock_rate > (
        select sum(outOfStock = 'TRUE')*100/count(*)
        from zepto
        )
order by avg_discount desc;

/*---------CATEGORY BENCHMARKING---------*/

/*How does each category's discount performance
  compare with the overall platform average?*/
  
select category,
	round(avg(discountPercent),2) as category_avg_discount,
    round((select avg(discountPercent)
		   from zepto),2) as overall_avg_discount,
	round(avg(discountPercent) - (select avg(discountPercent) 
								  from zepto),2) as difference_from_overall
from zepto
group by category
order by difference_from_overall desc;

/*---------PRODUCT SEGMENTATION---------*/

/*Segment products based on discount intensity.*/

select `name`, category, mrp, discountedSellingPrice, discountPercent,
	case
		when discountPercent >= 40 then "highly discounted"
        when discountPercent >= 20 then "moderately discounted"
        when discountPercent >= 10 then "low discounted"
        else "minimal / no discount"
	end as discount_segment
from zepto;

/*Segment products based on inventory risk.*/

select `name`, category, availableQuantity, discountPercent, outOfStock,
	case
		when outOfStock = 'TRUE' then "out of stock"
        when availableQuantity <= 10 then "critical stock"
        when availableQuantity <= 50 then "low stock"
        when availableQuantity <= 100 then "healthy stock"
        else "high stock"
	end as inventory_status
from zepto;

/*---------STRATEGIC PRODUCT ANALYSIS---------*/

/*Which products have high discounts and high absolute customer savings?*/

select `name`, category, mrp, discountedSellingPrice, discountPercent,
	round(mrp - discountedSellingPrice,2) as customer_savings
from zepto
where discountPercent >= 30
order by customer_savings desc;

/*Which products have low stock but high customer savings?*/

select `name`, category, availableQuantity, mrp, discountedSellingPrice, discountPercent,
	round(mrp - discountedSellingPrice,2) as customer_savings
from zepto
where availableQuantity <= 10
	and discountPercent >= 20
order by customer_savings desc;

/*Which products have high inventory value and could represent inventory exposure?*/

select `name`, category, availableQuantity, discountedsellingPrice,
	round(availableQuantity * discountedSellingPrice,2) as inventory_value
from zepto
where availableQuantity > 100
order by inventory_value desc
limit 20;

/*---------CATEGORY STRATEGIC PRIORITY---------*/

/*Which categories combine:
     - High inventory value
     - High discounting
     - High out-of-stock rate
These categories may require greater pricing/inventory attention.*/

with category_analysis as (
select category, count(*) as total_products,
	avg(discountPercent) as avg_discount,
    sum(outOfStock = 'TRUE')*100/count(*) as out_of_stock_rate,
    sum(discountedSellingPrice * availableQuantity) as inventory_value
from zepto
group by category
),
benchmarks as (
select avg(avg_discount) as avg_category_discount,
	avg(out_of_stock_rate) as avg_category_oos,
    avg(inventory_value) as avg_category_inventory
from category_analysis
)
select ca.category, ca.total_products,
	round(ca.avg_discount,2) as avg_discount,
    round(ca.out_of_stock_rate,2) as out_of_stock_rate,
    round(ca.inventory_value,2) as inventory_value,
    case
		when ca.avg_discount > b.avg_category_discount
			and ca.out_of_stock_rate > b.avg_category_oos
            and ca.inventory_value > b.avg_category_inventory then "high priority"
		when ca.avg_discount > b.avg_category_discount 
			and ca.out_of_stock_rate > b.avg_category_oos then "promotion & inventory risk"
		when ca.inventory_value > b.avg_category_inventory then "high inventory exposure"
        else "normal"
	end as business_priority
from category_analysis ca cross join benchmarks b 
order by
	case 
		when ca.avg_discount > b.avg_category_discount
			and ca.out_of_stock_rate > b.avg_category_oos
			and ca.inventory_value > b.avg_category_inventory then 1
		when ca.avg_discount > b.avg_category_discount
			and ca.out_of_stock_rate > b.avg_category_oos then 2
		when ca.inventory_value > b.avg_category_inventory then 3
        else 4
	end,
ca.inventory_value desc;

/*---------FINAL DATASET SUMMARY---------*/

/*Final cleaned dataset summary.*/

select count(*) as final_record_count,
	count(distinct category) as total_categories,
    round(avg(mrp),2) as average_mrp,
    round(avg(discountedSellingPrice),2) as avg_selling_price,
    round(avg(discountPercent),2) as avg_discount,
    round(avg(mrp - discountedSellingPrice),2) as average_customer_savings,
    round(sum(outOfStock = 'TRUE')*100/count(*),2) as out_of_stock_rate
from zepto;
