from pymongo import MongoClient
from bson.objectid import ObjectId
from model import Employee

client = MongoClient("mongodb://faceverify:faceverify1234@localhost:27017/")
db = client["face_verification"]

def get_corps():
    return db.corp_view.find({})

def get_corp(id: str):
    return db.corp_view.find_one({"corp_id": ObjectId(id)})

def get_emp(username: str):
    return db.employee.find_one({"username": username})

def get_emp_by_email(email: str):
    return db.employee.find_one({"email": email})

def is_emp_exist(username: str):
    if get_emp(username) is not None:
        return True
    return False

def is_site_exist(id: str):
    if db.corp_site.find_one({"_id": ObjectId(id)}) is not None:
        return True
    return False

def register(emp: Employee):
    return db.employee.insert_one(emp)