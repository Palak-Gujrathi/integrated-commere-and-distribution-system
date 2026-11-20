from faker import Faker 
import csv 
import random

f = Faker('en_IN')
fieldnames=["dealer_name","locality","location_id","phone","email_id"]
with open('dealer.csv','w',newline='') as csv_file:
    csv_writer=csv.DictWriter(csv_file,fieldnames=fieldnames)
    csv_writer.writeheader()
    for _ in range(40):
        dealer_name=f.name()
        parts=dealer_name.lower().split()
        number=random.randint(10,99)
        email_id=f"{parts[0]}.{parts[-1]}{number}@gmail.com"
        locality=f.street_address()
        location_id=random.randint(1,100)
        phone="+91-" +str(random.randint(6000000000,9999999999))
        

        csv_writer.writerow({ 
            "dealer_name":dealer_name,
            "locality":locality,
            "location_id":location_id,
            "phone":phone,
            "email_id":email_id
        })