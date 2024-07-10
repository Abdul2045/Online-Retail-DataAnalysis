create database Retail;
use Retail;
drop table online_retail;
select count(*) from onlne_retail;
select * from store;

#Total Sales 
select round(sum(Revenue),2) as 'Total Sales' from store;

#Total Sales Countrywise 
select country,round(Sum(Revenue),2) as Revenue from store
group by Country 
order by Revenue desc ;

#Monthly Sales 
SELECT date_format(InvoiceDate,'%Y-%m') AS month, round(SUM(Quantity * UnitPrice),2) AS total_sales
FROM store
GROUP BY date_format(InvoiceDate,'%Y-%m')
ORDER BY month;	

#Average Order Value
select round(avg(Total),2) as 'Avg_order_value' from (
select InvoiceNo , round(sum(Revenue),2) as  'Total' from store 
group by InvoiceNo) as query;


#Top 10 Products
select Description,round(sum(Revenue),2) as Total from store
group by Description 
order by Total desc limit 10;

#Average Product value
select avg(Total)  as 'Avg_Product_Value'from  
(select Description,round(sum(Revenue),2) as Total from store
group by Description ) as query;

#Top 5 products in each country 
with country_prod as (
select country , Description , round(sum(Revenue),2) as Total
from  store 
group by country, Description 
),

ranked as (
select Country, Description, Total, row_number() over(partition by country order by Total desc )  as Ranking
from Country_prod 
)

select * from ranked 
where Ranking <=5 
order by country, Ranking;

#Monthly sales Grow 
with monthly_sales as (
select date_format(InvoiceDate,'%Y-%m') AS month, round(sum(Revenue),2)  as Total from store 
group by date_format(InvoiceDate,'%Y-%m')
),

monthly_growth as (
select *,lag(Total) over(order by month asc) prev_month, round(((Total - lag(Total) over(order by month asc))/ lag(Total) over(order by month asc)) * 100,2)  as growth from monthly_sales
)
select * from monthly_growth;
