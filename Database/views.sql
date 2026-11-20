use retail_sales;

-- V1. Create a view to display customer-wise order summary
-- (customer_id, customer_name, total_orders, total_spending).
create view customer_summary as
	select c.customer_id,c.customer_name,
			concat(c.street,',',l.city,',',l.state,',',l.pincode) as address,
			count(distinct o.order_id) as total_orders,
            round(sum(order_total),2) as total_spending		
	from customer c join orders o
    on c.customer_id=o.customer_id
	join location l
    on l.location_id=c.location_id
    join(
		select  o.order_id,
        o.customer_id,
        SUM( p.price * (1 + p.gst_rate / 100) * i.quantity)
        + o.packaging_cost
        + COALESCE(s.shippment_cost, 0) AS order_total
		from orders o
		join order_items i
		on o.order_id=i.order_id
		join product p
		on p.product_id=i.product_id
		left join shippment s
		on s.order_id=i.order_id
        group by o.order_id,s.shippment_id,o.packaging_cost,s.shippment_cost) as order_total
	on order_total.order_id = o.order_id
    group by c.customer_id,c.customer_name;
select * from customer_summary;
drop view customer_summary;

-- V2. Create a view to display customer purchase history.
-- (customer_id, customer_name, order_id, order_date, product_name, quantity, order_value)
create view customer_purchase_history as
	select c.customer_id,c.customer_name,
		   o.order_id,o.order_date,o.sales_channel,  
           p.product_id,p.product_name, 
           p.price as unit_price,i.quantity,p.gst_rate,
           ((price+(price*gst_rate/100))*quantity) as line_total
	from customer c join orders o
    on c.customer_id=o.customer_id
    join order_items i
    on o.order_id=i.order_id
    join product p
    on p.product_id=i.product_id
    order by c.customer_id;
 select * from customer_purchase_history;

-- V3. Create a view to display dealer supply history.
-- (dealer_name,product_name,warehouse_location,quantity,purchase_price,supply_date)
create view dealer_supply_history as
	select t.transport_id, 
		   d.dealer_id,d.dealer_name,dl.city as dealer_city,
		   p.product_id,p.product_name,
		   case 
				 when t.destination_type='Warehouse'
				 then w.warehouse_id
				 else null
           end as warehouse_id,
           case 
				when t.destination_type='Store'
				then s.store_id
				else null	
		   end as store_id,
           coalesce(wl.city,sl.city) as destination_city,
		   dp.purchase_price,ti.quantity,
		   round((dp.purchase_price*ti.quantity),2) as line_total,
           t.dispatch_date,
		   t.arrival_date
	from transport t
    join transport_item ti 
    on t.transport_id=ti.transport_id
	join dealer d
    on t.source_type='Dealer' and t.source_id=d.dealer_id
	join product p
	on p.product_id=ti.product_id
    join dealer_product dp
    on dp.dealer_id=d.dealer_id and dp.product_id=p.product_id
    join location dl
    on d.location_id=dl.location_id
    left join warehouse w
		on t.destination_type='Warehouse'
        and t.destination_id=w.warehouse_id
	left join store s
		on t.destination_type='Store'
        and t.destination_id=s.store_id 
	left join location wl
    on wl.location_id=w.location_id
	left join location sl
    on sl.location_id=s.location_id;
select * from dealer_supply_history
order by transport_id;


-- V4. Create a view to display warehouse inventory summary.
-- (warehouse_id, warehouse_location, total_products, total_inventory_quantity, total_inventory_value)
create view inventory_summary as
	select w.warehouse_id, w.capacity_sqm,
			concat(w.locality,',',l.city,',',l.state,',',l.pincode) as warehouse_location,
			count(distinct p.product_id) as total_products,
			sum(i.quantity) as total_inventory_quantity,
			round(sum(p.price*i.quantity),2) as total_inventory_value
	from product p join inventory i
	on p.product_id=i.product_id
	join warehouse w
	on w.warehouse_id=i.warehouse_id
	join location l
	on w.location_id=l.location_id
    where i.quantity>0
	group by w.warehouse_id,w.capacity_sqm,warehouse_location;
select  * from inventory_summary;

-- V5. Create a view to display Store inventory summary
-- (store_id,store_address,total_products, total_inventory_quantity, total_inventory_value)
create view store_inventory_summary as
	select s.store_id, s.capacity_sqm,
		concat(s.locality,',',l.city,',',l.state,',',l.pincode) as store_location,
		count(distinct p.product_id) as total_products,
		sum(i.quantity) as total_inventory_quantity,
		round(sum(p.price*i.quantity),2) as total_inventory_value	
    from product p join store_inventory i
	on p.product_id=i.product_id
	join store s
	on s.store_id=i.store_id
	join location l
	on s.location_id=l.location_id
    where i.quantity>0
	group by s.store_id,s.capacity_sqm,store_location;
select * from store_inventory_summary;
drop view store_inventory_summary;

-- V6. Create a view to display product sales summary.
-- (product_id, product_name, total_quantity_sold, total_revenue)
create view product_sales_summary as
	select p.product_id,p.product_name,
			COALESCE(stock.total_quantity_stocked, 0) AS total_quantity_stocked,
			COALESCE(sold.total_quantity_sold, 0) AS total_quantity_sold,
			COALESCE(sold.total_revenue, 0) AS total_revenue
	from product p 
    left join (
			select ti.product_id,sum(ti.quantity) as total_quantity_stocked
			from transport_item ti join transport t
            on t.transport_id=ti.transport_id
            where t.source_type='Dealer'
            group by ti.product_id) stock
	on stock.product_id=p.product_id
    left join (
			select oi.product_id,sum(oi.quantity) as total_quantity_sold,
            sum(p2.price*oi.quantity) as total_revenue
			from order_items oi join orders o 
            on o.order_id=oi.order_id
            join product p2
			on p2.product_id=oi.product_id
			group by oi.product_id)sold
	on sold.product_id=p.product_id;
select * from product_sales_summary;


-- V7. Create a view to display current stock alerts in store and warehouse.
-- (product_id, product_name, current_quantity, warehouse/store,alert_meassage)
create view warehouse_stock_status as
	select p.product_id,p.product_name,
		i.warehouse_id,
        i.quantity as current_quantity,
        case 
			when i.quantity=0 then 'Out of Stock'
            when i.quantity<=5 then 'Critical Stock'
            when i.quantity<=10 then 'Low Stock'
         end as stock_status
	from inventory i join product p
    on i.product_id=p.product_id
    where i.quantity<=10;

create view store_stock_status as
    select p.product_id,p.product_name,
		si.store_id ,
        si.quantity as current_quantity,
        case 
			when si.quantity=0 then 'Out of Stock'
            when si.quantity<=5 then 'Critical Stock'
            when si.quantity<=10 then 'Low Stock'
         end as stock_status
	from store_inventory si join product p
    on si.product_id=p.product_id
    where si.quantity<=10;

select * from warehouse_stock_status;
select * from store_stock_status;
select stock_status, count(*) 
from warehouse_stock_status
group by stock_status;
select stock_status, count(*) 
from store_stock_status
group by stock_status;

-- V7. Create a view to display profit margin for each product.
-- (product_id,product_name,selling_price,avg_purchase_price,profit_margin)
create view profit_margin_analysis as
	select product_id,product_name,price as selling_price,
		avg_purchase_price(p.product_id) as avg_purchase_price,
        calculate_profit_percent(p.product_id) as profit_margin
	from product p;
select * from profit_margin_analysis;