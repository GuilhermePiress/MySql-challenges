-- Desafios de SQL 2
-- Exercício 1
use brazilian_ecommerce;

select count(oi.order_item_id) as quantity,p.product_category_name,c.customer_state
from order_items oi
inner join products p on p.product_id=oi.product_id
inner join orders o on o.order_id=oi.order_id
inner join customers c on c.customer_id=o.customer_id
group by p.product_category_name,c.customer_state
having quantity>1000
order by c.customer_state;

-- Exercício 2

select c.customer_unique_id,sum(p.payment_value) as total_value,count(c.customer_id) as quantity,(sum(p.payment_value)/count(c.customer_id)) as mean
from customers c
inner join orders o on o.customer_id=c.customer_id
inner join order_payments p on o.order_id=p.order_id
group by c.customer_unique_id
order by mean desc
Limit 5;

-- Exercício 3

select s.seller_id,p.product_category_name,round(sum(oi.price),2) as total_sells
from sellers s
inner join order_items oi on s.seller_id=oi.seller_id
inner join products p on p.product_id=oi.product_id
group by s.seller_id,p.product_category_name
having total_sells>1000
order by total_sells desc;


