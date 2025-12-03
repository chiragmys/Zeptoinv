drop table if exists zepto;

create table zepto
(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp numeric (8,2),
discountPercent numeric(5,2),
availableQuantity integer,
discountedSellingPrice numeric(8,2),
weightInGms Integer,
outOfStock Boolean,
quantity integer
);

--data exploration

--count of rows
Select count(*) from zepto;

--sample data
Select * from zepto
Limit 10;

--null values
Select * from zepto
where name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity is null;


---Different product categories
SELECT DISTINCT category
from zepto
ORDER BY category;

--products in stock vs out of stock
Select outOfStock, count(sku_id)
From zepto
Group By outOfStock;

--product names with multiple names
Select name,count(sku_id) as "Number of SKUs"
from zepto
group by name
having count(sku_id)>1
order by count(sku_id) desc;

--data cleaning

--price is zero
select * from zepto
where mrp=0
or
discountedSellingPrice=0;

--Deleting Category where mrp=0 i.e Home and cleaning category
delete from zepto
where mrp=0;

--convert paisa to rupee
update zepto
set mrp=mrp/100.0,
discountedSellingPrice=discountedSellingPrice/100.0;

Select mrp,discountedSellingPrice from zepto;

--Q1. Find the top 10 best value products based on the discounted percentage.
Select distinct name,mrp, discountPercent
from zepto
order by discountPercent DESC
limit 10;

--Q2. What are the products with high mrp but Out of syock
select distinct name,mrp
from zepto where outOfStock=TRUE and mrp>300
Order by mrp desc;

--Q3 Calculate estimated revenue for each category
Select category,
sum(discountedSellingPrice*availableQuantity) As total_revenue
from zepto
group by category
order by total_revenue;

--Q4. Find all products whose mrp is greater than 500 and discount less than 10%.
Select distinct name,mrp,discountPercent
from zepto
where mrp>500 and discountPercent<10
order by mrp desc;

--Q5. Identy the top 5 categories offering the highest discount percentage.
Select category, round(avg(discountPercent),2) As avg_discount
from zepto
group by category
order by avg_discount desc
limit 5;

--Q6. Find the price per gram for products above 100g and sort by best value.
Select Distinct name, weightInGms,discountedSellingPrice,
round(discountedSellingPrice/weightInGms,2) AS price_per_gram
from zepto
where weightInGms>=100
order by price_per_gram;

--Q7. Group the products into categories like low,medium,bulk.
Select distinct name, weightInGms,
Case when weightInGms<1000 then 'Low'
when weightInGms<5000 then 'medium'
else 'Bulk'
End as weight_category
from zepto;

--Q8. What is the total Inventory weight per category.
select category,
sum(weightInGms*availableQuantity) As total_weight
from zepto
group by category 
order by total_weight;