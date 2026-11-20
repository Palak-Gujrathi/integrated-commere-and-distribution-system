use retail_sales;
show function status;

-- F1. Create a function to calculate inventory value.
-- (Inventory Value = price × quantity)
delimiter $$
 create function inventory_value(f_product_id int, f_warehouse_id int)
	returns decimal(10,2)
    deterministic
    begin
		declare inventory_value decimal(10,2);
        select p.price*i.quantity
        into inventory_value
        from inventory i join product p
        on i.product_id=p.product_id
        where i.product_id=f_product_id
         and i.warehouse_id=f_warehouse_id;
		return round(inventory_value,2);

    end $$
delimiter ;

select inventory_value(56,3);
select inventory_value(66,10);


-- F2. Create a function to calculate inventory value of store.
-- (Inventory Value = price × quantity)
delimiter $$
 create function inventory_value_store(f_product_id int, f_store_id int)
	returns decimal(10,2)
    deterministic
    begin
		declare inventory_value decimal(10,2);
        select p.price*s.quantity
        into inventory_value
        from store_inventory s join product p
        on s.product_id=p.product_id
        where s.product_id=f_product_id
         and s.store_id=f_store_id;
		return round(inventory_value,2);
    end $$
delimiter ;

select inventory_value_store(56,2);
select inventory_value_store(67,2);


-- F3. Create a function to calculate the total order amount.
-- (Total Amount = price × quantity)
delimiter $$
create function total_order_amount(f_order_id int)
 returns decimal(10,2)
 deterministic
	begin
		declare total_amount decimal(10,2);
        select round(sum((p.price*i.quantity)+(p.price*i.quantity*p.gst_rate/100))
					+o.packaging_cost
                    +coalesce(s.shippment_cost,0),2)
        into total_amount
        from product p join order_items i
        on p.product_id=i.product_id
        join orders o
        on o.order_id=i.order_id
        left join shippment s
        on s.order_id=i.order_id
        where i.order_id=f_order_id
        group by o.order_id,o.packaging_cost,s.shippment_cost;
	return round(total_amount,2);
    end $$
delimiter ;
drop function total_order_amount;
select total_order_amount(32);
select total_order_amount(199);
select total_order_amount(2);


-- F4. Create a function to calculate product profit.
-- (Profit = selling price − purchase price)
delimiter $$
create function avg_purchase_price(f_product_id int)
 returns decimal(10,2)
 deterministic
	begin
		declare avg_purchase_price decimal(10,2);
        
		select sum(dp.purchase_price*ti.quantity)/sum(ti.quantity)
        into avg_purchase_price
        from transport t join transport_item ti 
        on t.transport_id=ti.transport_id
        join dealer_product dp
        on ti.product_id=dp.product_id
			and dp.dealer_id=t.source_id
        where dp.product_id=f_product_id
			and t.source_type='Dealer';
	return round(avg_purchase_price,2);			
    end $$
delimiter ;

select avg_purchase_price(29);
select avg_purchase_price(87);

-- F5. Create a function to calculate profit percentage.
-- (Profit % = ((selling price − purchase price) / purchase price) × 100)
delimiter $$
create function calculate_profit_percent(f_product_id int)
 returns decimal(10,2)
 deterministic
	begin
		declare selling_price decimal(10,2);
        declare purchase_price decimal(10,2);
        select p.price into selling_price
        from product p
        where p.product_id=f_product_id;  
	
		set purchase_price=avg_purchase_price(f_product_id);
        if purchase_price is null or purchase_price=0 then 
			return null;
        end if;
	return round((selling_price-purchase_price)/purchase_price*100,2);
    end $$
delimiter ;
drop function calculate_profit_percent;
select calculate_profit_percent(29);
select calculate_profit_percent(87);