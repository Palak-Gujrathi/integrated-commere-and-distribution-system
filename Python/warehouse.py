from faker import Faker
import csv
import random

f=Faker('en_IN')
fieldnames=["capacity_sqm","locality","location_id","rent"]
with open ('warehouse.csv','w',newline="") as csv_file:
    csv_writer=csv.DictWriter(csv_file,fieldnames=fieldnames)
    csv_writer.writeheader()
    for _ in range(12):
       capacity_sqm=random.randint(800,5000)
       locality= f.street_address().replace("\n","")
       location_id= random.randint(1,100)
       rent= capacity_sqm*random.randint(80,120)

       csv_writer.writerow({
           "capacity_sqm":capacity_sqm,
           "locality":locality,
           "location_id":location_id,
           "rent":rent
       })