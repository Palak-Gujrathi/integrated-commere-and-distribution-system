use retail_sales;
select @@sql_safe_updates; 
set sql_safe_updates=0;

insert into category values(1,'Healthcare Products');
insert into category (category_name)
values
	('Food'),
    ('Electronics'),
    ('Clothing'),
    ('Footwear'),
    ('Utensils'),
    ('Skincare'),
    ('Cosmetics'),
    ('Stationery'),
    ('Home Decor'),
    ('kitchenware'),
    ('Furniture'),
    ('Toys'),
	('Sports & Fitness'),
	('Books'),
	('Pet Supplies'),
	('Baby Products'),
	('Jewellery'),
	('Automotive Accessories');
update category
set category_name='Food and Beverages'
where category_id=2;
select * from category;

insert into product (product_name,category_id,price,gst_rate,specification,expiry_date)
values
	-- healthcare products
	('Himalaya Menosan Tablets',1,216.00,12.00,'30 Tablets','2028-12-31'),
	('Electric Heating Hot Water Bag',1,289.00,12.00,'With Pouch, 1 Pc',NULL),
	('Bibo Fever Cooling Patch',1,149.00,12.00,'Pack of 3',NULL),
	('Tynor Abdominal Support',1,628.00,12.00,'Large, Grey',NULL),
	('Dabur Chyawanprash',1,315.00,12.00,'500 g','2028-12-31'),
	-- food and beverages
	('Red Label Natural Care Tea',2,518.00,5.00,'1 kg','2027-11-30'),
	('Amul Butter',2,299.00,5.00,'500 g','2027-10-31'),
	('Hazelnut Hot Chocolate',2,169.00,5.00,'240 ml','2027-09-30'),
	('Mayurank Organic Sugar',2,66.00,5.00,'1 kg','2029-06-30'),
	('Fortune Sunlite Sunflower Oil',2,151.50,5.00,'840 g','2028-05-31'),
    -- Electronics
    ('Apple iPhone 17',3,82999,18,'256GB, White, 1 Unit',null),
    ('Dell Inspiron Ryzen 5 Laptop',3,65990,18,'16GB RAM, 512GB SSD, 15.6" FHD 1 Unit',null),
	('boAt Stone 135 Bluetooth Speaker',3,1990,18,'Active Black, 1 pc',null),
    ('Logitech M331 Wireless Mouse',3,1295,18,'Wireless, Silent Click',NULL),
    ('Samsung Galaxy Tab A9',3,15999,18,'8GB RAM, 128GB Storage',NULL),
    ('Sony WH-CH520 Wireless Headphones',3,4499,18,'Bluetooth, Black',NULL),
    -- clothing
    ('Levis Men''s Slim Fit Jeans',4,2299,12,'Blue, Size 32',NULL),
	('Van Heusen Men''s Formal Shirt',4,1799,12,'White, Size L',NULL),
	('Biba Women''s Printed Kurti',4,1499,12,'Cotton, Size M',NULL),
	('Allen Solly Women''s Casual Top',4,999,12,'Pink, Size M',NULL),
	('Jockey Unisex Cotton T-Shirt',4,799,12,'Black, Size L',NULL),  
    -- footwear
    ('Asian Footwear Mens Black Walking Shoes',5,914,18,'1-Pair (UK/IND-8)', null),
    ('Asian Footwear Indigo-01 Womens Flip Flops',5,599,18,'Baby Pink, 1 Pair (UK/IND - 7)',null),
    ('Redtape Mens Clogs',5,929,18,'Light-Grey, 1 Pair (UK/IND-9)',null),
    ('Bata Womens Sandals',5,1299.00,18.00,'Tan, Size 6',NULL),
	('Puma Unisex Running Shoes',5,2499.00,18.00,'Black, Size 9',NULL),
	-- utensils
    ('Prestige Pressure Cooker',6,2499,18,'5 L, Aluminium',NULL),
	('Milton Stainless Steel Water Bottle',6,499,18,'1 L',NULL),
	('Pigeon Non-Stick Fry Pan',6,899,18,'24 cm',NULL),
	('Cello Dinner Plate Set',6,799,18,'Pack of 6',NULL),
	('Butterfly Stainless Steel Spoon Set',6,349,18,'Pack of 12',NULL),
	-- skincare
	('Nivea Soft Moisturising Cream',7,299,18,'200 ml','2028-09-30'),
	('Himalaya Neem Face Wash',7,180,18,'200 ml','2028-12-31'),
	('Mamaearth Vitamin C Face Serum',7,599,18,'30 ml','2029-03-31'),
	('Pond''s Super Light Gel',7,349,18,'147 g','2028-11-30'),
	('Cetaphil Gentle Skin Cleanser',7,699,18,'250 ml','2029-06-30'),
    ('Vaseline Intensive Care Body Lotion',7,275,18,'400 ml','2029-02-28'),
    -- cosmetics
    ('Lakme Eyeconic Kajal',8,299,18,'0.35 g','2028-10-31'),
	('Maybelline Fit Me Foundation',8,549,18,'30 ml','2029-05-31'),
	('Faces Canada Matte Lipstick',8,399,18,'4.2 g','2028-12-31'),
	('Lakme Face Compact',8,225,18,'9 g','2029-03-31'),
	('Colorbar Nail Polish',8,199,18,'12 ml','2028-08-31'),
    -- stationery
    ('Classmate Notebook',9,120,12,'200 Pages',NULL),
	('Cello Butterflow Pen',9,50,12,'Pack of 10',NULL),
	('Apsara Platinum Pencils',9,60,12,'Pack of 10',NULL),
	('Faber-Castell Eraser',9,20,12,'Pack of 2',NULL),
	('Camel Geometry Box',9,180,12,'Metal Box',NULL),
    -- home decor
    ('Flower Vase',10,499,18,'Ceramic, White',NULL),
	('Wall Clock',10,899,18,'12 Inch',NULL),
	('Decorative LED Lights',10,699,18,'5 m, Warm White',NULL),
	('Photo Frame',10,349,18,'8 x 10 Inch',NULL),
	('Artificial Plant',10,599,18,'40 cm',NULL),
    ('Vaseline Intensive Care Body Lotion',7,275,18,'400 ml','2029-02-28'),
    -- kitchenware
    ('bb home Kitchen Dusters',11,99,18,'Pixel, 40 x 30 cm, Medium, 4 pcs',null),
    ('Milton Stainless Steel Water Bottle',11,499,18,'1 L',NULL),
	('Pigeon Non-Stick Fry Pan',11,899,18,'24 cm',NULL),
	('Cello Dinner Plate Set',11,799,18,'Pack of 6',NULL),
	('Signoraware Food Storage Container Set',11,599,18,'Pack of 6',NULL),
	-- Furniture 
    ('Study Table',12,3999,18,'Wooden, Brown',NULL),
	('Bookshelf',12,2899,18,'5 Shelves',NULL),
	('Coffee Table',12,2499,18,'Engineered Wood',NULL),
	('Wardrobe',12,11999,18,'3 Door',NULL),
    ('Office Chair',12,4599,18,'Ergonomic, Black',NULL),
    -- Toys
	('Remote Control Car',13,1499,12,'Rechargeable',NULL),
	('Building Blocks Set',13,899,12,'120 Pieces',NULL),
	('Barbie Doll',13,1299,12,'12 Inch',NULL),
	('Soft Teddy Bear',13,799,12,'40 cm',NULL),
	('Rubik''s Cube',13,299,12,'3 x 3',NULL),
	-- Sports and fitness
	('Nivia Football',14,799,12,'Size 5',NULL),
	('Yonex Badminton Racket',14,1499,12,'Graphite',NULL),
	('SG Cricket Bat',14,2499,12,'English Willow',NULL),
	('Cosco Basketball',14,999,12,'Size 7',NULL),
	('Skipping Rope',14,299,12,'Adjustable',NULL),
    -- books
    ('The Alchemist',15,399,5,'Paperback',NULL),
	('Atomic Habits',15,599,5,'Paperback',NULL),
	('Rich Dad Poor Dad',15,499,5,'Paperback',NULL),
	('The Psychology of Money',15,550,5,'Paperback',NULL),
	('Wings of Fire',15,350,5,'Paperback',NULL),
    ('Ikigai',15,450,5,'Paperback',NULL),
	-- Pet Supplies 
	('Pedigree Adult Dog Food',16,699,18,'3 kg','2028-06-30'),
	('Whiskas Cat Food',16,599,18,'1.2 kg','2028-04-30'),
	('Dog Leash',16,349,18,'Nylon',NULL),
	('Pet Shampoo',16,299,18,'200 ml','2029-01-31'),
	('Pet Feeding Bowl',16,249,18,'Stainless Steel',NULL),
	-- Baby products 
	('Johnson''s Baby Powder',17,299,18,'400 g','2029-03-31'),
	('Johnson''s Baby Soap',17,175,18,'125 g','2028-11-30'),
	('Pampers Baby Diapers',17,699,12,'Pack of 42',NULL),
	('Baby Wipes',17,249,18,'72 Wipes','2028-10-31'),
	('Baby Lotion',17,349,18,'200 ml','2029-05-31'),
	-- Jewellery
	('Oxidised Jhumka',18,299,18,'Oxidised Silver Finish',NULL),
	('Pearl Drop Earrings',18,249,18,'Artificial Pearl',NULL),
	('Layered Necklace',18,499,18,'Fashion Jewellery',NULL),
	('Charm Bracelet',18,349,18,'Alloy Metal',NULL),
	('Stone Bangles Set',18,449,18,'Set of 6',NULL),
	-- Automotive accessories
	('Car Vacuum Cleaner',19,1999,18,'Portable',NULL),
	('Car Air Freshener',19,299,18,'Lemon',NULL),
	('Microfiber Cleaning Cloth',19,199,18,'Pack of 4',NULL),
	('Bike Helmet',19,1599,18,'ISI Certified',NULL),
	('Car Mobile Holder',19,499,18,'Dashboard Mount',NULL),
    ('Michelin Tyre Pressure Gauge',19,599,18,'Digital',NULL);
    
