-- Part 1
select product_name as "Tên SP", price as "Đơn giá", price*1.1 as "Giá VAT" from products;

select city, count(customer_id) from customers
group by city
order by count(customer_id) desc;

select max(price), min(price), avg(price) from products;

select count(*) filter (where status='Completed') as Completed,
    count(*) filter (where status='Pending') as Pending,
    count(*) filter (where status='Cancelled') as Cancelled,
    count(*) filter (where status='Processing') as Processing from orders;

--Part 2
select o.order_id,c.customer_id,c.customer_name,total_amount from orders o
inner join customers c on o.customer_id = c.customer_id
order by order_date desc
limit 10;

select category_name,count(product_id) from categories
left join products on categories.category_id = products.category_id
group by category_name;

select orders.customer_id,customer_name, count(orders.customer_id) from orders
inner join customers on orders.customer_id = customers.customer_id
where total_amount>5000000
group by orders.customer_id, customer_name
having count(orders.customer_id)>2;

select orders.customer_id, customers.customer_name from orders
inner join customers on orders.customer_id = customers.customer_id
where total_amount = ( select max(total_amount) from orders);

--Part3
select *from products
where price > (select avg(price) from products);

select *from customers
where not exists(
    select 1
    from orders
    where orders.customer_id=customers.customer_id
);

select p1.product_name, categories.category_name from products p1
inner join categories on p1.category_id = categories.category_id
where p1.price >(
    select avg(p2.price) from products p2
    where p1.category_id=p2.category_id
);

select *from customers
inner join orders on customers.customer_id = orders.customer_id
where total_amount = (select max(orders.total_amount) from orders);

--Part4
select email from customers
union
select email from suppliers;

select orders.customer_id from orders
inner join order_items on orders.order_id = order_items.order_id
inner join products on order_items.product_id = products.product_id
inner join categories on products.category_id = categories.category_id
where category_name='Electronics'
group by orders.customer_id
intersect
select orders.customer_id from orders
inner join order_items on orders.order_id = order_items.order_id
inner join products on order_items.product_id = products.product_id
inner join categories on products.category_id = categories.category_id
where category_name='Books'
group by orders.customer_id;

--Part5
update orders
set total_amount =(
    select sum(quantity*unit_price) from order_items
    where order_items.order_id=orders.order_id
    group by order_items.order_id
);

select city from customers
inner join orders on customers.customer_id = orders.customer_id
where extract(year from order_date)=2026
group by city
having sum(orders.total_amount) = (
    select sum(orders.total_amount) from customers
    inner join orders on customers.customer_id = orders.customer_id
    where extract(year from order_date)=2026
    group by city
    order by sum(orders.total_amount)
    limit 1
);





