use retail_sales;
create table category(
						category_id int auto_increment primary key,
                        category_name varchar (100) not null);
show tables;
desc category;

create table location(location_id int auto_increment primary key,
					  city varchar(70) not null,
                      pincode char(6),
					  state varchar(50));
desc location;

create table customer(
						customer_id int auto_increment primary key,
                        customer_name varchar(100) not null,
                        street varchar(100),
                        location_id int, 
                        phone varchar(15) not null unique,
                        email varchar(100)) ;
desc customer;

create table product(
						product_id int auto_increment primary key,
                        product_name varchar(100) not null,
                        category_id int not null,
                        price decimal(10,2) not null,
                        gst_rate decimal(4,2) not null,
                        specification varchar(100),
                        expiry_date date);
desc product;
alter table product
add column product_code varchar(20) null;

create table orders(
						order_id int auto_increment primary key,
                        total_products int not null,
                        customer_id int not null,
                        order_date date not null,
                        packaging_cost decimal(6,2) not null default 0.00,
                        sales_channel varchar(10));
 desc orders;

create table order_items(
						  order_id int not null,
                          product_id int not null,
                          quantity int not null,
                          primary key(order_id,product_id));
desc order_items;
				
create table dealer(
						dealer_id int auto_increment primary key,
                        dealer_name varchar(100) not null,
                        email_id varchar(100) unique,
                        phone varchar(15) not null unique,
                        locality varchar(50),
						location_id int);
desc dealer;
 
create table dealer_product(
								dealer_id int not null,
                                product_id int not null,
                                purchase_price decimal(8,2) not null,
                                available_qty int not null default 0,
                                delivery_days int not null,
                                primary key(dealer_id,product_id));
desc dealer_product;

create table employee(
						employee_id int auto_increment primary key,
                        employee_name varchar(50)not null ,
                        salary decimal(10,2)not null check(salary>0),
                        phone varchar(15) not null unique,
                        email_id varchar(100) not null unique,
                        designation varchar(50),
                        joining_date date not null,
                        current_locality varchar (50),
                        location_id int,
                        assignment varchar(10));
desc employee;

create table warehouse(
						warehouse_id int auto_increment primary key,
                        capacity_sqm decimal(8,2)not null,
                        locality varchar (50),
                        location_id int,
                        rent decimal(8,2) default 0.00);
desc warehouse;

create table inventory(product_id int not null,
					   warehouse_id int not null,
                       quantity int not null default 0,
                       primary key(product_id,warehouse_id));
desc inventory;
show tables;


create table stock_alert( alert_id int auto_increment primary key,
						  product_id int not null,
						  warehouse_id int null,
                          store_id int null,
                          current_qty int not null,
                          alert_message varchar(200),
                          alert_date datetime default current_timestamp);
desc stock_alert;


create table store( store_id int primary key auto_increment,
					locality varchar(50) not null,
                    location_id int not null,
                    capacity_sqm decimal(8,2)not null);
desc store;

                    
create table store_inventory( product_id int not null,
							  store_id int not null,
							  quantity int,
                              primary key(product_id,store_id));
desc store_inventory;

                              
create table delivery_company( company_id int primary key auto_increment,
							   company_name varchar (200),
                               contact varchar(15) not null unique,
                               email_id varchar(100) unique);
desc delivery_company;
                         
						
create table transport( transport_id int primary key,
				        transport_type varchar(50),
                        transport_company varchar(100),
                        source_type varchar (50),
                        source_id int,
                        destination_type varchar(50),
                        destination_id int,
                        dispatch_date date,
                        arrival_date date,
                        cost decimal(10,2) not null); 
desc transport;


create table transport_item( transport_id int not null,
							product_id int not null,
							quantity int not null,
                            primary key(transport_id,product_id));
desc transport_item;
                    
create table shippment( shippment_id int primary key auto_increment,
						order_id int not null,
                        company_id int,
						source_warehouse_id int,
                        source_store_id int,
                        destination_location_id int,
                        shippment_date date,
                        delivery_date date,
                        shippment_cost int not null,
                        tracking_number varchar(20));
desc shippment;

show tables;