update product 
set product_code= concat(
		case category_id 
			when 1 then 'HLCR'
			when 2 then 'FOOD'
            when 3 then 'ELEC'
            when 4 then 'CLOT'
            when 5 then 'FOOT'
            when 6 then 'UTIL'
            when 7 then 'SKIN'
            when 8 then 'COSM'
            when 9 then 'STAT'
            when 10 then 'HOME'
            when 11 then 'KITC'
            when 12 then 'FURN'
            when 13 then 'TOYS'
            when 14 then 'SPRT'
            when 15 then 'BOOK'
            when 16 then 'PETS'
            when 17 then 'BABY'
            when 18 then 'JEWL'
            when 19 then 'AUTO' 
            else 'OTHR'
			end, LPAD(product_id,4,'0')
			);
select * from product;

select * from location;
select * from customer;
select * from dealer;
select * from warehouse;

select * from employee;
UPDATE employee
SET joining_date = DATE_ADD(
    '2026-01-01',
    INTERVAL FLOOR(RAND() * 273) DAY);

select * from inventory;
INSERT INTO inventory (product_id, warehouse_id, quantity)
SELECT p.product_id,w.warehouse_id,0
FROM product p
CROSS JOIN warehouse w
LEFT JOIN inventory i
ON i.product_id = p.product_id
    AND i.warehouse_id = w.warehouse_id
