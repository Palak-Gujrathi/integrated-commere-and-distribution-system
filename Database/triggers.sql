use retail_sales;
show triggers from retail_sales;

-- T1. Create a trigger to prevent inventory quantity from becoming negative.
delimiter $$
create trigger trg_inventory_qty_insert
	before insert
    on inventory
    for each row
	begin
		if new.quantity<0 then
			signal sqlstate "45000"
            set message_text ='Inventory quantity can never be negative!';
		end if;
	end $$

create trigger trg_inventory_qty_update
	before update on inventory
    for each row
    begin
		if new.quantity<0 then
			signal sqlstate "45000"
            set message_text='Inventory quantity can never be negative!';
		end if;
	end $$
delimiter $$

-- T2. Prevent placing an order if requested quantity is greater than available inventory.
-- delimiter $$
-- create trigger 
-- 	before insert 
--     on order_items
--     for each row
-- 	begin
-- 		select quantity into available_qty
--         from inventory
--         where product_id=new.product_id;
--         
--         if new.quantity>available_qty then
-- 			signal sqlstate '45000'
--             set message_text='Requested quantity exceeds available quantity!';
-- 	end
-- delimiter ;
-- PENDING: Warehouse allocation will be handled through backend logic based on customer location.



-- T3. create a trigger to notify dealer about low stock status of particular product in particular warehouse.
delimiter $$
create trigger trg_warehouse_stock_alert
	after update on inventory
    for each row
	begin
		if new.quantity<10 then
			insert into stock_alert(product_id,warehouse_id,current_qty,alert_message)
			 values ( new.product_id,new.warehouse_id,new.quantity,
			 case
				when new.quantity =0 then 'Out of stock'
				when new.quantity <=5 then 'Critical low stock' 
                else 'Low stock'
			end);
		 end if;
	end $$
    
create trigger trg_store_stock_alert
	after update on store_inventory
	for each row
	begin 
		if new.quantity<10 then 
			insert into stock_alert(product_id,store_id,current_qty,alert_message)
            values(new.product_id,new.store_id,new.quantity,
            case
				when new.quantity=0 then 'Out of Stock'
                when new.quantity<=5 then 'Critical Stock'
                else 'Low Stock'
			end);
		end if;
	end $$
delimiter ;

UPDATE inventory
SET quantity = 8
WHERE product_id = 40
  AND warehouse_id = 1;
select * from stock_alert;


-- T4. Create a trigger to receive a dealer/warehouse supply and automatically update inventory quantity of warehouse/store for a given transport id.
delimiter $$
create trigger trg_receive_supply
	after insert
    on transport
    for each row
    begin
		call recieve_supply(new.transport_id);    -- existing procedure call
    end $$
delimiter ;


-- T5. Create a trigger to update inventory quantity of warehouse/store for a given shippment id.
delimiter $$
create trigger trg_shipping
	after insert
    on shippment
    for each row
    begin
		call shipping(new.shippment_id);      -- existing procedure call
    end $$
delimiter ;