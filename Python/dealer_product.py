from faker import Faker
import csv 
import random

product_data={}
with open("product_price.csv","r") as csv_file:
    csv_reader=csv.DictReader(csv_file)
    for row in csv_reader:
        product_data[int(row["product_id"])]= {
                    "category_id":int(row["category_id"]),
                    "price":float(row["price"])
                }

margin_map = {
    1: (0.72, 0.82),
    2: (0.88, 0.95),
    3: (0.82, 0.90),
    4: (0.55, 0.72),
    5: (0.60, 0.75),
    6: (0.70, 0.82),
    7: (0.60, 0.75),
    8: (0.55, 0.70),
    9: (0.68, 0.82),
    10: (0.60, 0.75),
    11: (0.68, 0.80),
    12: (0.72, 0.85),
    13: (0.60, 0.75),
    14: (0.65, 0.78),
    15: (0.78, 0.90),
    16: (0.70, 0.82),
    17: (0.70, 0.82),
    18: (0.45, 0.65),
    19: (0.68, 0.82)
}

dealer_product=set()
fieldnames=["dealer_id","product_id","purchase_price","available_qty","delivery_days"]
with open('dealer_product.csv','w',newline='') as csv_file:
    csv_writer=csv.DictWriter(csv_file,fieldnames=fieldnames)
    csv_writer.writeheader()
    while len(dealer_product)<1000:
        product_id=product_id = random.choice(list(product_data.keys()))
        dealer_id=random.randint(1,40)
        dealer_product.add((dealer_id,product_id))

    for dealer_id,product_id in dealer_product:
        selling_price=product_data[product_id]["price"]
        category=product_data[product_id]["category_id"]
        low,high=margin_map[category]
        purchase_price= round(selling_price*random.uniform(low,high),2)

        available_qty=random.randint(10,100)*10
        delivery_days= random.randint(1,5) 

        csv_writer.writerow({
            "dealer_id":dealer_id,
            "product_id":product_id,
            "purchase_price":purchase_price,
            "available_qty":available_qty,
            "delivery_days":delivery_days
        })