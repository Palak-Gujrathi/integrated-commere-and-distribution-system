import csv
import random
from datetime import datetime,timedelta


order_rows=[]
with open("orders.csv","r") as csv_file:
    csv_reader=csv.DictReader(csv_file)
    for row in csv_reader:
        order_rows.append(row)

store=[]
with open("store.csv","r") as csv_file:
    csv_reader=csv.DictReader(csv_file)
    for row in csv_reader:
        store.append(row)

store_inventory=[]
with open("store_inventory.csv","r") as csv_file:
    csv_reader=csv.DictReader(csv_file)
    for row in csv_reader:
        store_inventory.append(row)

warehouse=[]
with open("warehouse.csv","r") as csv_file:
    csv_reader=csv.DictReader(csv_file)
    for row in csv_reader:
        warehouse.append(row)

inventory=[]
with open("inventory.csv","r") as csv_file:
    csv_reader=csv.DictReader(csv_file)
    for row in csv_reader:
        inventory.append(row)

location=[]
with open("locations.csv","r") as csv_file:
    csv_reader=csv.DictReader(csv_file)
    for row in csv_reader:
        location.append(row)

customer=[]
with open("customer.csv","r") as csv_file:
    csv_reader=csv.DictReader(csv_file)
    for row in csv_reader:
        customer.append(row)



fieldnames=("shippment_id","order_id","company_id","source_warehouse","source_store","destination_locn",
             "shippment_date","delivery_date","shippment_cost","tracking_number")
with open("shippment.csv","w",newline="") as csv_file:
    csv.writer=csv.DictWriter(csv_file,fieldnames=fieldnames)
    csv.writer.writeheader()

    for shippment_id,order in enumerate(order_rows,start=1):
        order_id=shippment_id
        order_date=order["order_date"]
        customer_id = int(order["customer_id"])
        customer_location_id = None
        for customer_id_csv,customer_row in enumerate(customer,start=1):
            if customer_id_csv == customer_id:
                customer_location_id=int(customer_row["location_id"])
                break

        company_id=random.randint(1,6)

        source_store = None
        source_warehouse=None
        customer_city=None
        customer_state=None

        for location_id, loc in enumerate(location,start=1):
            if location_id == customer_location_id:
                customer_city = loc["city"]
                customer_state = loc["state"]
                break

        for s in store:
            if(int(s["location_id"]))==customer_location_id:
                source_store=s["store_id"]
                break

        for w in warehouse:
            if(int(w["location_id"]))==customer_location_id:
                source_warehouse=w["warehouse_id"]
                break

        if source_store is None and source_warehouse is None:
            for s in store:
                store_location_id=int(s["location_id"])
                for loc in location:
                    if int(loc["location_id"])==store_location_id:
                        if loc["state"] == customer_state:
                            source_store=int(s["store_id"])
                            break
                if source_store is not None:
                    break
            
        if source_store is None and source_warehouse is None:
            for w in warehouse:
                warehouse_location_id=int(w["location_id"])
                for loc in location:
                    if int(loc["location_id"])==warehouse_location_id:
                        if loc["state"] == customer_state:
                            source_warehouse=int(w["warehouse_id"])
                            break
                if source_warehouse is not None:
                    break
        if source_store is None and source_warehouse is None:
            source_warehouse = int(random.choice(warehouse)["warehouse_id"])
        destination_locn=customer_location_id
        order_date= datetime.strptime(order_date,"%Y-%m-%d").date()
        shippment_date= order_date + timedelta(days=random.randint(1,3))
        delivery_date= shippment_date + timedelta(days=random.randint(1,5))

        if int(order["total_products"])>=5:
            shippment_cost =0
        else:
            shippment_cost=random.randint(100,500)

        tracking_number=f"TRK{shippment_id:08d}"

        csv.writer.writerow({
            "shippment_id":shippment_id,
            "order_id":order_id,
            "company_id":company_id,
            "source_warehouse":source_warehouse if source_warehouse is not None else 0 ,
            "source_store":source_store if source_store is not None else 0 ,
            "destination_locn":destination_locn,
            "shippment_date":shippment_date,
            "delivery_date":delivery_date,
            "shippment_cost": shippment_cost,
            "tracking_number":tracking_number
        })