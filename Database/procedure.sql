use retail_sales;
show procedure status;

-- P1. Create a procedure to calculate the bill for a given order_id. (Subtotal, packaging cost, total amount)
delimiter $$
create procedure customer_invoice(in c_order_id int)
begin 
	select o.order_id,o.sales_channel as purchase_mode,c.customer_name,o.order_date,
		case
			when o.sales_channel='Store' then Null
            else s.delivery_date
		 end as delivery_date
    from orders o join customer c
    on o.customer_id=c.customer_id
    left join shippment s 
    on s.order_id=o.order_id
    where o.order_id=c_order_id;
	-- --------------------------------------
    select p.product_name,p.price,i.quantity,p.gst_rate,
			round((i.quantity*p.price)
					+i.quantity*p.price*(p.gst_rate/100),2) as line_total
	from product p join order_items i 
    on p.product_id=i.product_id
    where i.order_id = c_order_id;
    -- --------------------------------------
	select round(sum((i.quantity*p.price)
					+i.quantity*p.price*(p.gst_rate/100)),2) as subtotal,
         o.packaging_cost,
         case
			when o.sales_channel='Store' then 0
            else coalesce(s.shippment_cost,0) 
		 end as shipment_cost,
         round(sum((i.quantity*p.price)
					+i.quantity*p.price*(p.gst_rate/100))
                    +coalesce(o.packaging_cost,0)
                    + case
						when o.sales_channel='Store' then 0
						else coalesce(s.shippment_cost,0) 
					  end, 2) as total_amount
     from customer c join orders o
     on c.customer_id=o.customer_id
     join order_items i
     on i.order_id=o.order_id
     join product p
     on p.product_id=i.product_id
     left join shippment s
     on s.order_id=o.order_id
     where o.order_id=c_order_id
     group by o.order_id,o.sales_channel,c.customer_name, o.packaging_cost,s.shippment_cost,s.delivery_date;
end $$
delimiter ;
call customer_invoice(19);
call customer_invoice(161);
call customer_invoice(1);

#------------------------------------------------------------------------------------------------------------------------------------------


-- P2. Create a procedure to receive a dealer/warehouse supply and automatically update inventory quantity of warehouse/store for a given transport id.
delimiter $$
create procedure receive_supply(in c_transport_id int)
	begin
        declare t_destination_type varchar(50);
        declare t_destination_id int;
        declare t_product_id int;
        declare t_supply_quantity int;
		declare t_old_quantity int;
        
        declare done int default 0;
		declare transport_cursor cursor for 
			 select product_id,quantity 
			 from transport_item
			 where transport_id=c_transport_id;
		declare continue handler for not found set done=1;
        
         select destination_type,destination_id
         into t_destination_type,t_destination_id
         from transport
         where transport.transport_id=c_transport_id;
         
         open transport_cursor;
         product_loop: loop
			fetch transport_cursor
            into t_product_id,t_supply_quantity;
            if done=1 then
				leave product_loop;
			end if;
         
			 if t_destination_type = 'Warehouse' then
				 select quantity into t_old_quantity
				 from inventory 
				 where inventory.warehouse_id=t_destination_id 
					and product_id=t_product_id;
				 update inventory
				 set quantity=t_old_quantity +t_supply_quantity
				 where inventory.product_id= t_product_id 
					 and warehouse_id= t_destination_id;
					 
			 elseif t_destination_type= 'Store' then       
				 select quantity into t_old_quantity
				 from store_inventory 
				 where store_inventory.store_id=t_destination_id 
					and product_id=t_product_id;               
				update store_inventory
				set quantity=t_old_quantity + t_supply_quantity
				where store_inventory.product_id= t_product_id 
					and store_inventory.store_id= t_destination_id ;
					
			 end if;
		end loop;
        close transport_cursor;
    end $$
delimiter ;
call receive_supply(10);
rollback;
#--------------------------------------------------------------------------------------------------------------------------------------------


-- P3. Create a procedure to automatically update inventory quantity of warehouse/store for a given shippment id.
delimiter $$
create procedure shipping(in c_shippment_id int)
	begin
		declare s_source_warehouse int;
        declare s_source_store int;
        declare s_destination_id int;
        declare s_product_id int;
        declare s_supply_quantity int;
		declare s_old_quantity int;
        
        declare done int default 0;
		declare shipping_cursor cursor for 
			 select oi.product_id,oi.quantity 
			 from order_items oi
			 where oi.order_id=(
								 select sh.order_id
                                 from shippment sh
                                 where sh.shippment_id=c_shippment_id);
		declare continue handler for not found set done=1;
        
         select source_warehouse_id,source_store_id,destination_id
         into s_source_warehouse,s_source_store,s_destination_id
         from shippment
         where shippment.shippment_id=c_shippment_id;
         
         open shipping_cursor;
         product_loop: loop
			fetch shipping_cursor
            into s_product_id,s_supply_quantity;
            if done=1 then
				leave product_loop;
			end if;
         
			 if s_source_store is Null then
				 select quantity into s_old_quantity
				 from inventory 
				 where inventory.warehouse_id=s_source_warehouse
					and product_id=s_product_id;
				 update inventory
				 set quantity=s_old_quantity - s_supply_quantity
				 where inventory.product_id= s_product_id 
					 and warehouse_id= s_source_warehouse;
					 
			 elseif s_source_warehouse is null then       
				 select quantity into s_old_quantity
				 from store_inventory 
				 where store_inventory.store_id=s_source_store
					and product_id=s_product_id;               
				update store_inventory
				set quantity=s_old_quantity - s_supply_quantity
				where store_inventory.product_id= s_product_id 
					and store_inventory.store_id= s_source_store ;
					
			 end if;
		end loop;
        close shipping_cursor;
    end $$