WHERE i.product_id IS NULL;
UPDATE inventory i
JOIN (
    SELECT warehouse_id,product_id,
	ROW_NUMBER() OVER (
		PARTITION BY warehouse_id
		ORDER BY product_id DESC
	) AS rn
    FROM inventory                                                        
    WHERE quantity = 0) z
ON i.warehouse_id = z.warehouse_id
AND i.product_id = z.product_id
SET i.quantity = (MOD(i.product_id, 8) + 2) * 10
WHERE z.rn > (MOD(z.warehouse_id - 1, 15) + 4);

select * from dealer_product;
select * from orders;
select * from order_items;

insert into store (locality, location_id, capacity_sqm)
values  ('Andheri East', 97, 1850.00),
		('Navrangpura', 75, 2200.00),
		('T. Nagar', 64, 1950.00),
		('Banjara Hills', 101, 2400.00), 
		('College Road',102, 1400.00);
select * from store;

select * from store_inventory;
insert into store_inventory
select p.product_id,s.store_id,0
from product p 
cross join store s
left join store_inventory si
on s.store_id=si.store_id 
and p.product_id=si.product_id
where si.product_id is null;
update store_inventory si
JOIN (
    SELECT store_id,product_id,
	ROW_NUMBER() OVER (
		PARTITION BY store_id
		ORDER BY product_id DESC
	) AS rn
    FROM store_inventory                                                        
    WHERE quantity = 0) z
ON si.store_id = z.store_id
AND si.product_id = z.product_id
SET si.quantity = (MOD(si.product_id, 8) + 2) * 10
WHERE z.rn > (MOD(z.store_id - 1, 15) + 4);


select * from stock_alert;
insert into delivery_company (company_name, contact, email_id)
values  ('Delhivery', '9876501001', 'delhivery@example.com'),
		('Blue Dart', '9876501002', 'bluedart@example.com'),
		('DTDC', '9876501003', 'dtdc@example.com'),
		('Ecom Express', '9876501004', 'ecomexpress@example.com'),
		('XpressBees', '9876501005', 'xpressbees@example.com'),
		('DHL Express', '9876501006', 'dhlexpress@example.com');
select * from delivery_company;

select * from transport;
select * from transport_item;

select * from shippment;
delete from shippment;
update shippment
set source_warehouse_id=NULL 
where source_warehouse_id=0 ;
update shippment
set source_store_id=Null
where source_store_id=0;
delete s from shippment s
join orders o
on o.order_id=s.order_id
where sales_channel='Store';

