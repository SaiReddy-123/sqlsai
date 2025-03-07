/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Determine the first and last order date and the total duration in months
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months
FROM gold.fact_sales;

-- WhoHasTheOldestAge
with cte as
(
select first_name,last_name,MIN(birthdate) minbirth,MAX(birthdate) maxbirth,DATEDIFF("YEAR",MIN(birthdate),getdate()) age,
dense_rank() over (order by DATEDIFF("YEAR",MIN(birthdate),getdate())) rn from [gold.dim_customers]
group by first_name,last_name 
),
max_rank_cte as
(
select MAX(rn) rnk from cte
)
select * from cte where rn=(select rnk from max_rank_cte)
