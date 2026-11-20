from faker import Faker
import csv
import random
from datetime import date, timedelta

f = Faker("en_IN")

salary_map = {
    "Warehouse Staff": (18000, 28000),
    "Warehouse Supervisor": (30000, 45000),
    "Cashier": (18000, 25000),
    "Sales Executive": (22000, 35000),
    "Inventory Executive": (28000, 40000),
    "Purchase Executive": (32000, 48000),
    "Accountant": (35000, 50000),
    "HR Executive": (30000, 45000),
    "Store Manager": (50000, 80000)
}

warehouse_staffing = {
    1: 5,
    2: 5,
    3: 5,
    4: 5,
    5: 6,
    6: 6,
    7: 6,
    8: 6,
    9: 6,
    10: 7,
    11: 8,
    12: 8
}

store_staffing = {
    1: 7,
    2: 7,
    3: 8,
    4: 8,
    5: 10
}

warehouse_data = {}

with open("warehouse.csv", "r", newline="", encoding="utf-8") as file:
    reader = csv.DictReader(file)

    for row in reader:
        warehouse_id = int(row["warehouse_id"])
        warehouse_data[warehouse_id] = {
            "locality": row["locality"],
            "location_id": int(row["location_id"])
        }


store_data = {}

with open("store.csv", "r", newline="", encoding="utf-8") as file:
    reader = csv.DictReader(file)

    for row in reader:
        store_id = int(row["store_id"])
        store_data[store_id] = {
            "locality": row["locality"],
            "location_id": int(row["location_id"])
        }


employee_plan = []

# Warehouse employees
for warehouse_id, count in warehouse_staffing.items():

    for i in range(count):

        if i == 0:
            designation = "Warehouse Supervisor"
        else:
            designation = "Warehouse Staff"

        locality = warehouse_data[warehouse_id]["locality"]
        location_id = warehouse_data[warehouse_id]["location_id"]

        assignment = "WH" + str(warehouse_id)

        min_salary, max_salary = salary_map[designation]

        employee_plan.append({
            "employee_name": f.name(),
            "salary": random.randint(min_salary, max_salary),
            "phone": f.unique.msisdn()[:10],
            "email_id": f.unique.email(),
            "designation": designation,
            "joining_date": date(
                random.randint(2022, 2026),
                random.randint(1, 12),
                random.randint(1, 28)
            ),
            "locality": locality,
            "location_id": location_id,
            "assignment": assignment
        })


# Store employees
store_roles = [
    "Cashier",
    "Sales Executive",
    "Inventory Executive",
    "Purchase Executive",
    "Store Manager"
]

for store_id, count in store_staffing.items():

    for i in range(count):

        if i == 0:
            designation = "Store Manager"
        else:
            designation = random.choice(store_roles[:-1])

        locality = store_data[store_id]["locality"]
        location_id = store_data[store_id]["location_id"]

        assignment = "ST" + str(store_id)

        min_salary, max_salary = salary_map[designation]

        employee_plan.append({
            "employee_name": f.name(),
            "salary": random.randint(min_salary, max_salary),
            "phone": f.unique.msisdn()[:10],
            "email_id": f.unique.email(),
            "designation": designation,
            "joining_date": date(
                random.randint(2022, 2026),
                random.randint(1, 12),
                random.randint(1, 28)
            ),
            "locality": locality,
            "location_id": location_id,
            "assignment": assignment
        })


# Central / HQ employees
central_roles = {
    "Accountant": 2,
    "HR Executive": 2
}

for designation, count in central_roles.items():

    for i in range(count):

        min_salary, max_salary = salary_map[designation]

        employee_plan.append({
            "employee_name": f.name(),
            "salary": random.randint(min_salary, max_salary),
            "phone": f.unique.msisdn()[:10],
            "email_id": f.unique.email(),
            "designation": designation,
            "joining_date": date(
                random.randint(2022, 2026),
                random.randint(1, 12),
                random.randint(1, 28)
            ),
            "locality": f.street_address(),
            "location_id": 105,
            "assignment": "HQ"
        })


# Sort employees by joining date
employee_plan.sort(key=lambda x: x["joining_date"])


# Generate CSV
fieldnames = [
    "employee_name",
    "salary",
    "phone",
    "email_id",
    "designation",
    "joining_date",
    "locality",
    "location_id",
    "assignment"
]

with open("employee.csv", "w", newline="", encoding="utf-8") as csv_file:

    writer = csv.DictWriter(
        csv_file,
        fieldnames=fieldnames
    )

    writer.writeheader()

    for employee in employee_plan:
        writer.writerow(employee)


