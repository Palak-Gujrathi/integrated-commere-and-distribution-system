from faker import Faker
import csv
import random
from datetime import date, timedelta

f=Faker()


fieldnames=["transport_id","transport_type","transport_company","source_type","source_id" ,"destination_type" ,"destination_id",
            "dispatch_date", "arrival_date","cost"]
with open('transport.csv','w',newline="") as csv_file:
    csv_writer=csv.DictWriter(csv_file,fieldnames=fieldnames)
    csv_writer.writeheader()
    for transport_id in range(1,300):
        transport_type=random.choice(["Truck","Mini-Truck","Van"])
        transport_company=random.choice(["VRL Logistics","TCI Transport","Safexpress","Gati","Rivigo","Own Fleet"])

        route = random.choice([("Dealer", "Warehouse"),
                               ("Dealer", "Store"),
                               ("Warehouse", "Store")])
        source_type=route[0]
        destination_type=route[1]

        if source_type=="Warehouse":
                    source_id=random.randint(1,12)
        else:
            source_id=random.randint(1,40)

        if destination_type=="Warehouse":
            destination_id=random.randint(1,12)
        else:
            destination_id=random.randint(1,5)


        dispatch_date=f.date_between(start_date=date(2026,1,1),end_date=date(2026,7,31))
        arrival_date=dispatch_date + timedelta(days=random.randint(1, 7))
        cost=round(random.uniform(1000, 25000),2)

        csv_writer.writerow({
             "transport_id":transport_id,
            "transport_type":transport_type,
            "transport_company":transport_company,
            "source_type":source_type,
            "source_id":source_id,
            "destination_type":destination_type,                
            "destination_id":destination_id,
            "dispatch_date":dispatch_date,
            "arrival_date":arrival_date,
            "cost":cost
        })
