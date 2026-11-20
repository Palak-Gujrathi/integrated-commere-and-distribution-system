from faker import Faker 
import csv 
import random

f = Faker('en_IN')
fieldnames=["customer_name","street","location_id","phone","email"]
store_location=[97,75,64,101,102]
all_locations= range(1, 105)
non_store_location= [loc for loc in all_locations
                    if loc not in store_location
                    ]
with open('customer.csv','w',newline='') as csv_file:
    csv_writer=csv.DictWriter(csv_file,fieldnames=fieldnames)
    csv_writer.writeheader()
    for _ in range(400):
        location_id=random.choice(store_location)
        customer_name=f.name()
        parts=customer_name.lower().split()
        number=random.randint(10,99)
        email=f"{parts[0]}.{parts[-1]}{number}@gmail.com"
        street=f.street_address().replace("\n",' ')
        phone="+91-"+str(random.randint(6000000000,9999999999))

        csv_writer.writerow({ 
                    "customer_name":customer_name,
                    "street":street,
                    "location_id":location_id,
                    "phone":phone,
                    "email":email,
                })

    for i in range(600):
        location_id=random.choice(non_store_location)
        customer_name=f.name()
        parts=customer_name.lower().split()
        number=random.randint(10,99)
        email=f"{parts[0]}.{parts[-1]}{number}@gmail.com"
        street=f.street_address().replace("\n",' ')
        phone="+91-"+str(random.randint(6000000000,9999999999))
        
        csv_writer.writerow({ 
            "customer_name":customer_name,
            "street":street,
            "location_id":location_id,
            "phone":phone,
            "email":email,
        })

  