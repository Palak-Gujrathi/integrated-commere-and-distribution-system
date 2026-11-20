import csv 
import random

product_data = {}

with open("product_price.csv", "r") as csv_file:
    csv_reader = csv.DictReader(csv_file)

    for row in csv_reader:
        product_data[int(row["product_id"])] = int(row["category_id"])

stock_map = {
    1:(100,500),
    2:(300,1000),
    3:(5,50),
    4:(50,250),
    5:(20,120),
    6:(30,150),
    7:(80,300),
    8:(80,250),
    9:(100,500),
    10:(20,120),
    11:(40,180),
    12:(2,25),
    13:(50,250),
    14:(20,120),
    15:(40,200),
    16:(30,180),
    17:(50,250),
    18:(5,50),
    19:(20,120)
}
product_ids=list(product_data.keys())
fieldnames=["product_id","qty","store_id"]
inventory=set()
with open('store_inventory.csv','w',newline='') as csv_file:
    csv_writer=csv.DictWriter(csv_file,fieldnames=fieldnames)
    csv_writer.writeheader()
    for store_id in range(1,6):
        total_products= random.randint(25,60)
        product_id= random.sample(product_ids,total_products)

        for product_id in product_id:
            category_id= product_data[product_id]
            low,high=stock_map[category_id]
            qty=random.randint(low,high)

            csv_writer.writerow({
                "product_id":product_id,
                "qty":qty,
                "store_id":store_id
            })