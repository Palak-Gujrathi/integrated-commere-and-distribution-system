from faker import Faker 
import csv 
import random
from datetime import date, timedelta

f = Faker('en_IN')
orders=[]
fieldnames=["customer_id","total_products","order_date","packaging_cost"]

for _ in range(3000):
        customer_id= random.randint(1,1000)
        order_date= f.date_between(start_date=date(2026,1,1),end_date=date(2026,7,25))

        chance=random.randint(1,100)
        if chance<=40:
            total_products=random.randint(1,3)
        elif chance<=70:
            total_products=random.randint(4,7)
        elif chance<=90:
            total_products=random.randint(8,11)
        else :
            total_products=random.randint(12,15)    

        if total_products<=3:
            packaging_cost=random.randint(10,20)
        elif total_products<=7:
            packaging_cost=random.randint(20,30)
        elif total_products<=11:
            packaging_cost=random.randint(30,40)
        else:
            packaging_cost=random.randint(45,60)

        orders.append({ 
            "customer_id":customer_id,
            "total_products":total_products,
            "order_date":order_date,
            "packaging_cost":packaging_cost
        })

orders.sort(key=lambda x:x["order_date"])
with open('orders.csv','w',newline='') as csv_file:
    csv_writer=csv.DictWriter(csv_file,fieldnames=fieldnames)
    csv_writer.writeheader()

    for order in orders:
        csv_writer.writerow(order)

       