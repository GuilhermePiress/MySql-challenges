use brazilian_ecommerce;
-- Desafios de SQL 3

-- Exercício 1
create table tabela_analitica
select distinct c.customer_id,o.order_id,c.customer_state,s.seller_state,
DATEDIFF(o.order_delivered_carrier_date,o.order_approved_at) as days_to_post,
case 
	when o.order_estimated_delivery_date>=o.order_delivered_customer_date
    then 'Ok'
    else 'Late'
end as 'delivery_time'
from customers c
inner join orders o on o.customer_id=c.customer_id
inner join order_items oi on o.order_id=oi.order_id
inner join sellers s on oi.seller_id=s.seller_id
where c.customer_state!=s.seller_state;



-- Exercício 2
with customers_orders
as (select customer_unique_id from customers c
inner join orders o on o.customer_id=c.customer_id
where o.order_status='delivered'
group by customer_unique_id
having count(customer_unique_id)>1)

select distinct co.customer_unique_id,o.order_id,o.order_approved_at,
p.payment_value,sum(p.payment_value) 
OVER(partition by co.customer_unique_id ORDER BY co.customer_unique_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS total_sum
from customers_orders co
inner join customers c on c.customer_unique_id=co.customer_unique_id
inner join orders o on o.customer_id=c.customer_id
inner join order_payments p on p.order_id=o.order_id
group by co.customer_unique_id,o.order_id;


-- Exercício 3
with tabela_aux
as(
select p.product_category_name,round(sum(oi.order_item_id*oi.price),2) as sells_per_category
from tabela_analitica ta
inner join order_items oi on ta.order_id=oi.order_id
inner join products p on p.product_id=oi.product_id
where p.product_category_name is not null
group by p.product_category_name
)
select ta.product_category_name,ta.sells_per_category,sum(ta.sells_per_category) 
OVER(ORDER BY ta.sells_per_category desc) AS total_sum
from tabela_aux ta;


