select city, count(customer_id) from customers
group by city;

select *from products
where product_id not in (select product_id from order_details);