delimiter ;


#--------------------------------------------------------------------------------------------------------------------------------------------


-- P4. create a procedure to Authorize a dealer to supply a new product.
-- If dealer already supplies that product → show message. Else → authorize dealer for that product.
delimiter $$
create procedure authorize_dealer_product(in c_dealer_id int,
										  in c_product_id int,
                                          in c_purchase_price decimal(10,2),
                                          in c_delivery_days int)
	begin 
           declare authorized_product int;
           
           select product_id into authorized_product
           from dealer_product
		   where dealer_id=c_dealer_id
             and product_id=c_product_id;
             
           if authorized_product is not null then 
			select "Dealer already supplies this product" as message;
            
		   else
			 insert into dealer_product (dealer_id,product_id,purchase_price,delivery_days)
             values (c_dealer_id,c_product_id,c_purchase_price,c_delivery_days);
             
			select d.dealer_id,d.dealer_name,p.product_name,
				   dp.purchase_price,dp.delivery_days,
                   "deleaer authorized successfully!!" as message
			from dealer_product dp join dealer d
            on dp.dealer_id=d.dealer_id
            join product p
            on p.product_id=dp.product_id
            where dp.dealer_id=c_dealer_id 
              and dp.product_id=c_product_id;
		  end if;
    end $$
delimiter ;

call authorize_dealer_product(11,104,250.40,3);
call authorize_dealer_product(2,104,250.40,3);
#----------------------------------------------------------------------------------------------------------------------------------------


-- P5. Create a procedure to update dealer-product authorization details.
-- (Purchase price, delivery days, or blacklist a dealer for a specific product)
delimiter $$
create procedure update_dealer_product(in c_dealer_id int,
										  in c_product_id int,
                                          in c_purchase_price decimal(10,2),
                                          in c_delivery_days int)
	begin 
		declare old_purchase_price decimal(10,2);
        declare old_delivery_days int;
        declare authorized_product int;
        
		select product_id into authorized_product
		from dealer_product
		where dealer_id=c_dealer_id
		  and product_id=c_product_id;
             
		if authorized_product is null then 
			select "Dealer not authorized for this product" as message;
		else
          select purchase_price,delivery_days
          into old_purchase_price,old_delivery_days
          from dealer_product
          where dealer_id=c_dealer_id
           and product_id=c_product_id;
        
          update dealer_product 
          set purchase_price=c_purchase_price,
              delivery_days=c_delivery_days
		  where dealer_id=c_dealer_id
             and product_id=c_product_id;
             
		  select d.dealer_name,p.product_name,
                 old_purchase_price as previous_purchase_price,
                 c_purchase_price as updated_purchase_price,
                 old_delivery_days as previous_delivery_days,
                 c_delivery_days as updated_delivery_days,
                 "Dealer details updated successfully" as message
		  from  dealer d, product p
          where d.dealer_id=c_dealer_id
             and p.product_id=c_product_id;
             
		end if;
	end $$
delimiter ;
call update_dealer_product(22,104,260.00,2);
call update_dealer_product(16,104,250.40,3);
#----------------------------------------------------------------------------------------------------------------------------------------------

-- P6. create a procedure to calculate bill for given transport_id as dealer invoice 
delimiter $$
create procedure dealer_invoice(in c_transport_id int)
	begin 
		select t.transport_id,d.dealer_id,d.dealer_name,
				dl.city as dealer_city,
                concat(t.destination_type,'-',t.destination_id,' ',l.city) as destination,
				t.dispatch_date,t.arrival_date
		from transport t join dealer d
		on t.source_id=d.dealer_id
        join location l 
        on t.destination_id=l.location_id
        join location dl
        on d.location_id=dl.location_id
		where t.source_type='Dealer'and
        t.transport_id=c_transport_id;
        
        select ti.product_id,p.product_name,dp.purchase_price,ti.quantity,
				round(dp.purchase_price*ti.quantity,2) as line_total
        from transport t join transport_item ti 
        on t.transport_id=ti.transport_id
        join product p
        on ti.product_id=p.product_id
        join dealer_product dp
        on dp.product_id=p.product_id
			and dp.dealer_id=t.source_id
        where t.transport_id=c_transport_id;
        
        select round(sum(dp.purchase_price*quantity),2) as Total_Purchase_value,
			t.cost as transportation_charges,
            round(sum(dp.purchase_price*quantity),2) as Total_Amount
		from transport t join transport_item ti 
        on t.transport_id=ti.transport_id
        join dealer_product dp
        on dp.product_id=ti.product_id 
			and dp.dealer_id=t.source_id
        where t.transport_id=c_transport_id
			and t.source_type='Dealer'
		group by t.transport_id,t.cost;
	end $$
delimiter ;
call dealer_invoice(31);
