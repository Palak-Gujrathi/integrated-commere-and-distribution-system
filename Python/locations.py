import csv 
from locations_dict import locations
import random

fieldnames=["city","state","pincode"]
with open('locations.csv','w',newline='') as csv_file:
    csv_writer=csv.DictWriter(csv_file,fieldnames=fieldnames)
    csv_writer.writeheader()
    for _ in range(100):
        state=random.choice(list(locations.keys()))
        city=random.choice(list(locations[state].keys()))
        start,end=locations[state][city]
        pincode=random.randint(start,end)
        

        csv_writer.writerow({ 
            "city":city,
            "state":state,
            "pincode":pincode
        })


