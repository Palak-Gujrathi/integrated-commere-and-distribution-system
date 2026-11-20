import csv 
import random

product_data={}
with open("product_price.csv","r") as csv_file:
    csv_reader=csv.DictReader(csv_file)
    for row in csv_reader:
         product_data[int (row["product_id"])]=int(row["category_id"])

quantity_map = {
    1: (1,3),      # Healthcare
    2: (1,6),      # Food
    3: (1,2),      # Electronics
    4: (1,5),      # Clothing
    5: (1,2),      # Footwear
    6: (1,3),      # Utensils
    7: (1,4),      # Skincare
    8: (1,4),      # Cosmetics
    9: (1,5),      # Stationery
    10:(1,2),      # Home Decor
    11:(1,3),      # Kitchenware
    12:(1,2),      # Furniture
    13:(1,4),      # Toys
    14:(1,3),      # Sports
    15:(1,4),      # Books
    16:(1,4),      # Pet Supplies
    17:(1,5),      # Baby Products
    18:(1,2),      # Jewellery
    19:(1,3)       # Automotive Accessories
}
product_ids=list(product_data.keys())
fieldnames = [ "order_id","product_id","quantity"]
with open('order_items.csv','w',newline='') as csv_file:
    csv_writer=csv.DictWriter(csv_file,fieldnames=fieldnames)
    csv_writer.writeheader()
    with open('orders.csv','r') as csv_file: 
        csv_reader=csv.DictReader(csv_file)
        order_id=1
        for row in csv_reader: 
            total_products=int(row["total_products"])
            product_id=random.sample(product_ids,total_products)
            for product_id in product_id:
                category=product_data[product_id]
                low,high=quantity_map[category]    
                quantity=random.randint(low,high)

                csv_writer.writerow({ 
                    "order_id":order_id,
                    "product_id":product_id,
                    "quantity":quantity 
                })
            order_id+=1
            
