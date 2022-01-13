-- Desafio SQl 4

-- Exercício 1
create view Seller_Stats as
select oi.seller_id,
sum(oi.order_item_id) as quantity_items,
concat(floor(avg(TIMESTAMPDIFF(hour,o.order_approved_at,o.order_delivered_carrier_date))/24),' D',' ',
(round(avg(TIMESTAMPDIFF(hour,o.order_approved_at,o.order_delivered_carrier_date))%24)),' h') as time_to_post,
count(o.order_id) as quantity_orders
from order_items oi 
inner join orders o on o.order_id=oi.order_id
where o.order_status='delivered'
group by oi.seller_id
order by oi.seller_id;
-- Exercício 2

with customers_items(customers_promotion,quantity) as( 
select c.customer_unique_id,count(o.order_id) as quantity
from customers c
inner join orders o on c.customer_id=o.customer_id
where o.order_status='delivered'
group by c.customer_unique_id
having quantity>1
order by c.customer_unique_id),
promotion as(
select ci.customers_promotion,o.order_id,o.order_approved_at,p.payment_value,
lag(payment_value,1) over(partition by ci.customers_promotion order by o.order_approved_at) as prev_payment
from customers_items ci
inner join customers c on c.customer_unique_id=ci.customers_promotion
inner join orders o on c.customer_id=o.customer_id
inner join order_payments p on o.order_id=p.order_id
order by ci.customers_promotion,o.order_approved_at)
select p.customers_promotion,
p.order_id,
p.order_approved_at as last_buy,
p.payment_value,
p.prev_payment,
case
when p.payment_value<=prev_payment then round(0.1*prev_payment,2)
else '0 discount'
end as discount
from promotion p
inner join (select max(order_approved_at) as max_order from promotion group by customers_promotion) max
on max.max_order=p.order_approved_at
where p.prev_payment is not null
group by p.customers_promotion
order by p.customers_promotion;







