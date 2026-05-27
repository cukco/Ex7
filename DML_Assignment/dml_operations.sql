update products
set price=price*1.1 where category='Electronics';

update orders
set status='CONFIRMED' where status='PENDING';

delete from customers
where customer_id not in (select customer_id from orders);

