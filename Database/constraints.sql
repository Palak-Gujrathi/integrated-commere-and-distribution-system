use retail_sales;

alter table product
add constraint fk_product_category
foreign key (category_id) references category(category_id) 
on update cascade on delete restrict;

alter table order_items
add constraint fk_order_items_product
foreign key (product_id) references product(product_id)
on update cascade on delete cascade;

alter table dealer_product
add constraint fk_dealer_product_product
foreign key (product_id) references product(product_id)
on update cascade on delete cascade;

alter table inventory
add constraint fk_inventory_product
foreign key (product_id) references product(product_id)
on update cascade on delete cascade;

alter table order_items
add constraint fk_order_items_orders
foreign key (order_id) references orders(order_id)
on update cascade on delete cascade;

alter table orders
add constraint fk_orders_customer
foreign key (customer_id) references customer(customer_id)
on update cascade on delete restrict;

alter table dealer_product
add constraint fk_dealer_product_dealer
foreign key (dealer_id) references dealer(dealer_id)
on update cascade on delete cascade;

alter table inventory
add constraint fk_inventory_warehouse
foreign key (warehouse_id) references warehouse (warehouse_id)
on update cascade on delete restrict;

alter table stock_alert
add constraint fk_product_alert
foreign key (product_id) references product(product_id)
on update cascade on delete restrict;

alter table stock_alert
add constraint fk_warehouse_alert
foreign key (warehouse_id) references warehouse(warehouse_id)
on update cascade on delete restrict;

alter table warehouse
add constraint fk_warehouse_location
foreign key (location_id) references location(location_id)
on update cascade on delete restrict;

alter table customer
add constraint fk_customer_location
foreign key (location_id) references location(location_id)
on update cascade on delete restrict;

alter table employee
add constraint fk_employee_location
foreign key (location_id) references location(location_id)
on update cascade on delete restrict;

alter table store
add constraint fk_store_location
foreign key (location_id) references location(location_id)
on update cascade on delete restrict;

alter table store_inventory
add constraint fk_store_inventory_store
foreign key (store_id) references store(store_id)
on update cascade on delete cascade;

alter table store_inventory
add constraint fk_store_inventory_product
foreign key (product_id) references product(product_id)
on update cascade on delete cascade;

alter table shippment
add constraint fk_shippment_order
foreign key (order_id) references orders(order_id)
on update cascade on delete restrict;

alter table shippment
add constraint fk_shippment_warehouse
foreign key (source_warehouse_id) references warehouse(warehouse_id)
on update cascade on delete restrict;

alter table shippment
add constraint fk_shippment_store
foreign key (source_store_id) references store(store_id)
on update cascade on delete restrict;

alter table shippment
add constraint fk_shippment_destination_location
foreign key (destination_location_id) references location(location_id)
on update cascade on delete restrict;

alter table shippment
add constraint fk_shippment_delivery_company
foreign key (company_id) references delivery_company(company_id)
on update cascade on delete restrict;

alter table stock_alert
add constraint fk_stock_alert_store
foreign key (store_id) references store(store_id)
on update cascade on delete restrict;

alter table transport_item
add constraint fk_transport_item_transport
foreign key (transport_id)
references transport(transport_id)
on update cascade on delete cascade;

alter table transport_item
add constraint fk_transport_item_product
foreign key (product_id)
references product(product_id)
on update cascade on delete cascade;

-- ---------------------------------------------------------------------------------------------------------------------

select table_name,column_name,constraint_name,referenced_table_name,referenced_column_name
from information_schema.key_column_usage
where table_schema='retail_sales'
and referenced_table_name is not null
order by table_name,constraint_name;

-- ----------------------------------------------------------------------------------------------------------------------

alter table product
add constraint chk_product_price
check (price>=0);

alter table product
add constraint chk_product_gst_rate
check (gst_rate in (0,5,12,18,28));

alter table shippment
add constraint chk_delivery_date
check(delivery_date is not null and delivery_date>=shippment_date);

alter table orders
add constraint chk_packaging_cost
check(packaging_cost>=0);

alter table order_items
add constraint chk_quantity
check (quantity>0);

alter table order_items
add constraint chk_selling_price
check(selling_price >=0);

alter table dealer_product
add constraint chk_purchase_price
check (purchase_price>=0);

alter table dealer_product
add constraint chk_available_qty
check (available_qty>=0);

alter table dealer_product
add constraint chk_delivery_days
check (delivery_days>=0);

alter table warehouse
add constraint chk_capacity
check (capacity_sqm>=0);

alter table warehouse
add constraint chk_rent
check (rent>=0);

alter table inventory
add constraint chk_inventory_quantity
check (quantity>=0);

alter table customer
add column email varchar(100);
